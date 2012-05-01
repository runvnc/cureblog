   
class Recycler
  constructor: ->
    console.log 'Recycler new'
    $('#objs').prepend( '<div id="recycler">♻</div>' )
    
    $('#recycler').droppable
      drop: (ev, ui) ->
        name = ui.draggable.data 'name'
        ui.draggable.remove()
        
$ ->
  window.recycler = new Recycler()