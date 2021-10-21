module Elm.Gen.Basics exposing (abs, acos, always, asin, atan, atan2, ceiling, clamp, compare, cos, degrees, e, floor, fromPolar, id_, identity, isInfinite, isNaN, logBase, make_, max, min, modBy, moduleName_, negate, never, not, pi, radians, remainderBy, round, sin, sqrt, tan, toFloat, toPolar, truncate, turns, types_, xor)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Basics" ]


types_ :
    { never : Type.Annotation
    , bool : Type.Annotation
    , order : Type.Annotation
    , float : Type.Annotation
    , int : Type.Annotation
    }
types_ =
    { never = Type.named moduleName_ "Never"
    , bool = Type.named moduleName_ "Bool"
    , order = Type.named moduleName_ "Order"
    , float = Type.named moduleName_ "Float"
    , int = Type.named moduleName_ "Int"
    }


make_ :
    { bool : { true : Elm.Expression, false : Elm.Expression }
    , order : { lt : Elm.Expression, eq : Elm.Expression, gt : Elm.Expression }
    }
make_ =
    { bool =
        { true = Elm.valueWith moduleName_ "True" (Type.namedWith [] "Bool" [])
        , false =
            Elm.valueWith moduleName_ "False" (Type.namedWith [] "Bool" [])
        }
    , order =
        { lt = Elm.valueWith moduleName_ "LT" (Type.namedWith [] "Order" [])
        , eq = Elm.valueWith moduleName_ "EQ" (Type.namedWith [] "Order" [])
        , gt = Elm.valueWith moduleName_ "GT" (Type.namedWith [] "Order" [])
        }
    }


{-| Convert an integer into a float. Useful when mixing `Int` and `Float`
values like this:

    halfOf : Int -> Float
    halfOf number =
      toFloat number / 2

-}
toFloat : Elm.Expression -> Elm.Expression
toFloat arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toFloat"
            (Type.function [ Type.int ] Type.float)
        )
        [ arg1 ]


{-| Round a number to the nearest integer.

    round 1.0 == 1
    round 1.2 == 1
    round 1.5 == 2
    round 1.8 == 2

    round -1.2 == -1
    round -1.5 == -1
    round -1.8 == -2
-}
round : Elm.Expression -> Elm.Expression
round arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "round"
            (Type.function [ Type.float ] Type.int)
        )
        [ arg1 ]


{-| Floor function, rounding down.

    floor 1.0 == 1
    floor 1.2 == 1
    floor 1.5 == 1
    floor 1.8 == 1

    floor -1.2 == -2
    floor -1.5 == -2
    floor -1.8 == -2
-}
floor : Elm.Expression -> Elm.Expression
floor arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "floor"
            (Type.function [ Type.float ] Type.int)
        )
        [ arg1 ]


{-| Ceiling function, rounding up.

    ceiling 1.0 == 1
    ceiling 1.2 == 2
    ceiling 1.5 == 2
    ceiling 1.8 == 2

    ceiling -1.2 == -1
    ceiling -1.5 == -1
    ceiling -1.8 == -1
-}
ceiling : Elm.Expression -> Elm.Expression
ceiling arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "ceiling"
            (Type.function [ Type.float ] Type.int)
        )
        [ arg1 ]


{-| Truncate a number, rounding towards zero.

    truncate 1.0 == 1
    truncate 1.2 == 1
    truncate 1.5 == 1
    truncate 1.8 == 1

    truncate -1.2 == -1
    truncate -1.5 == -1
    truncate -1.8 == -1
-}
truncate : Elm.Expression -> Elm.Expression
truncate arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "truncate"
            (Type.function [ Type.float ] Type.int)
        )
        [ arg1 ]


{-| Find the larger of two comparables.

    max 42 12345678 == 12345678
    max "abc" "xyz" == "xyz"
-}
max : Elm.Expression -> Elm.Expression -> Elm.Expression
max arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "max"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.var "comparable")
            )
        )
        [ arg1, arg2 ]


{-| Find the smaller of two comparables.

    min 42 12345678 == 42
    min "abc" "xyz" == "abc"
-}
min : Elm.Expression -> Elm.Expression -> Elm.Expression
min arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "min"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.var "comparable")
            )
        )
        [ arg1, arg2 ]


{-| Compare any two comparable values. Comparable values include `String`,
`Char`, `Int`, `Float`, or a list or tuple containing comparable values. These
are also the only values that work as `Dict` keys or `Set` members.

    compare 3 4 == LT
    compare 4 4 == EQ
    compare 5 4 == GT
-}
compare : Elm.Expression -> Elm.Expression -> Elm.Expression
compare arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "compare"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.namedWith [ "Basics" ] "Order" [])
            )
        )
        [ arg1, arg2 ]


{-| Negate a boolean value.

    not True == False
    not False == True
-}
not : Elm.Expression -> Elm.Expression
not arg1 =
    Elm.apply
        (Elm.valueWith moduleName_ "not" (Type.function [ Type.bool ] Type.bool)
        )
        [ arg1 ]


{-| The exclusive-or operator. `True` if exactly one input is `True`.

    xor True  True  == False
    xor True  False == True
    xor False True  == True
    xor False False == False
-}
xor : Elm.Expression -> Elm.Expression -> Elm.Expression
xor arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "xor"
            (Type.function [ Type.bool, Type.bool ] Type.bool)
        )
        [ arg1, arg2 ]


{-| Perform [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic).
A common trick is to use (n mod 2) to detect even and odd numbers:

    modBy 2 0 == 0
    modBy 2 1 == 1
    modBy 2 2 == 0
    modBy 2 3 == 1

Our `modBy` function works in the typical mathematical way when you run into
negative numbers:

    List.map (modBy 4) [ -5, -4, -3, -2, -1,  0,  1,  2,  3,  4,  5 ]
    --                 [  3,  0,  1,  2,  3,  0,  1,  2,  3,  0,  1 ]

Use [`remainderBy`](#remainderBy) for a different treatment of negative numbers,
or read Daan Leijen’s [Division and Modulus for Computer Scientists][dm] for more
information.

[dm]: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
-}
modBy : Elm.Expression -> Elm.Expression -> Elm.Expression
modBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "modBy"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Get the remainder after division. Here are bunch of examples of dividing by four:

    List.map (remainderBy 4) [ -5, -4, -3, -2, -1,  0,  1,  2,  3,  4,  5 ]
    --                       [ -1,  0, -3, -2, -1,  0,  1,  2,  3,  0,  1 ]

Use [`modBy`](#modBy) for a different treatment of negative numbers,
or read Daan Leijen’s [Division and Modulus for Computer Scientists][dm] for more
information.

[dm]: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
-}
remainderBy : Elm.Expression -> Elm.Expression -> Elm.Expression
remainderBy arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "remainderBy"
            (Type.function [ Type.int, Type.int ] Type.int)
        )
        [ arg1, arg2 ]


{-| Negate a number.

    negate 42 == -42
    negate -42 == 42
    negate 0 == 0
-}
negate : Elm.Expression -> Elm.Expression
negate arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "negate"
            (Type.function [ Type.var "number" ] (Type.var "number"))
        )
        [ arg1 ]


{-| Get the [absolute value][abs] of a number.

    abs 16   == 16
    abs -4   == 4
    abs -8.5 == 8.5
    abs 3.14 == 3.14

[abs]: https://en.wikipedia.org/wiki/Absolute_value
-}
abs : Elm.Expression -> Elm.Expression
abs arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "abs"
            (Type.function [ Type.var "number" ] (Type.var "number"))
        )
        [ arg1 ]


{-| Clamps a number within a given range. With the expression
`clamp 100 200 x` the results are as follows:

    100     if x < 100
     x      if 100 <= x < 200
    200     if 200 <= x
-}
clamp : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
clamp arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "clamp"
            (Type.function
                [ Type.var "number", Type.var "number", Type.var "number" ]
                (Type.var "number")
            )
        )
        [ arg1, arg2, arg3 ]


{-| Take the square root of a number.

    sqrt  4 == 2
    sqrt  9 == 3
    sqrt 16 == 4
    sqrt 25 == 5
-}
sqrt : Elm.Expression -> Elm.Expression
sqrt arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sqrt"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Calculate the logarithm of a number with a given base.

    logBase 10 100 == 2
    logBase 2 256 == 8
-}
logBase : Elm.Expression -> Elm.Expression -> Elm.Expression
logBase arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "logBase"
            (Type.function [ Type.float, Type.float ] Type.float)
        )
        [ arg1, arg2 ]


{-| An approximation of e.
-}
e : Elm.Expression
e =
    Elm.valueWith moduleName_ "e" Type.float


{-| Convert degrees to standard Elm angles (radians).

    degrees 180 == 3.141592653589793
-}
degrees : Elm.Expression -> Elm.Expression
degrees arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "degrees"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Convert radians to standard Elm angles (radians).

    radians pi == 3.141592653589793
-}
radians : Elm.Expression -> Elm.Expression
radians arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "radians"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Convert turns to standard Elm angles (radians). One turn is equal to 360°.

    turns (1/2) == 3.141592653589793
-}
turns : Elm.Expression -> Elm.Expression
turns arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "turns"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| An approximation of pi.
-}
pi : Elm.Expression
pi =
    Elm.valueWith moduleName_ "pi" Type.float


{-| Figure out the cosine given an angle in radians.

    cos (degrees 60)     == 0.5000000000000001
    cos (turns (1/6))    == 0.5000000000000001
    cos (radians (pi/3)) == 0.5000000000000001
    cos (pi/3)           == 0.5000000000000001

-}
cos : Elm.Expression -> Elm.Expression
cos arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "cos"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Figure out the sine given an angle in radians.

    sin (degrees 30)     == 0.49999999999999994
    sin (turns (1/12))   == 0.49999999999999994
    sin (radians (pi/6)) == 0.49999999999999994
    sin (pi/6)           == 0.49999999999999994

-}
sin : Elm.Expression -> Elm.Expression
sin arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "sin"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Figure out the tangent given an angle in radians.

    tan (degrees 45)     == 0.9999999999999999
    tan (turns (1/8))    == 0.9999999999999999
    tan (radians (pi/4)) == 0.9999999999999999
    tan (pi/4)           == 0.9999999999999999
-}
tan : Elm.Expression -> Elm.Expression
tan arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "tan"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Figure out the arccosine for `adjacent / hypotenuse` in radians:

    acos (1/2) == 1.0471975511965979 -- 60° or pi/3 radians

-}
acos : Elm.Expression -> Elm.Expression
acos arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "acos"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| Figure out the arcsine for `opposite / hypotenuse` in radians:

    asin (1/2) == 0.5235987755982989 -- 30° or pi/6 radians

-}
asin : Elm.Expression -> Elm.Expression
asin arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "asin"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| This helps you find the angle (in radians) to an `(x,y)` coordinate, but
in a way that is rarely useful in programming. **You probably want
[`atan2`](#atan2) instead!**

This version takes `y/x` as its argument, so there is no way to know whether
the negative signs comes from the `y` or `x` value. So as we go counter-clockwise
around the origin from point `(1,1)` to `(1,-1)` to `(-1,-1)` to `(-1,1)` we do
not get angles that go in the full circle:

    atan (  1 /  1 ) ==  0.7853981633974483 --  45° or   pi/4 radians
    atan (  1 / -1 ) == -0.7853981633974483 -- 315° or 7*pi/4 radians
    atan ( -1 / -1 ) ==  0.7853981633974483 --  45° or   pi/4 radians
    atan ( -1 /  1 ) == -0.7853981633974483 -- 315° or 7*pi/4 radians

Notice that everything is between `pi/2` and `-pi/2`. That is pretty useless
for figuring out angles in any sort of visualization, so again, check out
[`atan2`](#atan2) instead!
-}
atan : Elm.Expression -> Elm.Expression
atan arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "atan"
            (Type.function [ Type.float ] Type.float)
        )
        [ arg1 ]


{-| This helps you find the angle (in radians) to an `(x,y)` coordinate.
So rather than saying `atan (y/x)` you say `atan2 y x` and you can get a full
range of angles:

    atan2  1  1 ==  0.7853981633974483 --  45° or   pi/4 radians
    atan2  1 -1 ==  2.356194490192345  -- 135° or 3*pi/4 radians
    atan2 -1 -1 == -2.356194490192345  -- 225° or 5*pi/4 radians
    atan2 -1  1 == -0.7853981633974483 -- 315° or 7*pi/4 radians

-}
atan2 : Elm.Expression -> Elm.Expression -> Elm.Expression
atan2 arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "atan2"
            (Type.function [ Type.float, Type.float ] Type.float)
        )
        [ arg1, arg2 ]


{-| Convert Cartesian coordinates (x,y) to polar coordinates (r,&theta;).

    toPolar (3, 4) == ( 5, 0.9272952180016122)
    toPolar (5,12) == (13, 1.1760052070951352)
-}
toPolar : Elm.Expression -> Elm.Expression
toPolar arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "toPolar"
            (Type.function
                [ Type.tuple Type.float Type.float ]
                (Type.tuple Type.float Type.float)
            )
        )
        [ arg1 ]


{-| Convert polar coordinates (r,&theta;) to Cartesian coordinates (x,y).

    fromPolar (sqrt 2, degrees 45) == (1, 1)
-}
fromPolar : Elm.Expression -> Elm.Expression
fromPolar arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "fromPolar"
            (Type.function
                [ Type.tuple Type.float Type.float ]
                (Type.tuple Type.float Type.float)
            )
        )
        [ arg1 ]


{-| Determine whether a float is an undefined or unrepresentable number.
NaN stands for *not a number* and it is [a standardized part of floating point
numbers](https://en.wikipedia.org/wiki/NaN).

    isNaN (0/0)     == True
    isNaN (sqrt -1) == True
    isNaN (1/0)     == False  -- infinity is a number
    isNaN 1         == False
-}
isNaN : Elm.Expression -> Elm.Expression
isNaN arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isNaN"
            (Type.function [ Type.float ] Type.bool)
        )
        [ arg1 ]


{-| Determine whether a float is positive or negative infinity.

    isInfinite (0/0)     == False
    isInfinite (sqrt -1) == False
    isInfinite (1/0)     == True
    isInfinite 1         == False

Notice that NaN is not infinite! For float `n` to be finite implies that
`not (isInfinite n || isNaN n)` evaluates to `True`.
-}
isInfinite : Elm.Expression -> Elm.Expression
isInfinite arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "isInfinite"
            (Type.function [ Type.float ] Type.bool)
        )
        [ arg1 ]


{-| Given a value, returns exactly the same value. This is called
[the identity function](https://en.wikipedia.org/wiki/Identity_function).
-}
identity : Elm.Expression -> Elm.Expression
identity arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "identity"
            (Type.function [ Type.var "a" ] (Type.var "a"))
        )
        [ arg1 ]


{-| Create a function that *always* returns the same value. Useful with
functions like `map`:

    List.map (always 0) [1,2,3,4,5] == [0,0,0,0,0]

    -- List.map (\_ -> 0) [1,2,3,4,5] == [0,0,0,0,0]
    -- always = (\x _ -> x)
-}
always : Elm.Expression -> Elm.Expression -> Elm.Expression
always arg1 arg2 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "always"
            (Type.function [ Type.var "a", Type.var "b" ] (Type.var "a"))
        )
        [ arg1, arg2 ]


{-| A function that can never be called. Seems extremely pointless, but it
*can* come in handy. Imagine you have some HTML that should never produce any
messages. And say you want to use it in some other HTML that *does* produce
messages. You could say:

    import Html exposing (..)

    embedHtml : Html Never -> Html msg
    embedHtml staticStuff =
      div []
        [ text "hello"
        , Html.map never staticStuff
        ]

So the `never` function is basically telling the type system, make sure no one
ever calls me!
-}
never : Elm.Expression -> Elm.Expression
never arg1 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "never"
            (Type.function
                [ Type.namedWith [ "Basics" ] "Never" [] ]
                (Type.var "a")
            )
        )
        [ arg1 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { toFloat : Elm.Expression
    , round : Elm.Expression
    , floor : Elm.Expression
    , ceiling : Elm.Expression
    , truncate : Elm.Expression
    , max : Elm.Expression
    , min : Elm.Expression
    , compare : Elm.Expression
    , not : Elm.Expression
    , xor : Elm.Expression
    , modBy : Elm.Expression
    , remainderBy : Elm.Expression
    , negate : Elm.Expression
    , abs : Elm.Expression
    , clamp : Elm.Expression
    , sqrt : Elm.Expression
    , logBase : Elm.Expression
    , e : Elm.Expression
    , degrees : Elm.Expression
    , radians : Elm.Expression
    , turns : Elm.Expression
    , pi : Elm.Expression
    , cos : Elm.Expression
    , sin : Elm.Expression
    , tan : Elm.Expression
    , acos : Elm.Expression
    , asin : Elm.Expression
    , atan : Elm.Expression
    , atan2 : Elm.Expression
    , toPolar : Elm.Expression
    , fromPolar : Elm.Expression
    , isNaN : Elm.Expression
    , isInfinite : Elm.Expression
    , identity : Elm.Expression
    , always : Elm.Expression
    , never : Elm.Expression
    }
id_ =
    { toFloat =
        Elm.valueWith
            moduleName_
            "toFloat"
            (Type.function [ Type.int ] Type.float)
    , round =
        Elm.valueWith
            moduleName_
            "round"
            (Type.function [ Type.float ] Type.int)
    , floor =
        Elm.valueWith
            moduleName_
            "floor"
            (Type.function [ Type.float ] Type.int)
    , ceiling =
        Elm.valueWith
            moduleName_
            "ceiling"
            (Type.function [ Type.float ] Type.int)
    , truncate =
        Elm.valueWith
            moduleName_
            "truncate"
            (Type.function [ Type.float ] Type.int)
    , max =
        Elm.valueWith
            moduleName_
            "max"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.var "comparable")
            )
    , min =
        Elm.valueWith
            moduleName_
            "min"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.var "comparable")
            )
    , compare =
        Elm.valueWith
            moduleName_
            "compare"
            (Type.function
                [ Type.var "comparable", Type.var "comparable" ]
                (Type.namedWith [ "Basics" ] "Order" [])
            )
    , not =
        Elm.valueWith moduleName_ "not" (Type.function [ Type.bool ] Type.bool)
    , xor =
        Elm.valueWith
            moduleName_
            "xor"
            (Type.function [ Type.bool, Type.bool ] Type.bool)
    , modBy =
        Elm.valueWith
            moduleName_
            "modBy"
            (Type.function [ Type.int, Type.int ] Type.int)
    , remainderBy =
        Elm.valueWith
            moduleName_
            "remainderBy"
            (Type.function [ Type.int, Type.int ] Type.int)
    , negate =
        Elm.valueWith
            moduleName_
            "negate"
            (Type.function [ Type.var "number" ] (Type.var "number"))
    , abs =
        Elm.valueWith
            moduleName_
            "abs"
            (Type.function [ Type.var "number" ] (Type.var "number"))
    , clamp =
        Elm.valueWith
            moduleName_
            "clamp"
            (Type.function
                [ Type.var "number", Type.var "number", Type.var "number" ]
                (Type.var "number")
            )
    , sqrt =
        Elm.valueWith
            moduleName_
            "sqrt"
            (Type.function [ Type.float ] Type.float)
    , logBase =
        Elm.valueWith
            moduleName_
            "logBase"
            (Type.function [ Type.float, Type.float ] Type.float)
    , e = Elm.valueWith moduleName_ "e" Type.float
    , degrees =
        Elm.valueWith
            moduleName_
            "degrees"
            (Type.function [ Type.float ] Type.float)
    , radians =
        Elm.valueWith
            moduleName_
            "radians"
            (Type.function [ Type.float ] Type.float)
    , turns =
        Elm.valueWith
            moduleName_
            "turns"
            (Type.function [ Type.float ] Type.float)
    , pi = Elm.valueWith moduleName_ "pi" Type.float
    , cos =
        Elm.valueWith
            moduleName_
            "cos"
            (Type.function [ Type.float ] Type.float)
    , sin =
        Elm.valueWith
            moduleName_
            "sin"
            (Type.function [ Type.float ] Type.float)
    , tan =
        Elm.valueWith
            moduleName_
            "tan"
            (Type.function [ Type.float ] Type.float)
    , acos =
        Elm.valueWith
            moduleName_
            "acos"
            (Type.function [ Type.float ] Type.float)
    , asin =
        Elm.valueWith
            moduleName_
            "asin"
            (Type.function [ Type.float ] Type.float)
    , atan =
        Elm.valueWith
            moduleName_
            "atan"
            (Type.function [ Type.float ] Type.float)
    , atan2 =
        Elm.valueWith
            moduleName_
            "atan2"
            (Type.function [ Type.float, Type.float ] Type.float)
    , toPolar =
        Elm.valueWith
            moduleName_
            "toPolar"
            (Type.function
                [ Type.tuple Type.float Type.float ]
                (Type.tuple Type.float Type.float)
            )
    , fromPolar =
        Elm.valueWith
            moduleName_
            "fromPolar"
            (Type.function
                [ Type.tuple Type.float Type.float ]
                (Type.tuple Type.float Type.float)
            )
    , isNaN =
        Elm.valueWith
            moduleName_
            "isNaN"
            (Type.function [ Type.float ] Type.bool)
    , isInfinite =
        Elm.valueWith
            moduleName_
            "isInfinite"
            (Type.function [ Type.float ] Type.bool)
    , identity =
        Elm.valueWith
            moduleName_
            "identity"
            (Type.function [ Type.var "a" ] (Type.var "a"))
    , always =
        Elm.valueWith
            moduleName_
            "always"
            (Type.function [ Type.var "a", Type.var "b" ] (Type.var "a"))
    , never =
        Elm.valueWith
            moduleName_
            "never"
            (Type.function
                [ Type.namedWith [ "Basics" ] "Never" [] ]
                (Type.var "a")
            )
    }


