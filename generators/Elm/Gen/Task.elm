module Elm.Gen.Task exposing (andThen, attempt, fail, id_, make_, map, map2, map3, map4, map5, mapError, moduleName_, onError, perform, sequence, succeed, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Task" ]


types_ : { task : Type.Annotation -> Type.Annotation -> Type.Annotation }
types_ =
    { task = \arg0 arg1 -> Type.namedWith moduleName_ "Task" [ arg0, arg1 ] }


make_ : {}
make_ =
    {}


{-| Like I was saying in the [`Task`](#Task) documentation, just having a
`Task` does not mean it is done. We must command Elm to `perform` the task:

    import Time  -- elm install elm/time
    import Task

    type Msg
      = Click
      | Search String
      | NewTime Time.Posix

    getNewTime : Cmd Msg
    getNewTime =
      Task.perform NewTime Time.now

If you have worked through [`guide.elm-lang.org`][guide] (highly recommended!)
you will recognize `Cmd` from the section on The Elm Architecture. So we have
changed a task like "make delicious lasagna" into a command like "Hey Elm, make
delicious lasagna and give it to my `update` function as a `Msg` value."

[guide]: https://guide.elm-lang.org/
-}
perform : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
perform arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "perform"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "msg")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.namedWith [ "Basics" ] "Never" [], Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| This is very similar to [`perform`](#perform) except it can handle failures!
So we could _attempt_ to focus on a certain DOM node like this:

    import Browser.Dom  -- elm install elm/browser
    import Task

    type Msg
      = Click
      | Search String
      | Focus (Result Browser.DomError ())

    focus : Cmd Msg
    focus =
      Task.attempt Focus (Browser.Dom.focus "my-app-search-box")

So the task is "focus on this DOM node" and we are turning it into the command
"Hey Elm, attempt to focus on this DOM node and give me a `Msg` about whether
you succeeded or failed."

**Note:** Definitely work through [`guide.elm-lang.org`][guide] to get a
feeling for how commands fit into The Elm Architecture.

[guide]: https://guide.elm-lang.org/
-}
attempt : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
attempt arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "attempt"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Chain together a task and a callback. The first task will run, and if it is
successful, you give the result to the callback resulting in another task. This
task then gets run. We could use this to make a task that resolves an hour from
now:

    import Time -- elm install elm/time
    import Process

    timeInOneHour : Task x Time.Posix
    timeInOneHour =
      Process.sleep (60 * 60 * 1000)
        |> andThen (\_ -> Time.now)

First the process sleeps for an hour **and then** it tells us what time it is.
-}
andThen : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
andThen arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "x", Type.var "b" ]
                    )
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| A task that succeeds immediately when run. It is usually used with
[`andThen`](#andThen). You can use it like `map` if you want:

    import Time -- elm install elm/time

    timeInMillis : Task x Int
    timeInMillis =
      Time.now
        |> andThen (\t -> succeed (Time.posixToMillis t))

-}
succeed : Elm.Expression -> Elm.Expression
succeed arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| A task that fails immediately when run. Like with `succeed`, this can be
used with `andThen` to check on the outcome of another task.

    type Error = NotFound

    notFound : Task Error a
    notFound =
      fail NotFound
-}
fail : Elm.Expression -> Elm.Expression
fail arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.var "x" ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
        )
        [ arg1 ]


{-| Start with a list of tasks, and turn them into a single task that returns a
list. The tasks will be run in order one-by-one and if any task fails the whole
sequence fails.

    sequence [ succeed 1, succeed 2 ] == succeed [ 1, 2 ]

-}
sequence : Elm.Expression -> Elm.Expression
sequence arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sequence"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.list (Type.var "a") ]
                )
            )
        )
        [ arg1 ]


{-| Transform a task. Maybe you want to use [`elm/time`][time] to figure
out what time it will be in one hour:

    import Task exposing (Task)
    import Time -- elm install elm/time

    timeInOneHour : Task x Time.Posix
    timeInOneHour =
      Task.map addAnHour Time.now

    addAnHour : Time.Posix -> Time.Posix
    addAnHour time =
      Time.millisToPosix (Time.posixToMillis time + 60 * 60 * 1000)

[time]: /packages/elm/time/latest/
-}
map : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
map arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "b" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Put the results of two tasks together. For example, if we wanted to know
the current month, we could use [`elm/time`][time] to ask:

    import Task exposing (Task)
    import Time -- elm install elm/time

    getMonth : Task x Int
    getMonth =
      Task.map2 Time.toMonth Time.here Time.now

**Note:** Say we were doing HTTP requests instead. `map2` does each task in
order, so it would try the first request and only continue after it succeeds.
If it fails, the whole thing fails!

[time]: /packages/elm/time/latest/
-}
map2 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map2 arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass, arg2, arg3 ]


{-|-}
map3 :
    (Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map3 arg1 arg2 arg3 arg4 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4 ]


{-|-}
map4 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map4 arg1 arg2 arg3 arg4 arg5 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "d" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass, arg2, arg3, arg4, arg5 ]


{-|-}
map5 :
    (Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression)
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
    -> Elm.Expression
map5 arg1 arg2 arg3 arg4 arg5 arg6 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "d" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "e" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
        )
        [ arg1 Elm.pass Elm.pass Elm.pass Elm.pass Elm.pass
        , arg2
        , arg3
        , arg4
        , arg5
        , arg6
        ]


{-| Recover from a failure in a task. If the given task fails, we use the
callback to recover.

    fail "file not found"
      |> onError (\msg -> succeed 42)
      -- succeed 42

    succeed 9
      |> onError (\msg -> succeed 42)
      -- succeed 9
-}
onError : (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
onError arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "onError"
            (Type.function
                [ Type.function
                    [ Type.var "x" ]
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "y", Type.var "a" ]
                    )
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "y", Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Transform the error value. This can be useful if you need a bunch of error
types to match up.

    type Error
      = Http Http.Error
      | WebGL WebGL.Error

    getResources : Task Error Resource
    getResources =
      sequence
        [ mapError Http serverTask
        , mapError WebGL textureTask
        ]
-}
mapError :
    (Elm.Expression -> Elm.Expression) -> Elm.Expression -> Elm.Expression
mapError arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "mapError"
            (Type.function
                [ Type.function [ Type.var "x" ] (Type.var "y")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "y", Type.var "a" ]
                )
            )
        )
        [ arg1 Elm.pass, arg2 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { perform : Elm.Expression
    , attempt : Elm.Expression
    , andThen : Elm.Expression
    , succeed : Elm.Expression
    , fail : Elm.Expression
    , sequence : Elm.Expression
    , map : Elm.Expression
    , map2 : Elm.Expression
    , map3 : Elm.Expression
    , map4 : Elm.Expression
    , map5 : Elm.Expression
    , onError : Elm.Expression
    , mapError : Elm.Expression
    }
id_ =
    { perform =
        Elm.valueWith
            moduleName_
            "perform"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "msg")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.namedWith [ "Basics" ] "Never" [], Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , attempt =
        Elm.valueWith
            moduleName_
            "attempt"
            (Type.function
                [ Type.function
                    [ Type.namedWith
                        [ "Result" ]
                        "Result"
                        [ Type.var "x", Type.var "a" ]
                    ]
                    (Type.var "msg")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Platform", "Cmd" ] "Cmd" [ Type.var "msg" ])
            )
    , andThen =
        Elm.valueWith
            moduleName_
            "andThen"
            (Type.function
                [ Type.function
                    [ Type.var "a" ]
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "x", Type.var "b" ]
                    )
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "b" ]
                )
            )
    , succeed =
        Elm.valueWith
            moduleName_
            "succeed"
            (Type.function
                [ Type.var "a" ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
    , fail =
        Elm.valueWith
            moduleName_
            "fail"
            (Type.function
                [ Type.var "x" ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "a" ]
                )
            )
    , sequence =
        Elm.valueWith
            moduleName_
            "sequence"
            (Type.function
                [ Type.list
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "x", Type.var "a" ]
                    )
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.list (Type.var "a") ]
                )
            )
    , map =
        Elm.valueWith
            moduleName_
            "map"
            (Type.function
                [ Type.function [ Type.var "a" ] (Type.var "b")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "x", Type.var "b" ]
                )
            )
    , map2 =
        Elm.valueWith
            moduleName_
            "map2"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
    , map3 =
        Elm.valueWith
            moduleName_
            "map3"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
    , map4 =
        Elm.valueWith
            moduleName_
            "map4"
            (Type.function
                [ Type.function
                    [ Type.var "a", Type.var "b", Type.var "c", Type.var "d" ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "d" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
    , map5 =
        Elm.valueWith
            moduleName_
            "map5"
            (Type.function
                [ Type.function
                    [ Type.var "a"
                    , Type.var "b"
                    , Type.var "c"
                    , Type.var "d"
                    , Type.var "e"
                    ]
                    (Type.var "result")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "b" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "c" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "d" ]
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "e" ]
                ]
                (Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "result" ]
                )
            )
    , onError =
        Elm.valueWith
            moduleName_
            "onError"
            (Type.function
                [ Type.function
                    [ Type.var "x" ]
                    (Type.namedWith
                        [ "Task" ]
                        "Task"
                        [ Type.var "y", Type.var "a" ]
                    )
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "y", Type.var "a" ]
                )
            )
    , mapError =
        Elm.valueWith
            moduleName_
            "mapError"
            (Type.function
                [ Type.function [ Type.var "x" ] (Type.var "y")
                , Type.namedWith
                    [ "Task" ]
                    "Task"
                    [ Type.var "x", Type.var "a" ]
                ]
                (Type.namedWith [ "Task" ] "Task" [ Type.var "y", Type.var "a" ]
                )
            )
    }


