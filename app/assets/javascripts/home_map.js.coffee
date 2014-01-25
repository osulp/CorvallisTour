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
    $.cookie.json = true

    @user_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

    origin_location = $.cookie('origin_location')
    if (origin_location)
      @origin_location = new google.maps.LatLng(origin_location[0], origin_location[1])
    else
      $.cookie('origin_location', [position.coords.latitude, position.coords.longitude], { expires: 1 })
      @origin_location = @user_location

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

    @directionsDisplay = new google.maps.DirectionsRenderer()
    @directionsService = new google.maps.DirectionsService()
    @directionsDisplay.setMap(@map);

    $('#my-location-button').click(this.findMyLocatioin)

    this.getLocations()

  updatePosition: (position) =>
    new_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    @marker.setPosition(new_location)
    @user_location = new_location

    if(!@locations)
      return
    # See if user is approaching a place
    approaching = @locations.filter(((l) -> this.distance(position, l) <= l.radius), this)

    if approaching[0]
      @in_location = true
      window.popupManager.approaching(approaching[0].id, approaching[0].visited)
      unless approaching[0].visited
        approaching[0].visited = true
        this.getGoogleDirections()
    else if @in_location
      @in_location = false
      window.popupManager.leaving()
  errorHandler: (err) ->
    if(err.code == 1)
      alert("Error: Access is denied!");
    else if( err.code == 2)
      alert("Error: Position is unavailable!");
  
  getLocations: ->
    $.getJSON('/locations', (data) =>
      @locations = data
      this.getGoogleDirections()
    )

  getGoogleDirections: ->
    request = {
      origin:       @user_location,
      destination:  @origin_location, # Use origin to let user drive back to the start place

      waypoints:    @locations.filter((l) -> l.visited == false)
                              .map((l) -> { location: new google.maps.LatLng(l.latitude, l.longitude) }),

      travelMode:   google.maps.TravelMode.DRIVING,
      unitSystem:   google.maps.UnitSystem.IMPERIAL,
      optimizeWaypoints: true
    }
    @directionsService.route(request, (result, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        @directionsDisplay.setDirections(result);
    )

  distance: (position, location)->
    R = 6371 # km
    dLat = this.deg2rad(position.coords.latitude - location.latitude)
    dLng = this.deg2rad(position.coords.longitude - location.longitude)
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(this.deg2rad(position.coords.latitude)) * Math.cos(this.deg2rad(location.latitude)) * 
        Math.sin(dLng/2) * Math.sin(dLng/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = R * c * 1000 # return in meters

  deg2rad: (deg) ->
    deg * (Math.PI / 180)

  findMyLocatioin: =>
    @map.panTo(@user_location)
