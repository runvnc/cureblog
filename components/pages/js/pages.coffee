class PagesWidget
  constructor: (position, exists, widget) ->
    console.log 'position.top is ' + position.top
    console.log 'position.left is ' + position.left
    if not exists
      pageshtml = $('#pageswidgettemplate').html()
      pages = $(pageshtml)    
      pages.css 'position', 'absolute'
      pages.css 'top', position.top + 'px'
      pages.css 'left', position.left + 'px'
      $('#page').append pages
    else
      pages = widget
    pages.find('.pagesmenu li').off 'click'      
    pages.find('.pagesmenu li').on 'click', (ev) ->
      name = $(this).text()        
      pages.find('.pagescontent').hide()
      pages.find(".page-#{name}").show()
      $('.activewidget').removeClass 'activewidget'
      pages.find(".page-#{name}").addClass 'activewidget'
      
    pages.find('.pagesmenu:first-child').trigger 'click'
    try
      pages.draggable({handle: '.movepages'})
    catch e
     
    
class PagesTool
  constructor: ->
    widgethtml = $('#pagestemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'pages'
    data = 
      name: 'pages'
    btn.data 'widget', data    
    $('#advobjlist').append widget 
    
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
  $('.movepages').hide()
  $('.pagesall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new PagesWidget($(this).position(), true, $(this))  
  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      $('.movepages').show()
      window.PagesTool = new PagesTool()
      
  $('#page').on 'click', (ev) ->
    if ev.target.id is 'page'
      $('.activewidget').removeClass 'activewidget'
      $('#page').addClass 'activewidget'
    
    