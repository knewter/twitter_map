module Main exposing (..)

import Html exposing (text, Html, button, div, h3, ul, li, a, span)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Html.App exposing (program)
import Leaflet.Types exposing (LatLng, ZoomPanOptions, defaultZoomPanOptions, MarkerOptions, defaultMarkerOptions)
import Leaflet.Ports
import Dict exposing (Dict)


type alias Marker =
    ( LatLng, String, Bool )


type alias Model =
    { latLng : LatLng
    , zoomPanOptions : ZoomPanOptions
    , markers : Dict Int Marker
    }


type Msg
    = SetLatLng LatLng
    | GetCenter LatLng
    | AddMarker ( Int, Marker )
    | RemoveMarker Int
    | ShowMarkerPopup Int
    | HideMarkerPopup Int
    | UpdateMarkerPopupState ( Int, Bool )


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

        AddMarker ( id, marker ) ->
            let
                newModel =
                    addMarker ( id, marker ) model
            in
                ( newModel
                , Leaflet.Ports.setMarkers <| markersAsOutboundType newModel.markers
                )

        RemoveMarker id ->
            let
                newModel =
                    removeMarker id model
            in
                ( newModel
                , Leaflet.Ports.setMarkers <| markersAsOutboundType newModel.markers
                )

        ShowMarkerPopup id ->
            let
                newModel =
                    showMarkerPopup id model
            in
                ( newModel
                , Leaflet.Ports.setMarkers <| markersAsOutboundType newModel.markers
                )

        HideMarkerPopup id ->
            let
                newModel =
                    hideMarkerPopup id model
            in
                ( newModel
                , Leaflet.Ports.setMarkers <| markersAsOutboundType newModel.markers
                )

        UpdateMarkerPopupState ( id, isShown ) ->
            let
                newModel =
                    updateMarkerPopupState id isShown model
            in
                ( newModel
                , Cmd.none
                )


addMarker : ( Int, Marker ) -> Model -> Model
addMarker ( id, marker ) model =
    { model | markers = Dict.insert id marker model.markers }


removeMarker : Int -> Model -> Model
removeMarker id model =
    { model | markers = Dict.remove id model.markers }


updateMarker : Int -> (Marker -> Marker) -> Model -> Model
updateMarker id mapFun model =
    { model | markers = Dict.update id (Maybe.map mapFun) model.markers }


updateMarkerPopupState : Int -> Bool -> Model -> Model
updateMarkerPopupState id isShown model =
    updateMarker id (\( latLng, label, showPopup ) -> ( latLng, label, isShown )) model


showMarkerPopup : Int -> Model -> Model
showMarkerPopup id model =
    updateMarkerPopupState id True model


hideMarkerPopup : Int -> Model -> Model
hideMarkerPopup id model =
    updateMarkerPopupState id False model


markersAsOutboundType : Dict Int Marker -> List ( Int, LatLng, MarkerOptions, String, Bool )
markersAsOutboundType markers =
    Dict.toList markers
        |> List.map (\( id, ( latLng, popupText, showPopup ) ) -> ( id, latLng, defaultMarkerOptions, popupText, showPopup ))


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
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Leaflet.Ports.getCenter GetCenter
        , Leaflet.Ports.updateMarkerPopupState UpdateMarkerPopupState
        ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick <| SetLatLng birminghamLatLng ] [ text "Set Map Location to Birmingham" ]
        , button [ onClick <| SetLatLng boulderLatLng ] [ text "Set Map Location to Boulder" ]
        , button [ onClick <| AddMarker ( 1, ( birminghamLatLng, "Birmingham, AL", False ) ) ] [ text "Add Marker for Birmingham" ]
        , button [ onClick <| AddMarker ( 2, ( boulderLatLng, "Boulder, CO", False ) ) ] [ text "Add Marker for Boulder" ]
        , h3 [] [ text <| toString model.latLng ]
        , markersView model
        ]


markersView : Model -> Html Msg
markersView model =
    div []
        [ h3 [] [ text "Markers" ]
        , ul []
            (List.map markerView (Dict.toList model.markers))
        ]


markerView : ( Int, Marker ) -> Html Msg
markerView ( key, ( latLng, label, popupOpen ) ) =
    let
        popupAction =
            case popupOpen of
                True ->
                    a [ href "#", onClick <| HideMarkerPopup key ] [ text "Hide popup" ]

                False ->
                    a [ href "#", onClick <| ShowMarkerPopup key ] [ text "Show popup" ]
    in
        li []
            [ a [ href "#", onClick <| SetLatLng latLng ] [ text (label ++ " " ++ (toString latLng)) ]
            , a [ href "#", onClick <| RemoveMarker key ] [ text "[x]" ]
            , popupAction
            ]
