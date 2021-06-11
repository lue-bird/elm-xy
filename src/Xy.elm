module Xy exposing
    ( Xy
    , xy, both, zero, one, direction
    , fromXY, fromSize
    , x, y
    , mapX, mapY
    , map, mapXY, map2, toAngle
    , serialize
    )

{-|

@docs Xy


## create

@docs xy, both, zero, one, direction


### from record

@docs fromXY, fromSize


## scan

@docs x, y


## modify

@docs mapX, mapY


## transform

@docs map, mapXY, map2, toAngle


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


{-| Construct a `Xy` from the `x` and `y` fields contained in a record.

    initialPosition : Xy Float
    initialPosition =
        Browser.getViewport
            |> Task.perform (.viewport >> Xy.fromXY)

[Browser.getViewport link](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewport).

-}
fromXY : { record | x : coordinate, y : coordinate } -> Xy coordinate
fromXY record =
    xy record.x record.y


{-| Construct a `Xy` from the `width` and `height` fields contained in a record.

    initialSize : Xy Float
    initialSize =
        Browser.getViewport
            |> Task.perform (.viewport >> Xy.fromSize)

[Browser.getViewport link](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewport).

-}
fromSize : { record | x : coordinate, y : coordinate } -> Xy coordinate
fromSize record =
    xy record.x record.y


{-| Construct a `Xy` from the same value for the x & y coordinates.

    Xy.both 0 --> ( 0, 0 )

-}
both : coordinate -> Xy coordinate
both valueOfBothCoordinates =
    xy valueOfBothCoordinates valueOfBothCoordinates


{-| Construct a `Xy` where the x & y coordinates are 0.

    Xy.zero --> ( 0, 0 )

-}
zero : Xy numberCoordinate
zero =
    both 0


{-| Construct a `Xy` where the x & y coordinates are 1.

    Xy.one --> ( 1, 1 )

-}
one : Xy numberCoordinate
one =
    both 1


{-| Express the angle as a `Xy`-vector.

    Xy.direction (turns (1/6))
    --> ( 0.5000000000000001, 0.8660254037844386 )

    fromLengthAndRotation length direction =
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


{-| Update the x coordinate based on its current value.

    flipX =
        XY.mapX (\x -> -x)

-}
mapX :
    (coordinate -> coordinate)
    -> Xy coordinate
    -> Xy coordinate
mapX xUpdate =
    Tuple.mapFirst xUpdate


{-| Update the y coordinate based on its current value.

    flipY =
        XY.mapY (\y -> -y)

-}
mapY :
    (coordinate -> coordinate)
    -> Xy coordinate
    -> Xy coordinate
mapY xUpdate =
    Tuple.mapSecond xUpdate


{-| Apply a different function to the x & y coordinate.

    ( 4.567, 4.321 ) |> Xy.mapXY floor ceiling
    --> ( 4, 5 ) : Xy Int

-}
mapXY :
    (coordinate -> mappedCoordinate)
    -> (coordinate -> mappedCoordinate)
    -> Xy coordinate
    -> Xy mappedCoordinate
mapXY xMap yMap =
    Tuple.mapBoth xMap yMap


{-| Apply the same function to both coordinates.

    ( 4.567, 4.321 ) |> Xy.map round
    --> ( 5, 4 ) : Xy Int

    opposite =
        Xy.map (\coord -> -coord)

-}
map :
    (coordinate -> mappedCoordinate)
    -> Xy coordinate
    -> Xy mappedCoordinate
map mapBothXAndY =
    mapXY mapBothXAndY mapBothXAndY


{-| Apply a function combining the x & y coordinates of 2 `Xy`s.

    Xy.map2 (\a b -> a - b) ( 10, 5 ) ( 5, 1 )
    --> ( 5, 4 )

    Xy.map2 (+) ( 10, 5 ) ( 5, 1 )
    --> ( 15, 6 )

-}
map2 :
    (aCoordinate -> bCoordinate -> combinedCoordinate)
    -> Xy aCoordinate
    -> Xy bCoordinate
    -> Xy combinedCoordinate
map2 combine a b =
    b |> mapXY (combine (x a)) (combine (y a))


{-| The angle (in radians) to an `Xy`.

    Xy.toAngle ( 1, 1 ) --> pi/4 radians or 45°

    Xy.toAngle ( 1, -1 ) --> 3*pi/4 radians or 135°

    Xy.toAngle ( -1, -1 ) --> 5*pi/4 radians or 225°

    Xy.toAngle ( -1, 1 ) --> 7*pi/4 radians or 315°

-}
toAngle : Xy Float -> Float
toAngle direction_ =
    atan2 (y direction_) (x direction_)


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Xy`s.

    serializePoint : Serialize.Codec error (Xy Int)
    serializePoint =
        Xy.serialize Serialize.int

-}
serialize :
    Serialize.Codec error coordinate
    -> Serialize.Codec error (Xy coordinate)
serialize serializeCoordinate =
    Serialize.tuple serializeCoordinate serializeCoordinate
