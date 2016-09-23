port module Leaflet.Ports exposing (setView)

import Leaflet.Types exposing (LatLng, ZoomPanOptions)


port setView : ( LatLng, Int, ZoomPanOptions ) -> Cmd msg
