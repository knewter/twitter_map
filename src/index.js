require('./main.css')

let Elm = require('./Main.elm')

let root  = document.getElementById('root')

let mymap = L.map('mapid').setView([51.505, -0.09], 13)
L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mymap)

let app = Elm.Main.embed(root)

let center
let markers = {}

const findMarkerIdByLeafletId = (leafletId) => {
  return Object.getOwnPropertyNames(markers).find((id) => {
    return markers[id]._leaflet_id == leafletId
  })
}

mymap.on('move', (evt) => {
  center = mymap.getCenter()
  app.ports.getCenter.send([center.lat, center.lng])
})
mymap.on('popupopen', (evt) => {
  let markerId = findMarkerIdByLeafletId(evt.popup._source._leaflet_id)
  if (markerId) {
    app.ports.updateMarkerPopupState.send([Number(markerId), true])
  }
})
mymap.on('popupclose', (evt) => {
  let markerId = findMarkerIdByLeafletId(evt.popup._source._leaflet_id)
  if (markerId) {
    app.ports.updateMarkerPopupState.send([Number(markerId), false])
  }
})

app.ports.setView.subscribe((data) => {
  mymap.setView.apply(mymap, data)
})

app.ports.setMarkers.subscribe((data) => {
  let newMarkers = {}
  data.forEach((data, index)  => {
    let [id, latLng, markerOptions, popupText, showPopup] = data
    if (markers.hasOwnProperty(id)) {
      newMarkers[id] = markers[id]
    } else {
      markerOptions.icon = new L.Icon(markerOptions.icon)
      let marker = L.marker(latLng, markerOptions)
      marker.bindPopup(popupText)
      let addedMarker = marker.addTo(mymap)
      newMarkers[id] = marker
    }
    if (showPopup) {
      newMarkers[id].openPopup()
    } else {
      newMarkers[id].closePopup()
    }
  })
  Object.getOwnPropertyNames(markers).forEach((id) => {
    if (!newMarkers[id]){
      markers[id].remove()
      delete markers[id]
    }
  })
  markers = newMarkers
})
