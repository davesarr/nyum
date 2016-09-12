window.onload(function(){
  var geoLocate = function(){
    if ( navigator.geolocation ){
      navigator.geolocation.getCurrentPosition(function(ps){
        latitude = ps.coords.latitude;
        longitude = ps.coords.longitude;
      });
    }
  }
  var geoArrow = document.getElementById('geo-arrow');
  geoArrow.addEventListener('click', geoLocate, false);
});
