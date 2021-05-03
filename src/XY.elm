module XY exposing (XY, both, combine2, map, mapX, mapXY, mapY, one, serialize, toString, x, xy, y, zero)

import Serialize


type alias XY a =
    ( a, a )


xy : a -> a -> XY a
xy =
    Tuple.pair


x : XY a -> a
x =
    Tuple.first


y : XY a -> a
y =
    Tuple.second


both : a -> XY a
both a =
    xy a a


zero : XY number
zero =
    both 0


one : XY number
one =
    both 1


mapX : (a -> a) -> XY a -> XY a
mapX xUpdate =
    Tuple.mapFirst xUpdate


mapY : (a -> a) -> XY a -> XY a
mapY xUpdate =
    Tuple.mapSecond xUpdate


mapXY : (a -> mapped) -> (a -> mapped) -> XY a -> XY mapped
mapXY xMap yMap =
    Tuple.mapBoth xMap yMap


map : (a -> b) -> XY a -> XY b
map mapBoth =
    Tuple.mapBoth mapBoth mapBoth


combine2 : (a -> b -> combined) -> XY a -> XY b -> XY combined
combine2 combine a b =
    b |> mapXY (combine (x a)) (combine (y a))


toString : (a -> String) -> XY a -> String
toString valueToString =
    map valueToString
        >> (\( x_, y_ ) -> "( x " ++ x_ ++ " | y " ++ y_ ++ " )")


serialize : Serialize.Codec error a -> Serialize.Codec error (XY a)
serialize serializeCoordinate =
    Serialize.tuple serializeCoordinate serializeCoordinate
