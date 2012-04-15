$ ->
  widget = $("<li class=\"designwidget\" data-name=\"#{data.name}\ ">#{data.name}</li>")
  widget.data 'name', data.name
  widget.data 'widget', data
  $('#objlist').append widget
  
