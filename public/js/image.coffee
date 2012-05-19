class ImageTool
  constructor: ->
    @active = false
    widgethtml = $('#imagetemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'image'
    data = 
      name: 'image'
    btn.data 'widget', data
        
    $('.imagetool').live 'click', =>
      $('.imagetool.toolbutton').addClass 'active'
      window.delay 500, ->
        $('.imagetool.toolbutton').removeClass 'active'

    $('#objlist').append widget  
        
    uploadopts = 
      action: '/dyn/upload'
      onComplete: (file, response) ->
        alert 'uploaded'

    new AjaxUpload('imginsert', uploadopts)


$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.ImageTool = new ImageTool()
      