class ImageWidget
  constructor: (jqueryObj) ->
    jqueryObj.css 'position', 'absolute'
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
        window.delay 150, ->          
          $('.pagescontent:visible').prepend("<img class=\"oicimage\" src=\"images/#{file}\"/>")
          $('.oicimage').draggable()

    new AjaxUpload('imginsert', uploadopts)


$ ->
  $(document).bind 'sessionState', (event) ->
    if window.loggedIn
      console.log 'loggedin in image'
      console.log 'in image user is:'
      console.log window.user
      window.ImageTool = new ImageTool()
      $('.oicimage').each ->    
        if $(@)?
          text = new ImageWidget $(@)
        else
          console.log '$(this)? false skipping'
            