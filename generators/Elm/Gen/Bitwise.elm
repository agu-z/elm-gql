module Elm.Gen.Bitwise exposing (and, complement, id_, moduleName_, or, shiftLeftBy, shiftRightBy, shiftRightZfBy, xor)

import Elm


{-| The name of this module. -}
moduleName_ : Elm.Module
moduleName_ =
    Elm.moduleName [ "Bitwise" ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ :
    { and : Elm.Expression
    , or : Elm.Expression
    , xor : Elm.Expression
    , complement : Elm.Expression
    , shiftLeftBy : Elm.Expression
    , shiftRightBy : Elm.Expression
    , shiftRightZfBy : Elm.Expression
    }
id_ =
    { and = Elm.valueFrom moduleName_ "and"
    , or = Elm.valueFrom moduleName_ "or"
    , xor = Elm.valueFrom moduleName_ "xor"
    , complement = Elm.valueFrom moduleName_ "complement"
    , shiftLeftBy = Elm.valueFrom moduleName_ "shiftLeftBy"
    , shiftRightBy = Elm.valueFrom moduleName_ "shiftRightBy"
    , shiftRightZfBy = Elm.valueFrom moduleName_ "shiftRightZfBy"
    }


{-| Bitwise AND
-}
and : Elm.Expression -> Elm.Expression -> Elm.Expression
and arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "and") [ arg1, arg2 ]


{-| Bitwise OR
-}
or : Elm.Expression -> Elm.Expression -> Elm.Expression
or arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "or") [ arg1, arg2 ]


{-| Bitwise XOR
-}
xor : Elm.Expression -> Elm.Expression -> Elm.Expression
xor arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "xor") [ arg1, arg2 ]


{-| Flip each bit individually, often called bitwise NOT
-}
complement : Elm.Expression -> Elm.Expression
complement arg1 =
    Elm.apply (Elm.valueFrom moduleName_ "complement") [ arg1 ]


{-| Shift bits to the left by a given offset, filling new bits with zeros.
This can be used to multiply numbers by powers of two.

    shiftLeftBy 1 5 == 10
    shiftLeftBy 5 1 == 32
-}
shiftLeftBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftLeftBy arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "shiftLeftBy") [ arg1, arg2 ]


{-| Shift bits to the right by a given offset, filling new bits with
whatever is the topmost bit. This can be used to divide numbers by powers of two.

    shiftRightBy 1  32 == 16
    shiftRightBy 2  32 == 8
    shiftRightBy 1 -32 == -16

This is called an [arithmetic right shift][ars], often written `>>`, and
sometimes called a sign-propagating right shift because it fills empty spots
with copies of the highest bit.

[ars]: https://en.wikipedia.org/wiki/Bitwise_operation#Arithmetic_shift
-}
shiftRightBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftRightBy arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "shiftRightBy") [ arg1, arg2 ]


{-| Shift bits to the right by a given offset, filling new bits with zeros.

    shiftRightZfBy 1  32 == 16
    shiftRightZfBy 2  32 == 8
    shiftRightZfBy 1 -32 == 2147483632

This is called an [logical right shift][lrs], often written `>>>`, and
sometimes called a zero-fill right shift because it fills empty spots with
zeros.

[lrs]: https://en.wikipedia.org/wiki/Bitwise_operation#Logical_shift
-}
shiftRightZfBy : Elm.Expression -> Elm.Expression -> Elm.Expression
shiftRightZfBy arg1 arg2 =
    Elm.apply (Elm.valueFrom moduleName_ "shiftRightZfBy") [ arg1, arg2 ]
