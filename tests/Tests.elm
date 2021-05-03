module Tests exposing (..)

import Expect
import Test exposing (Test, describe, test)
import XY exposing (XY)


xy : XY Float
xy =
    ( 27, -5.2 )


suite : Test
suite =
    describe "translate"
        []
