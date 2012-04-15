$ ->
  console.log 'text comp'
  widget = $("<li class=\"designwidget texticon\" data-name=\"text\">text</li>")
  widget.data 'name', 'text'
  data = 
    name: 'text'
  widget.data 'widget', data

  if not window.drophandlers?
    window.drophandlers = {}

  window.drophandlers['text'] = (ev, ui, droppedon) ->
    console.log 'DROP HANDLER'
    console.log ev
    console.log ui
    newel = $('<div contenteditable="true">text</div>')
    $(droppedon).append newel
    newel.css 'position', 'relative'
    newel.css 'display', 'inline-block'
    newel.css
      position: 'absolute'
      top: ui.position.top + 'px'
      left: ui.position.left + 'px'
    console.log @
        

  $('#objlist').append widget  
  console.log 'appended'

  $('.texticon').draggable
    helper: 'clone'
      
