module Xy exposing
    ( Xy
    , both, zero, one, direction
    , x, y
    , toString, map, map2
    , mapX, mapY
    , serialize
    , mapXY, xy
    )

{-|

@docs Xy


## create

@docs both, zero, one, direction


## scan

@docs x, y


## transform

@docs toString, map, mapXy, map2


### modify

@docs mapX, mapY


## extra

@docs serialize

-}

import Serialize


{-| A tuple, containing 2 coordinates of the same type.
-}
type alias Xy coordinate =
    ( coordinate, coordinate )



-- ## create


{-| Construct a `Xy` from first the x, the the y coordinate.
-}
xy : coordinate -> coordinate -> Xy coordinate
xy =
    Tuple.pair


{-| Construct a `Xy` from the same value for the x & y coordinates.

    Xy.both 0 --> ( 0, 0 )

-}
both : a -> Xy a
both a =
    xy a a


{-| Construct a `Xy` where the x & y coordinates are 0.

    Xy.zero --> ( 0, 0 )

-}
zero : Xy number
zero =
    both 0


{-| Construct a `Xy` where the x & y coordinates are 1.

    Xy.one --> ( 1, 1 )

-}
one : Xy number
one =
    both 1


{-| Express the direction as a `Xy`-vector.

    Xy.direction (turns (1/6))
    --> ( 0.5000000000000001, 0.8660254037844386 )

    fromAbsAndRotation length direction =
        Xy.direction direction
            >> Xy.map ((*) length)

-}
direction : Float -> Xy Float
direction radians =
    both radians |> mapXY cos sin



-- ## scan


{-| The x coordinate.

    ( 3, 5 ) |> Xy.x --> 3

-}
x : Xy coordinate -> coordinate
x =
    Tuple.first


{-| The y coordinate.

    ( 3, 5 ) |> Xy.y --> 5

-}
y : Xy coordinate -> coordinate
y =
    Tuple.second



-- ## modify


mapX : (a -> a) -> Xy a -> Xy a
mapX xUpdate =
    Tuple.mapFirst xUpdate


mapY : (a -> a) -> Xy a -> Xy a
mapY xUpdate =
    Tuple.mapSecond xUpdate


mapXY : (a -> mapped) -> (a -> mapped) -> Xy a -> Xy mapped
mapXY xMap yMap =
    Tuple.mapBoth xMap yMap


{-| Apply a function to both coordinates.

    ( 4.567, 4.321 ) |> Xy.map round
    --> ( 5, 4 )

-}
map : (a -> mapped) -> Xy a -> Xy mapped
map mapBoth =
    Tuple.mapBoth mapBoth mapBoth


{-| Apply a function combining the x & y coordinates of 2 `Xy`s.

    Xy.map2 (\a b -> a - b) ( 10, 5 ) ( 5, 1 )
    --> ( 5, 4 )

    Xy.map2 (+) ( 10, 5 ) ( 5, 1 )
    --> ( 15, 6 )

-}
map2 : (a -> b -> combined) -> Xy a -> Xy b -> Xy combined
map2 combine a b =
    b |> mapXY (combine (x a)) (combine (y a))


{-| A short string showing both coordinates in a tuple.

    ( 3, 5 ) --> "( 3, 5 )"

-}
toString : (a -> String) -> Xy a -> String
toString valueToString =
    map valueToString
        >> (\( x_, y_ ) -> "( x " ++ x_ ++ " | y " ++ y_ ++ " )")


serialize : Serialize.Codec error a -> Serialize.Codec error (Xy a)
serialize serializeCoordinate =
    Serialize.tuple serializeCoordinate serializeCoordinate
