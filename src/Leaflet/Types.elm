module Leaflet.Types
    exposing
        ( LatLng
        , ZoomPanOptions
        , defaultZoomPanOptions
        , MarkerOptions
        , defaultMarkerOptions
        )

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


{-| Reference: http://leafletjs.com/reference.html#marker-options
-}
type alias MarkerOptions =
    { icon : IconOptions
    , clickable : Bool
    , draggable : Bool
    , keyboard : Bool
    , title : String
    , alt : String
    , zIndexOffset : Int
    , opacity : Float
    , riseOnHover : Bool
    , riseOffset : Int
    }


{-| Reference: http://leafletjs.com/reference.html#icon-options
-}
type alias IconOptions =
    { iconUrl : String
    , iconRetinaUrl : String
    , iconSize : Point
    , iconAnchor : Point
    , shadowUrl : String
    , shadowRetinaUrl : String
    , shadowSize : Point
    , shadowAnchor : Point
    , popupAnchor : Point
    , className : String
    }


type alias Point =
    ( Int, Int )


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


leafletDistributionBase : String
leafletDistributionBase =
    "https://unpkg.com/leaflet@1.0.0-rc.3/dist/images/"


iconUrl : String -> String
iconUrl filename =
    leafletDistributionBase ++ filename


defaultIconOptions : IconOptions
defaultIconOptions =
    { iconUrl = iconUrl "marker-icon.png"
    , iconRetinaUrl = iconUrl "marker-icon-2x.png"
    , iconSize = ( 25, 41 )
    , iconAnchor = ( 12, 41 )
    , shadowUrl = iconUrl "marker-shadow.png"
    , shadowRetinaUrl =
        iconUrl "marker-shadow-2x.png"
        -- Really just guessing here, doesn't appear to be set by default?
    , shadowSize = ( 41, 41 )
    , shadowAnchor = ( 12, 41 )
    , popupAnchor = ( 1, -34 )
    , className = ""
    }


defaultMarkerOptions : MarkerOptions
defaultMarkerOptions =
    { icon = defaultIconOptions
    , clickable = True
    , draggable = False
    , keyboard = True
    , title = ""
    , alt = ""
    , zIndexOffset = 0
    , opacity = 1.0
    , riseOnHover = False
    , riseOffset = 250
    }
