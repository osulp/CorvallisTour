jQuery ->
  window.popupManager = new popupManager

class popupManager
  constructor: ->
    $('#images-button').hide()
    $('#images-button').click(this.display)

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

    @cached_images = {}

  approaching: (location_id, visited) ->
    if @cached_images[location_id]
      this.approaching_after(location_id, visited)
    else
      $.getJSON("/locations/#{location_id}/images", (data) =>
        @cached_images[location_id] = data
        this.approaching_after(location_id, visited)
      )
  approaching_after: (location_id, visited) ->
    unless @images == @cached_images[location_id]
      @images = @cached_images[location_id]
      @image_index = 0
    unless visited
      this.display()

    $('#images-button').show()

  leaving: ->
    $('#images-button').hide()

  display: =>
    this.setImage()
    $('#popup-images').popup('open')
  prev: ->
    @image_index-- if @image_index > 0
    this.setImage()
  next: ->
    @image_index++ if @image_index + 1 < @images.length
    this.setImage()

  setImage: ->
    $('#popup-images img').attr('src', @images[@image_index].photo.url)
    $('#popup-images p b').text("#{@image_index + 1} / #{@images.length}  #{@images[@image_index].title}")
    $('#popup-images p span').html(this.nl2br(@images[@image_index].description))

  nl2br: (str) ->
    str.replace(/&/g, '&amp;')
       .replace(/>/g, '&gt;')
       .replace(/</g, '&lt;')
       .replace(/\n/g, '<br>');
