
class HtmlFieldWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      htmlfieldhtml = $('#htmlfieldwidgettemplate').html()
      htmlfield = $(htmlfieldhtml)    
      htmlfield.css 'position', 'absolute'
      htmlfield.css 'top', position.top + 'px'
      htmlfield.css 'left', position.left + 'px'
      parent.append htmlfield
    else
      htmlfield = widget
      
    try
      htmlfield.resizable()
      htmlfield.draggable()
    catch e
    
    @obj = htmlfield
    htmlfield.find('.rename').off 'click'
    htmlfield.find('.rename').on 'click', =>
      name = prompt 'Enter field name'
      htmlfield.attr 'data-fieldname', name
      @showname()
      
    @showname()
    
  showname: ->
    @obj.find('.fieldname').html @obj.attr 'data-fieldname'
    
  
class HtmlFieldTool
  constructor: ->
    widgethtml = $('#htmlfieldtemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'htmlfieldcollector'
    data = 
      name: 'htmlfieldcollector'
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
        new HtmlFieldWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.htmlfieldall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new HtmlFieldWidget($(this).parent(),$(this).position(), true, $(this))  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.HtmlFieldTool = new HtmlFieldTool()
      
      