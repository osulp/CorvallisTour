jQuery ->
  window.popupManager = new popupManager

class popupManager
  constructor: ->
    $('#popup-images').on({
      popupbeforeposition: ->
        h = ($(window).height() - 40);
        w = ($(window).width() - 40);
        $('#popup-images').css('height', h + 'px');
        $('#popup-images').css('width', w + 'px');
      swipeleft: =>
        this.next()
      swiperight: =>
        this.prev()
    })
  display: (data) ->
    @images = data
    @image_index = 0
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
