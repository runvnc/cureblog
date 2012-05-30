class EmailCollectorWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      emailshtml = $('#emailswidgettemplate').html()
      emails = $(emailshtml)    
      emails.css 'position', 'absolute'
      emails.css 'top', position.top + 'px'
      emails.css 'left', position.left + 'px'
      parent.append emails
    else
      emails = widget

    try
      emails.draggable()
      $('.saveemail').off 'blur'
      $('.saveemail').on 'blur', ->
        now.saveEmail $(this).val()
        $(this).val ''
    catch e
    
  
class EmailCollectorTool
  constructor: ->
    widgethtml = $('#emailstemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'emailcollector'
    data = 
      name: 'emailcollector'
    btn.data 'widget', data    
    $('#objlist').append widget 
    
    widget.draggable
      helper: 'clone'
      stop: (ev, ui) ->
        p = {}
        if ev.offsetX?
          p.left = ev.offsetX
          p.top = ev.offsetY
        else
          p.left = ev.pageX - $(ev.target).offsetLeft
          p.top = ev.pageY - $(ev.target).offsetTop
        new EmailCollectorWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.emailsall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new EmailCollectorWidget($(this).parent(),$(this).position(), true, $(this))  
  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.EmailCollectorTool = new EmailCollectorTool()
      
    