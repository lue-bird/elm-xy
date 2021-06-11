## Xy

Commonly, a tuple is used to describe 2 coordinates `( x, y )` of

  - a point
  - a dimension
  - a velocity
  - ...

examples:
  - [`Playground.polygon`](https://package.elm-lang.org/packages/justgook/webgl-playground/5.0.0/Playground#polygon), [`Playground.toXY`](https://package.elm-lang.org/packages/justgook/webgl-playground/5.0.0/Playground#toXY), ...

    ```elm
    polygon : Color -> List ( Float, Float ) -> Shape

    toXY : Keyboard -> ( Float, Float )
    ```
  - [`Collage.shift`](https://package.elm-lang.org/packages/timjs/elm-collage/latest/Collage#shift), [`Collage.polygon`](https://package.elm-lang.org/packages/timjs/elm-collage/latest/Collage#polygon), ...
    ```elm
    shift : ( Float, Float ) -> Collage msg -> Collage msg

    polygon : List ( Float, Float ) -> Shape
    ```

This package contains simple helpers to _create, transform & read 2-coordinate-tuples_.

```elm
import Xy exposing (Xy)

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

another example

```elm
type alias Model =
    { windowSize : Xy Float }

init =
    ( { windowSize = Xy.zero }
    , Browser.Dom.getViewport
        |> Task.perform
            (.viewport >> Xy.fromSize >> Resized)
    )

subscriptions =
    Browser.Events.onResize
        (\w h ->
            Resized (( w, h ) |> Xy.map toFloat)
        )
```