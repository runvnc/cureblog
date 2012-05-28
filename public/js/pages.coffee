class PagesWidget
  constructor: (position, exists) ->
    console.log 'position.top is ' + position.top
    console.log 'position.left is ' + position.left
    if not exists
      pageshtml = $('#pageswidgettemplate').html()
      pages = $(pageshtml)      
      pages.css 'position', 'absolute'
      pages.css 'top', position.top + 'px'
      pages.css 'left', position.left + 'px'
      $('#page').append pages
      
      pages.find('.pagesmenu li').off 'click'      
      pages.find('.pagesmenu li').on 'click', (ev) ->
        name = $(this).text()        
        pages.find('.pagescontent').hide()
        pages.find(".page-#{name}").show()
        
      pages.find('.pagesmenu:first-child').trigger 'click'
  
  
class PagesTool
  constructor: ->
    widgethtml = $('#pagestemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'pages'
    data = 
      name: 'pages'
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
          p.left = ev.pageX - $('#page')[0].offsetLeft
          p.top = ev.pageY - $('#page')[0].offsetTop
        new PagesWidget(p, false)
    
$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.PagesTool = new PagesTool()
      