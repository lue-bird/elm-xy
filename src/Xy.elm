module Xy exposing
    ( Xy
    , xy, both, zero, one, direction
    , fromXY, fromSize
    , x, y, length
    , mapX, mapY
    , map, mapXY, map2, toAngle, to, normalize
    , serialize, random
    )

{-|

@docs Xy


## create

@docs xy, both, zero, one, direction


### from record

@docs fromXY, fromSize


## scan

@docs x, y, length


## modify

@docs mapX, mapY


## transform

@docs map, mapXY, map2, toAngle, to, normalize


## extra

@docs serialize, random

-}

import Random
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
fromSize : { record | width : coordinate, height : coordinate } -> Xy coordinate
fromSize record =
    xy record.width record.height


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


{-| Express the angle as a unit vector.

    Xy.direction (turns (1/6))
    --> ( 0.5000000000000001, 0.8660254037844386 )

    fromLengthAndRotation length rotation =
        Xy.direction rotation
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

    scale factor =
        Xy.map ((*) factor)

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


{-| Use the x and the y coordinate to return a result.

    ( 3, 4 ) |> Xy.to max --> 4

-}
to : (coordinate -> coordinate -> result) -> Xy coordinate -> result
to xyToResult =
    \( x_, y_ ) -> xyToResult x_ y_


{-| The angle (in radians).

```noformatingples
     ^
    /|y
   / |
  /⍺ |
 0--->
    x
```

    Xy.toAngle ( 1, 1 ) --> pi/4 radians or 45°

    Xy.toAngle ( -1, 1 ) --> 3*pi/4 radians or 135°

    Xy.toAngle ( -1, -1 ) --> -3*pi/4 radians or 225°

    Xy.toAngle ( 1, -1 ) --> -pi/4 radians or 315°

-}
toAngle : Xy Float -> Float
toAngle =
    \( x_, y_ ) -> atan2 y_ x_


{-| Convert to a unit vector.

    ( 3, 4 ) |> Xy.normalize
    --> ( 3/5, 4/5 )

-}
normalize : Xy Float -> Xy Float
normalize =
    \xy_ ->
        let
            length_ =
                length xy_
        in
        xy_ |> map (\c -> c / length_)


{-| The length of the hypotenuse

```noformatingples
 ^
y|\
 | \ length
 |  \
 0--->
    x
```

-}
length : Xy Float -> Float
length =
    sqrt << to (+) << map (\c -> c ^ 2)


{-| A [`Codec`](https://package.elm-lang.org/packages/MartinSStewart/elm-serialize/latest/) to serialize `Xy`s.

    serializePoint : Serialize.Codec error (Xy Int)
    serializePoint =
        Xy.serialize Serialize.int

-}
serialize :
    Serialize.Codec error coordinate
    -> Serialize.Codec error (Xy coordinate)
serialize serializeCoordinate =
    both serializeCoordinate |> to Serialize.tuple


{-| A `Generator` for random `Xy`s.

    randomSpeed =
        Xy.random (XY.both (Random.float -1 1))

    randomPoint =
        Xy.random
            ( Random.float left right
            , Random.float bottom top
            )

-}
random : Xy (Random.Generator coordinate) -> Random.Generator (Xy coordinate)
random randomCoordinates =
    randomCoordinates |> to (Random.map2 xy)
