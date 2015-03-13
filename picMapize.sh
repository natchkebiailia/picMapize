#!/bin/bash

headHTML="<!DOCTYPE html>
<html>
<head>
<meta charset=\"UTF-8\">
<title>My Pictures on Map</title>
<style>
html, body, #map_canvas {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
}
#map_canvas {
    position: relative;
}
.rotated {
     -webkit-transform: rotate(90deg);
     -moz-transform: rotate(90deg);
     -o-transform: rotate(90deg);
     -ms-transform: rotate(90deg);
     transform: rotate(90deg);
}
</style>
</head>";

bodyHTML="<body>
<div id=\"map_canvas\"></div>
<script src=\"http://maps.google.com/maps/api/js?sensor=false\"></script>
<script>";

dataHTML="var locations = [";

for i in $1*.JPG
do

desc=$(mdls $i | grep itude);

lat=$(echo "$desc" | grep Latitude | cut -d "=" -f 2);
lng=$(echo "$desc" | grep Long | cut -d "=" -f 2);
if [ -n "$lat" ]
then
dataHTML+="['$i',$lat,$lng],";
fi
done
dataHTML+="[]";

dataHTML+="];"



scriptHTML="locations.pop();
function initialize() {

    var latlng = new google.maps.LatLng(50.4064917,15.7241974),
    
        mapOptions = {
            mapTypeControlOptions: {
                mapTypeIds: [google.maps.MapTypeId.ROADMAP, \"Edited\"] 
            },
            zoom: 3,
            center: latlng
        },
        
        map = new google.maps.Map(document.getElementById(\"map_canvas\"), mapOptions);
    
    var marker, i, infowindow;

    infowindow = new google.maps.InfoWindow();



    for (i = 0; i < locations.length; i++) {

      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map,
        animation: google.maps.Animation.DROP
      });

      google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(\"<div><img class='rotated' width='300'  src='\" + locations[i][0] +\"'</div>\");
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
}

initialize();";

footerHTML="</script>
</body>
</html>";


echo $headHTML$bodyHTML$dataHTML$scriptHTML$footerHTML > $1index.html;
open $1index.html

