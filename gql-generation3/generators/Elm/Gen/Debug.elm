module Elm.Gen.Debug exposing (id_, log, moduleName_, toString, todo)

import Elm


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Debug" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { toString : Elm.Expression, log : Elm.Expression, todo : Elm.Expression }
id_ =
    { toString = Elm.valueFrom moduleName_ "toString"
    , log = Elm.valueFrom moduleName_ "log"
    , todo = Elm.valueFrom moduleName_ "todo"
    }


{-| Turn any kind of value into a string.

    toString 42                == "42"
    toString [1,2]             == "[1,2]"
    toString ('a', "cat", 13)  == "('a', \"cat\", 13)"
    toString "he said, \"hi\"" == "\"he said, \\\"hi\\\"\""

Notice that with strings, this is not the `identity` function. It escapes
characters so if you say `Html.text (toString "he said, \"hi\"")` it will
show `"he said, \"hi\""` rather than `he said, "hi"`. This makes it nice
for viewing Elm data structures.

**Note:** This is not available with `elm make --optimize` which gets rid of
a bunch of runtime metadata. For example, it shortens record field names, and
we need that info to `toString` the value! As a consequence, packages cannot
use `toString` because they may be used in `--optimize` mode.
-}
toString : Elm.Expression -> Elm.Expression
toString arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "toString") [ arg1 ]


{-| Log a tagged value on the developer console, and then return the value.

    1 + log "number" 1        -- equals 2, logs "number: 1"
    length (log "start" [])   -- equals 0, logs "start: []"

It is often possible to sprinkle this around to see if values are what you
expect. It is kind of old-school to do it this way, but it works!

**Note:** This is not available with `elm make --optimize` because (1) it
relies on `toString` which has the same restriction and (2) it is not a pure
function and would therefore have unpredictable behavior when paired with
compiler optimizations that move code around.

**Note:** If you want to create a terminal application that prints stuff out,
use ports for now. That will give you full access to reading and writing in the
terminal. We may have a package in Elm for this someday, but browser
applications are the primary focus of platform development for now.
-}
log : Elm.Expression -> Elm.Expression -> Elm.Expression
log arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "log") [ arg1, arg2 ]


{-| This is a placeholder for code that you will write later.

For example, if you are working with a large union type and have partially
completed a case expression, it may make sense to do this:

    type Entity = Ship | Fish | Captain | Seagull

    drawEntity entity =
      case entity of
        Ship ->
          ...

        Fish ->
          ...

        _ ->
          Debug.todo "handle Captain and Seagull"

The Elm compiler recognizes each `Debug.todo` so if you run into it, you get
an **uncatchable runtime exception** that includes the module name and line
number.

**Note:** This is not available with `elm make --optimize` or packages. The
idea is that a `todo` can be useful during development, but uncatchable runtime
exceptions should not appear in the resulting applications.

**Note:** For the equivalent of try/catch error handling in Elm, use modules
like [`Maybe`](#Maybe) and [`Result`](#Result) which guarantee that no error
goes unhandled!
-}
todo : Elm.Expression -> Elm.Expression
todo arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "todo") [ arg1 ]
