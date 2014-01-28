jQuery ->
  window.locationsManager = new locationsManager

class locationsManager
  constructor: ->
    $('#locations-button').click(this.display)
    $('#popup-locations').on({
      popupbeforeposition: ->
        h = ($(window).height() - 40);
        w = ($(window).width() - 40);
        $('#popup-locations').css('height', h + 'px');
        $('#popup-locations').css('width', w + 'px');
    })

  saveLocations: (locations) ->
    @locations = locations

  display: =>
    return unless @locations?
    this.setPopupContent()
    $('#popup-locations').popup('open')

  setPopupContent: ->
    container = $('#locations-content')
    container.empty()
    for l in @locations
      icon = if l.visited then 'check' else ''
      container.append("<li><span class=\"ui-icon-#{icon} ui-btn ui-btn-icon-left\">#{l.name}</span></li>")
