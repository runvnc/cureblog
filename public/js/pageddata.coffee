class PagedDataWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      pageddatahtml = $('#pageddatawidgettemplate').html()
      pageddata = $(pageddatahtml)    
      pageddata.css 'position', 'absolute'
      pageddata.css 'top', position.top + 'px'
      pageddata.css 'left', position.left + 'px'
      parent.append pageddata
    else
      pageddata = widget

    try
      pageddata.draggable()
      pageddata.resizable()
      pageddata.off 'click'
      pageddata.on 'click', ->
        $('.activewidget').removeClass 'activewidget'
        $(this).addClass 'activewidget'
    catch e
    

class PagedDataTool
  constructor: ->
    widgethtml = $('#pageddatatemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'pageddatacollector'
    data = 
      name: 'pageddatacollector'
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
        new PagedDataWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.pageddataall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new PagedDataWidget($(this).parent(),$(this).position(), true, $(this))  
  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.PagedDataTool = new PagedDataTool()