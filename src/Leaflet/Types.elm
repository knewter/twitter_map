module Leaflet.Types exposing (LatLng, ZoomPanOptions, defaultZoomPanOptions)

{-| Types for Leaflet.js
-}


{-| Reference: http://leafletjs.com/reference.html#latlng
-}
type alias LatLng =
    ( Float, Float )


{-| Reference: http://leafletjs.com/reference.html#map-zoomoptions
-}
type alias ZoomOptions =
    { animate : Bool }


{-| Reference: http://leafletjs.com/reference.html#map-panoptions
-}
type alias PanOptions =
    { animate : Bool
    , duration : Float
    , easeLinearity : Float
    , noMoveStart : Bool
    }


{-| Reference: http://leafletjs.com/reference.html#map-zoompanoptions
-}
type alias ZoomPanOptions =
    { reset : Bool
    , pan : PanOptions
    , zoom : ZoomOptions
    , animate : Bool
    }


defaultZoomPanOptions : ZoomPanOptions
defaultZoomPanOptions =
    { reset = False
    , pan = defaultPanOptions
    , zoom = defaultZoomOptions
    , animate = True
    }


defaultPanOptions : PanOptions
defaultPanOptions =
    { animate = True
    , duration = 0.25
    , easeLinearity = 0.25
    , noMoveStart = False
    }


defaultZoomOptions : ZoomOptions
defaultZoomOptions =
    { animate = True }
