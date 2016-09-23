port module Leaflet.Ports exposing (setView, getCenter)

import Leaflet.Types exposing (LatLng, ZoomPanOptions)


port setView : ( LatLng, Int, ZoomPanOptions ) -> Cmd msg


port getCenter : (LatLng -> msg) -> Sub msg
