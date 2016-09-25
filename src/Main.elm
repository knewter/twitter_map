module Main exposing (..)

import Html exposing (text, Html, button, div, h3)
import Html.Events exposing (onClick)
import Html.App exposing (program)
import Leaflet.Types exposing (LatLng, ZoomPanOptions, defaultZoomPanOptions, MarkerOptions, defaultMarkerOptions)
import Leaflet.Ports
import Dict exposing (Dict)


type alias Model =
    { latLng : LatLng
    , zoomPanOptions : ZoomPanOptions
    , markers : Dict Int ( LatLng, String )
    }


type Msg
    = SetLatLng LatLng
    | GetCenter LatLng
    | AddMarker ( Int, LatLng, String )


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

        AddMarker ( id, latLng, popupText ) ->
            let
                newModel =
                    addMarker ( id, latLng, popupText ) model
            in
                ( newModel
                , Leaflet.Ports.setMarkers <| markersAsOutboundType newModel.markers
                )


addMarker : ( Int, LatLng, String ) -> Model -> Model
addMarker ( id, markerOptions, popupText ) model =
    { model | markers = Dict.insert id ( markerOptions, popupText ) model.markers }


markersAsOutboundType : Dict Int ( LatLng, String ) -> List ( Int, LatLng, MarkerOptions, String )
markersAsOutboundType markers =
    Dict.toList markers
        |> List.map (\( id, ( latLng, popupText ) ) -> ( id, latLng, defaultMarkerOptions, popupText ))


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
      , markers = Dict.empty
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
        , button [ onClick <| AddMarker ( 1, birminghamLatLng, "Birmingham, AL" ) ] [ text "Add Marker for Birmingham" ]
        , button [ onClick <| AddMarker ( 2, boulderLatLng, "Boulder, CO" ) ] [ text "Add Marker for Boulder" ]
        , h3 [] [ text <| toString model.latLng ]
        ]
