module Generate.Example exposing (example, operation)

import Dict
import Elm
import Elm.Annotation
import Elm.Gen.GraphQL.Engine as Engine
import Elm.Gen.Json.Decode as Decode
import Elm.Gen.Json.Encode as Encode
import Elm.Gen.List
import Elm.Gen.Maybe
import Elm.Pattern
import Generate.Common
import Generate.Input
import GraphQL.Schema
import GraphQL.Schema.Argument
import GraphQL.Schema.Field
import GraphQL.Schema.Operation as Operation exposing (Operation)
import GraphQL.Schema.Type exposing (Type(..))
import Set exposing (Set)
import String
import Utils.String


{-| -}
operation :
    String
    -> GraphQL.Schema.Schema
    -> ( Generate.Input.Operation, Operation )
    -> Elm.Expression
operation namespace schema ( opType, op ) =
    create namespace
        schema
        Set.empty
        op.name
        opType
        (Elm.valueFrom
            (case opType of
                Generate.Input.Mutation ->
                    Generate.Common.modules.mutation namespace op.name
                        |> Elm.moduleName

                Generate.Input.Query ->
                    Generate.Common.modules.query namespace op.name
                        |> Elm.moduleName
            )
            (Utils.String.formatValue op.name)
        )
        op.arguments
        -- (Elm.value ("select" ++ GraphQL.Schema.Type.toString returnType))
        (Engine.select Elm.unit)


{-|

    Generates an example that demonstrates Inputs, but the selection set is only `select{Object}`

-}
example :
    String
    -> GraphQL.Schema.Schema
    -> String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : Type
            }
    -> Type
    -> Generate.Input.Operation
    -> Elm.Expression
example namespace schema name arguments returnType op =
    create namespace
        schema
        Set.empty
        name
        op
        (Elm.valueFrom
            (case op of
                Generate.Input.Mutation ->
                    Generate.Common.modules.mutation namespace name
                        |> Elm.moduleName

                Generate.Input.Query ->
                    Generate.Common.modules.query namespace name
                        |> Elm.moduleName
            )
            (Utils.String.formatValue name)
        )
        arguments
        (Elm.value ("select" ++ GraphQL.Schema.Type.toString returnType))


create :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> String
    -> Generate.Input.Operation
    -> Elm.Expression
    ->
        List
            { fieldOrArg
                | description : Maybe String.String
                , name : String.String
                , type_ : Type
            }
    -> Elm.Expression
    -> Elm.Expression
create namespace schema called name operationType base fields return =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True

        requiredArgs =
            if hasRequiredArgs then
                Just
                    (requiredArgsExample namespace schema name called required)

            else
                Nothing

        optionalArgs =
            if hasOptionalArgs then
                Just
                    (optionalArgsExample
                        namespace
                        schema
                        called
                        name
                        -- only give a maximum of 5 examples
                        (List.take 5 optional)
                        (Just operationType)
                        Set.empty
                        []
                    )

            else
                Nothing
    in
    Elm.apply
        base
        (List.filterMap identity
            [ requiredArgs
            , optionalArgs
            , Just return
            ]
        )


createEmbedded :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> String
    ->
        List
            { fieldOrArg
                | description : Maybe String.String
                , name : String.String
                , type_ : Type
            }
    -> Elm.Expression
createEmbedded namespace schema called name fields =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields

        hasRequiredArgs =
            case required of
                [] ->
                    False

                _ ->
                    True

        hasOptionalArgs =
            case optional of
                [] ->
                    False

                _ ->
                    True
    in
    if hasRequiredArgs then
        requiredArgsExample namespace schema name called fields

    else if hasOptionalArgs then
        optionalArgsExample
            namespace
            schema
            called
            name
            -- only give a maximum of 5 examples
            (List.take 5 optional)
            Nothing
            Set.empty
            []

    else
        Elm.list []


denullable : Type -> Type
denullable type_ =
    case type_ of
        GraphQL.Schema.Type.Nullable inner ->
            inner

        _ ->
            type_


optionalArgsExample :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> String.String
    -> List { a | type_ : Type, name : String.String }
    -> Maybe Generate.Input.Operation
    -> Set String
    -> List Elm.Expression
    -> Elm.Expression
optionalArgsExample namespace schema called parentName fields isTopLevel calledType prepared =
    case fields of
        [] ->
            Elm.list (List.reverse prepared)

        field :: remaining ->
            let
                typeString =
                    GraphQL.Schema.Type.toString field.type_
            in
            -- if we don't limit examples by type, then the code generation seems to hang or takea huge amount of time
            if Set.member typeString calledType then
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    calledType
                    prepared

            else
                let
                    optionalModule =
                        case isTopLevel of
                            Nothing ->
                                Elm.moduleName
                                    [ namespace
                                    , Utils.String.formatTypename parentName
                                    ]

                            Just Generate.Input.Mutation ->
                                Generate.Common.modules.mutation namespace parentName
                                    |> Elm.moduleName

                            Just Generate.Input.Query ->
                                Generate.Common.modules.query namespace parentName
                                    |> Elm.moduleName

                    unnullifiedType =
                        denullable field.type_

                    prep =
                        Elm.apply
                            (Elm.valueFrom
                                optionalModule
                                (Utils.String.formatValue field.name)
                            )
                            [ requiredArgsExampleHelper
                                namespace
                                schema
                                called
                                unnullifiedType
                                Generate.Input.UnwrappedValue
                            ]
                in
                optionalArgsExample namespace
                    schema
                    called
                    parentName
                    remaining
                    isTopLevel
                    (Set.insert typeString calledType)
                    (prep :: prepared)


{-| -}
requiredArgsExample :
    String
    -> GraphQL.Schema.Schema
    -> String
    -> Set String
    ->
        List
            { fieldOrArg
                | name : String.String
                , description : Maybe String.String
                , type_ : Type
            }
    -> Elm.Expression
requiredArgsExample namespace schema name called fields =
    let
        ( required, optional ) =
            Generate.Input.splitRequired
                fields
    in
    Elm.record
        (List.map
            (\field ->
                ( field.name
                , requiredArgsExampleHelper
                    namespace
                    schema
                    called
                    field.type_
                    Generate.Input.UnwrappedValue
                )
            )
            required
            ++ (case optional of
                    [] ->
                        []

                    _ ->
                        [ ( "with_"
                          , optionalArgsExample
                                namespace
                                schema
                                called
                                name
                                -- only give a maximum of 5 examples
                                (List.take 5 optional)
                                Nothing
                                Set.empty
                                []
                          )
                        ]
               )
        )


requiredArgsExampleHelper :
    String
    -> GraphQL.Schema.Schema
    -> Set String
    -> Type
    -> Generate.Input.Wrapped
    -> Elm.Expression
requiredArgsExampleHelper namespace schema called type_ wrapped =
    case type_ of
        GraphQL.Schema.Type.Nullable newType ->
            requiredArgsExampleHelper namespace schema called newType (Generate.Input.InMaybe wrapped)

        GraphQL.Schema.Type.List_ newType ->
            requiredArgsExampleHelper namespace schema called newType (Generate.Input.InList wrapped)

        GraphQL.Schema.Type.Scalar scalarName ->
            scalarExample scalarName
                |> Generate.Input.wrapExpression wrapped

        GraphQL.Schema.Type.Enum enumName ->
            enumExample namespace schema enumName
                |> Generate.Input.wrapExpression wrapped

        GraphQL.Schema.Type.Object nestedObjectName ->
            Elm.value ("select" ++ Utils.String.formatTypename nestedObjectName)
                |> Generate.Input.wrapExpression wrapped

        GraphQL.Schema.Type.InputObject inputName ->
            if Set.member inputName called then
                Elm.value ("additional" ++ inputName)
                    |> Generate.Input.wrapExpression wrapped

            else
                case Dict.get inputName schema.inputObjects of
                    Nothing ->
                        Elm.value inputName

                    Just input ->
                        let
                            newCalled =
                                Set.insert inputName called
                        in
                        case Generate.Input.splitRequired input.fields of
                            ( required, [] ) ->
                                Elm.record
                                    (List.map
                                        (\field ->
                                            ( field.name
                                            , requiredArgsExampleHelper namespace
                                                schema
                                                newCalled
                                                field.type_
                                                Generate.Input.UnwrappedValue
                                            )
                                        )
                                        required
                                    )
                                    |> Generate.Input.wrapExpression wrapped

                            otherwise ->
                                createEmbedded namespace
                                    schema
                                    newCalled
                                    inputName
                                    input.fields
                                    |> Generate.Input.wrapExpression wrapped

        GraphQL.Schema.Type.Union unionName ->
            Elm.unit

        GraphQL.Schema.Type.Interface interfaceName ->
            Elm.unit


enumExample : String -> GraphQL.Schema.Schema -> String -> Elm.Expression
enumExample namespace schema enumName =
    case Dict.get enumName schema.enums of
        Nothing ->
            Elm.value enumName

        Just enum ->
            case enum.values of
                [] ->
                    Elm.value enumName

                top :: _ ->
                    Elm.valueFrom
                        (Elm.moduleName
                            (Generate.Common.modules.enum namespace enumName)
                        )
                        (Utils.String.formatTypename top.name)


scalarExample : String -> Elm.Expression
scalarExample scalarName =
    case String.toLower scalarName of
        "int" ->
            Elm.int 10

        "float" ->
            Elm.float 10

        "string" ->
            Elm.string "Example..."

        "boolean" ->
            Elm.bool True

        "id" ->
            Elm.value "id"

        _ ->
            Elm.value (Utils.String.formatValue scalarName)
