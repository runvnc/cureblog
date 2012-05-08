   
class Recycler
  constructor: ->
    console.log 'Recycler new'
    $('#objs').prepend( '<div id="recycler">♻</div>' )
    
    $('#recycler').droppable
      drop: (ev, ui) ->
        alert 'dropped on recycler'
        name = ui.draggable.data 'name'
        ui.draggable.remove()
        window.savePage()
        
$ ->
  window.recycler = new Recycler()