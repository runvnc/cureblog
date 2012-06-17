class EmailCollectorWidget
  constructor: (parent, position, exists, widget) ->
    console.log 'constructor for emailconstructorwidget'
    if not exists
      console.log 'not exists'
      emailshtml = $('#emailswidgettemplate').html()
      emails = $(emailshtml)    
      emails.css 'position', 'absolute'
      emails.css 'top', position.top + 'px'
      emails.css 'left', position.left + 'px'
      parent.append emails
      emails.draggable()
    else
      console.log 'exists'
      emails = widget
      
    try      
      console.log '.saveemail is '
      console.log $('.saveemail')
      $('.saveemail').off 'blur'
      $('.saveemail').on 'blur', ->
        console.log 'blur activated'
        console.log 'value is ' + $(this).val()
        now.saveEmail $(this).val(), (success, msg) ->
          if success then $(this).val ''
    catch e
      console.log e
    
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
  console.log 'emailcollector startup'
  $('.emailsall').each ->    
    console.log 'found an email collector'
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new EmailCollectorWidget($(this).parent(),$(this).position(), true, $(this))  
    else
      console.log 'email collector failed'
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.EmailCollectorTool = new EmailCollectorTool()
      
    