console.log 'hello from text component'

$ ->
  console.log 'text comp'
  widgethtml = $('#texttemplate').html()
  widget = $(widgethtml)
  btn = widget.find '.designwidget'
  btn.data 'name', 'text'
  data = 
    name: 'text'
  btn.data 'widget', data

  if not window.drophandlers?
    window.drophandlers = {}

  id = guid()
    
  window.drophandlers['text'] = (ev, ui, droppedon) ->
    newel = $('<div class="widgetcontainer"><div class="textwidget" contenteditable="false" id ="'+id+'">text</div></div>')
    idx = '#' + id
    $(droppedon).append newel

    #newel.css
    #  position: 'absolute'
    #  top: ui.position.top + 'px'
    #  left: ui.position.left + 'px'

    
    window.savePage()
    console.log @
  
  $('.textwidget').live 'click', ->
    console.log 'clicked live'
    $(this).find('.textwidget').attr 'contenteditable', true
    
  $('.textwidget').blur ->  
    window.savePage()
    
  $('.widgetcontainer').draggable()
    
  console.log 'objlist is'
  console.log $('#objlist')
  console.log 'widget is '
  console.log widget    
  $('#objlist').append widget  
  console.log 'appended'

  $('.texticon').draggable
    helper: 'clone'
      
