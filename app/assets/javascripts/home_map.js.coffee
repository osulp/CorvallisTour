before_request_gps = 0

window.initialize_map = ->
  if (navigator.geolocation)
    before_request_gps = +new Date()
    navigator.geolocation.getCurrentPosition((position) -> 
      window.mapManager = new mapManager(position)
    , get_position_error)
  else
    $('#map-canvas').html("Geolocation is not supported by this browser.")

get_position_error = (error) ->
  switch error.code
    when error.PERMISSION_DENIED
      $('#map-canvas').html("<br /><br />Location service must be allowed in order to use this application.")
      after_request_gps = +new Date()
       # Assume human finger will not touch the "disallow" button in 500ms
      if after_request_gps - before_request_gps < 500
        # Then this must because user disallowed location service inside their privacy settings
        if (navigator.platform.indexOf("iPhone") != -1) || (navigator.platform.indexOf("iPod") != -1)
          $('#map-canvas').html("<br /><br />Location service seems to be disabled.<br /><br />To enable location service, navigate to<br /><b>Settings</b> &gt; <b>Privacy</b> &gt; <b>Location Services</b><br />and enable it for safari.")
        else
          $('#map-canvas').html("<br /><br />Location service seems to be disabled.<br /><br />You must enable it in your device settings in order to use this application.")
    when error.POSITION_UNAVAILABLE then $('#map-canvas').html("Location information is unavailable.")
    when error.TIMEOUT then $('#map-canvas').html("The request to get user location timed out.")
    when error.UNKNOWN_ERROR then $('#map-canvas').html("An unknown error occurred.")


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

    this.createMap()

    $('#my-location-button').click(this.findMyLocation)

    this.getLocations()

    @markers_on_map = []
    @route = []
    @colors = ['blue', 'orange', 'darkgreen', 'purple']

  createMap: ->
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
    watcher_options = {enableHighAccuracy: true, maximumAge: 5000, timeout: 5000, frequency: 5000}
    @watchID = navigator.geolocation.watchPosition(this.updatePosition, this.errorHandler, watcher_options)

  updatePosition: (position) =>
    new_location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    @marker.setPosition(new_location)
    @user_location = new_location
    @current_position = position
    if(!@locations?)
      return
    # See if user is approaching a place
    nearby = this.nearbyLocations(position)

    if nearby?
      @in_location = true
      $(window).trigger 'approaching', [nearby.id, nearby.visited]
      unless nearby.visited
        nearby.visited = true
        this.drawMarkers()
    else if @in_location
      @in_location = false
      $(window).trigger 'leaving'

  nearbyLocations: (position) ->
    position = @current_position unless position?
    nearby = @locations.filter(((l) -> this.distance(position, l) <= l.radius), this)
    if nearby.length == 1 then nearby[0] else null

  errorHandler: (err) ->
    if(err.code == 1)
      alert("Error: Access is denied!");
    else if( err.code == 2)
      alert("Error: Position is unavailable!");
  
  getLocations: ->
    $.getJSON('/locations', (data) =>
      @locations = data
      if data.length > 0
        origin = data[data.length-1]
        @origin_location = new google.maps.LatLng(origin.latitude, origin.longitude)
      window.locationsManager.saveLocations(data) if window.locationsManager?
      this.drawMarkers()
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

  findMyLocation: =>
    @map.panTo(@user_location)

  drawMarkers: () ->
    # clean old markers
    for marker in @markers_on_map
      marker.setMap(null)
      google.maps.event.clearInstanceListeners(marker)
    @markers_on_map.length = 0

    # draw visited sites
    visited = @locations.filter((l) -> l.visited)
    for site in visited
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(site.latitude, site.longitude)
        icon: '/assets/site-visited.png'
        map: @map
      })
      @markers_on_map.push(marker)
      manager = this
      google.maps.event.addListener(marker, 'click', ->
        m = this
        new_site = visited.filter((l) -> l.latitude == m.position.lat() && l.longitude == m.position.lng())[0]
        $(window).trigger 'approaching', [new_site.id, false]
        nearby = manager.nearbyLocations(manager.current_position)
        unless nearby?
          $("#images-button").hide()
          $(window).on('cached-images', ->
            $(window).off('cached-images')
            $("#images-button").hide()
          )
      )
    # draw sites to visit
    to_visit = @locations.filter((l) -> l.visited == false)
    for site in to_visit
      @markers_on_map.push(new google.maps.Marker({
        position: new google.maps.LatLng(site.latitude, site.longitude)
        icon: '/assets/site-tovisit.png'
        map: @map
      }))

  mid: (p1, p2) ->
    new google.maps.LatLng(
      (p1.lat() + p2.lat()) / 2,
      (p1.lng() + p2.lng()) / 2
    )
