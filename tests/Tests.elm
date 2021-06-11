module Tests exposing (suite)

import Expect exposing (FloatingPointTolerance(..))
import Test exposing (Test, describe, test)
import Xy exposing (Xy, xy)


suite : Test
suite =
    describe "Xy"
        [ test "length"
            (\() ->
                Xy.length (xy 3 4)
                    |> Expect.within (Absolute 0.00001) 5
            )
        ]
