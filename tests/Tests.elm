module Tests exposing (suite)

import Expect exposing (FloatingPointTolerance(..))
import Test exposing (Test, describe, test)
import Xy exposing (Xy, x, xy, y)


suite : Test
suite =
    describe "Xy"
        [ test "length"
            (\() ->
                Xy.length (xy 3 4)
                    |> expectEqualFloat 5
            )
        , test "normalize"
            (\() ->
                Xy.normalize (xy 3 4)
                    |> Expect.all
                        [ x >> expectEqualFloat (3 / 5)
                        , y >> expectEqualFloat (4 / 5)
                        ]
            )
        , test "toAngle"
            (\() ->
                Expect.all
                    [ \_ -> Xy.toAngle ( 1, 1 ) |> expectEqualFloat (turns (1 / 8))
                    , \_ -> Xy.toAngle ( -1, 1 ) |> expectEqualFloat (turns (3 / 8))
                    , \_ -> Xy.toAngle ( -1, -1 ) |> expectEqualFloat -(turns (3 / 8))
                    , \_ -> Xy.toAngle ( 1, -1 ) |> expectEqualFloat -(turns (1 / 8))
                    ]
                    ()
            )
        ]


expectEqualFloat =
    Expect.within (Absolute 0.000001)
