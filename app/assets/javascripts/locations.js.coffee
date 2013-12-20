window.initialize_map = ->
  window.locationManager = new locationManager

class locationManager
  constructor: ->
    return if $('#map-canvas').length == 0
    @form_lat = $('#location_latitude')
    @form_lng = $('#location_longitude')
    @form_radius = $('#location_radius')
    point = this.getPoint()
    radius = this.getRadius()
    map_options = {center: point, zoom: 14}
    @map = new google.maps.Map($('#map-canvas')[0], map_options)
    @marker = new google.maps.Marker({position: point, map: @map, title: 'Destination', draggable: true})
    @circle = new google.maps.Circle({center: point, map: @map, radius: radius, fillColor: 'skyblue', strokeColor: 'skyblue', strokeOpacity:0.8, editable: true})
    google.maps.event.addListener(@marker, 'dragend', this.setPoint)
    google.maps.event.addListener(@circle, 'radius_changed', this.setRadius)
    @form_lat.on('change', this.changedPoint)
    @form_lng.on('change', this.changedPoint)
    @form_radius.on('change', this.changedRadius)

  getPoint: ->
    point = new google.maps.LatLng(this.getLatitude(), this.getLongitude())
  getLatitude: ->
    val = parseFloat(@form_lat.val())
    if isNaN(val) then @last_latitude else @last_latitude = val
  getLongitude: ->
    val = parseFloat(@form_lng.val())
    if isNaN(val) then @last_longitude else @last_longitude = val
  getRadius: ->
    val = parseFloat(@form_radius.val())
    if isNaN(val) then @last_radius else @last_radius = val

  # Update point into textbox
  setPoint: =>
    point = @marker.getPosition()
    @form_lat.val(point.lat())
    @form_lng.val(point.lng())
    @circle.setCenter(point)
  setRadius: =>
    radius = @circle.getRadius()
    @form_radius.val(radius)

  # Load point from textbox
  changedPoint: =>
    point = this.getPoint()
    @map.panTo(point)
    @marker.setPosition(point)
    @circle.setCenter(point)
  changedRadius: =>
    @circle.setRadius(this.getRadius())
