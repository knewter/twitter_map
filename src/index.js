require('./main.css')

let Elm = require('./Main.elm')

let root  = document.getElementById('root')

let mymap = L.map('mapid').setView([51.505, -0.09], 13)
L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mymap)

let app = Elm.Main.embed(root)

let center
let markers = {}

mymap.on('move', (evt) => {
  center = mymap.getCenter()
  app.ports.getCenter.send([center.lat, center.lng])
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
      marker.addTo(mymap)
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
