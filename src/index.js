require('./main.css');

var Elm = require('./Main.elm');

var root  = document.getElementById('root');

var mymap = L.map('mapid').setView([51.505, -0.09], 13);
L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mymap);

var app = Elm.Main.embed(root);

var center;

mymap.on('move', function(evt){
  center = mymap.getCenter();
  console.log(center);
  app.ports.getCenter.send([center.lat, center.lng]);
});

app.ports.setView.subscribe(function(data){
  console.log(data);
  mymap.setView.apply(mymap, data);
})
