window.initialize_map = ->
  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition((position) -> 
      window.mapManager = new mapManager(position)
    )
  else
    alert("Geolocation is not supported by this browser.")

class mapManager
  constructor: (position) ->
    return if $('#map-canvas').length == 0
    @user_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    map_options = {center: @user_location, zoom: 14}
    @map = new google.maps.Map($('#map-canvas')[0], map_options)
    @gps_icon = {
      url: '/assets/gpsloc.png',
      size: new google.maps.Size(34, 34),
      scaledSize: new google.maps.Size(17, 17),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(8, 8)
    }
    @marker = new google.maps.Marker({position: @user_location, map: @map, title: 'Current', icon: @gps_icon})
    options = {enableHighAccuracy: true, maximumAge: 5000, timeout: 5000, frequency: 5000}
    @watchID = navigator.geolocation.watchPosition(this.updatePosition, this.errorHandler, options)
  updatePosition: (position) =>
    new_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    @marker.setPosition(new_location)
    @user_location = new_location
  errorHandler: (err) ->
    if(err.code == 1)
      alert("Error: Access is denied!");
    else if( err.code == 2)
      alert("Error: Position is unavailable!");
    
