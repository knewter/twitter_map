port module Leaflet.Ports
    exposing
        ( setView
        , setMarkers
        , getCenter
        , updateMarkerPopupState
        )

import Leaflet.Types exposing (LatLng, ZoomPanOptions, MarkerOptions)


-- Outbound Ports


port setView : ( LatLng, Int, ZoomPanOptions ) -> Cmd msg


port setMarkers : List ( Int, LatLng, MarkerOptions, String, Bool ) -> Cmd msg



-- Inbound ports


port getCenter : (LatLng -> msg) -> Sub msg


port updateMarkerPopupState : (( Int, Bool ) -> msg) -> Sub msg
