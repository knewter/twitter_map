module Main exposing (..)

import Html exposing (text, Html, button, div, h3)
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
    | GetCenter LatLng


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        SetLatLng latLng ->
            ( { model | latLng = latLng }
            , Leaflet.Ports.setView ( latLng, 13, model.zoomPanOptions )
            )

        GetCenter latLng ->
            ( { model | latLng = latLng }
            , Cmd.none
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
        , subscriptions = always <| Leaflet.Ports.getCenter GetCenter
        }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick <| SetLatLng birminghamLatLng ] [ text "Set Map Location to Birmingham" ]
        , button [ onClick <| SetLatLng boulderLatLng ] [ text "Set Map Location to Boulder" ]
        , h3 [] [ text <| toString model.latLng ]
        ]
