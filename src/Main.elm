module Main exposing (..)

import Html exposing (text, Html, button, div)
import Html.Events exposing (onClick)
import Html.App exposing (program)
import Leaflet.Types exposing (LatLng, ZoomPanOptions, defaultZoomPanOptions)
import Leaflet.Ports


type alias Model =
    { latLng : LatLng
    , zoomPanOptions : ZoomPanOptions
    }


type Msg
    = SetLatLng LatLng


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLatLng latLng ->
            ( { model | latLng = latLng }
            , Leaflet.Ports.setView ( latLng, 13, model.zoomPanOptions )
            )


birminghamLatLng : LatLng
birminghamLatLng =
    ( 33.5207, -86.8025 )


boulderLatLng : LatLng
boulderLatLng =
    ( 40.015, -105.2705 )


init : ( Model, Cmd Msg )
init =
    ( { latLng = birminghamLatLng
      , zoomPanOptions = defaultZoomPanOptions
      }
    , Cmd.none
    )


main : Program Never
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick <| SetLatLng birminghamLatLng ] [ text "Set Map Location to Birmingham" ]
        , button [ onClick <| SetLatLng boulderLatLng ] [ text "Set Map Location to Boulder" ]
        ]
