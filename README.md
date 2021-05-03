## Xy

Often, a tuple is used to describe 2 coordinates.

examples: [`Collage.shift`](https://package.elm-lang.org/packages/timjs/elm-collage/latest/Collage#shift) & [`Collage.polygon`](https://package.elm-lang.org/packages/timjs/elm-collage/latest/Collage#polygon)

```elm
shift : ( Float, Float ) -> Collage msg -> Collage msg

polygon : List ( Float, Float ) -> Shape
```

This package contains simple helpers to manipulate & read 2-coordinate-tuples.

```elm
type alias Model =
    { playerPosition : Xy Float
    , playerVelocity : Xy Float
    }

update msg model =
    case msg of
        SimulatePhysics ->
            { model
                | playerPosition =
                    model.playerPosition
                        |> Xy.map2 (+) model.playerVelocity
                , playerVelocity =
                    model.playerVelocity
                        |> Xy.map ((*) 0.98)
                        |> Xy.mapY (\y -> y - 1)
            }

view { playerPosition } =
    Collage.circle 50
        |> Collage.filled (Collage.uniform Color.red)
        |> Collage.shift playerPosition
        |> Collage.Render.svg
```
