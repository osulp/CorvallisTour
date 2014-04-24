jQuery ->
  window.popupManager = new popupManager

class popupManager
  constructor: ->
    $('#images-button').hide()
    $('#images-button').click(->
      nearby = window.mapManager.nearbyLocations()
      if nearby?
        $(window).trigger("approaching", [nearby.id, false])
    )

    $('#popup-images').on({
      popupbeforeposition: ->
        h = ($(window).height() - 40);
        w = ($(window).width() - 40);
        $('#popup-images').css('height', h + 'px');
        $('#popup-images').css('width', w + 'px');
    })
    $('body').on({
      swipeleft: =>
        this.next() if $('#popup-images-screen').hasClass('in')
      swiperight: =>
        this.prev() if $('#popup-images-screen').hasClass('in')
    })
    $(window).on('approaching', this.approaching)
    $(window).on('leaving', this.leaving)

    @cached_images = {}

  approaching: (event, location_id, visited) =>
    if @cached_images[location_id]
      this.loadImages(location_id, visited)
    else
      $.getJSON("/locations/#{location_id}/images", (data) =>
        @cached_images[location_id] = data
        this.loadImages(location_id, visited)
        $(window).trigger 'cached-images'
      )
  loadImages: (location_id, visited) ->
    unless @images == @cached_images[location_id]
      @images = @cached_images[location_id]
      @image_index = 0
    unless visited
      this.display()

    $('#images-button').show()

  leaving: ->
    $('#images-button').hide()

  display: =>
    return unless this.setImage()
    $('#popup-images').popup('open')
  prev: ->
    @image_index-- if @image_index > 0
    this.setImage()
  next: ->
    @image_index++ if @image_index + 1 < @images.length
    this.setImage()

  setImage: ->
    return false unless @images?
    return false unless @images[@image_index]?
    $('#popup-images img').attr('src', @images[@image_index].photo.url)
    $('#popup-images p b').text("#{@image_index + 1} / #{@images.length}  #{@images[@image_index].title}")
    $('#popup-images p span').html(this.nl2br(@images[@image_index].description))
    true

  nl2br: (str) ->
    str.replace(/&/g, '&amp;')
       .replace(/>/g, '&gt;')
       .replace(/</g, '&lt;')
       .replace(/\n/g, '<br>');
