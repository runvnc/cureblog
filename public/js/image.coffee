class ImageWidget
  constructor: (jqueryObj) ->
    jqueryObj.draggable()
  

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
      name: 'imageupload'
	    
      onComplete: (file, response) ->
        console.log file
        style = 'style="position: absolute; top: 100px; left: 100px;"'
        window.delay 150, ->
          $('#page').append("<img class=\"oicimage\" src=\"images/#{file}\"/>")
          $('.oicimage').draggable()

    new AjaxUpload('imginsert', uploadopts)


$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.ImageTool = new ImageTool()
      $('.oicimage').each ->    
        if $(@)?
          text = new ImageWidget $(@)
        else
          console.log '$(this)? false skipping'
            