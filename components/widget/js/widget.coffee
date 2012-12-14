class Widget
  constructor: (opts) ->
    console.log 'constructor for widget. opts is'
    console.log opts
    { @name, parent, position, exists, widget } = opts
    if not exists
      console.log 'not exists'
      @html = $("##{@name}template").html()
      console.log '---- @name is ' + @name
      console.log '----- widget template html is '
      console.log @html
      @jqobj = $(@html)    
      @jqobj.css 'position', 'absolute'
      @jqobj.css 'top', position.top + 'px'
      @jqobj.css 'left', position.left + 'px'
      parent.append @jqobj
    else
      console.log 'exists'
      @jqobj = widget
      
    try
      if window.loggedIn then @jqobj.draggable()
    catch e
      console.log e
    
class WidgetTool
  constructor: (@name) ->
    @html = $("##{@name}tooltemplate").html()
    console.log 'WidgetTool name is ' + @name
    console.log 'html is ' + @html
    @jqobj = $(@html)
    btn = @jqobj.find '.designwidget'
    btn.data 'name', @name
    data = 
      name: name
    btn.data 'widget', data    
    $('#objlist').append @jqobj
    
    @jqobj.draggable
      helper: 'clone'
      stop: (ev, ui) =>
        p = {}
        if ev.offsetX?
          p.left = ev.offsetX
          p.top = ev.offsetY
        else
          p.left = ev.pageX - $(ev.target).offsetLeft
          p.top = ev.pageY - $(ev.target).offsetTop
        @createWidget(p)
        
  createWidget: (p) =>
    opts =
      name: @name
      parent: $('.activewidget')
      position: p
      exists: false
    new window["#{@name}Widget"](opts)
    
    
$ ->
  console.log 'widget startup'

  $(document).bind 'sessionState', (user) ->
    #if window.loggedIn
    #  window.WidgetTool = new WidgetTool('widget')
    $('.widgetsall').each ->    
      console.log 'found a widget'
      if $(@)?
        name = $(this).data 'name'
        x = $(@).position().left
        y = $(@).position().top
        opts =
          name: name
          parent: $(this).parent()
          position: $(this).position()
          exists: true
          widget: $(this)
        text = new window["#{name}Widget"](opts)
      else
        console.log 'widget startup #{name} failed'
        
        
window.Widget = Widget
window.WidgetTool = WidgetTool
  
    