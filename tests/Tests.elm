module Tests exposing (suite)

import Expect
import Test exposing (Test, describe, test)
import Xy exposing (Xy)


xy : Xy Float
xy =
    ( 27, -5.2 )


suite : Test
suite =
    describe "translate"
        []
