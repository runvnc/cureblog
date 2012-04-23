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
    newel = $('<div class="textwidget" contenteditable="true" id ="'+id+'">text</div>')
    idx = '#' + id
    $(droppedon).append newel

    newel.css
      position: 'absolute'
      top: ui.position.top + 'px'
      left: ui.position.left + 'px'

    
    window.savePage()
    console.log @
  
  ###
  $('.textwidget').live 'click', ->
    console.log 'clicked live'
    #$(this).parent('.widgetcontainer').draggable('disable')
    #$(this).find('.widgetcontainer').draggable('disable');
    #$(this).draggable('disable');
    $(this).find('.textwidget').attr 'contenteditable', true
    #$(this).find('.textwidget').focus()
  ###
  
  $('.textwidget').blur ->  
    window.savePage()
    
  $('.textwidget').draggable().bind 'click', ->
    $(this).focus()
  
      
  $('#objlist').append widget  
  console.log 'appended'

  
  
  $('.texticon').draggable
    helper: 'clone'
      
