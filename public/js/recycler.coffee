   
class Recycler
  constructor: ->
    $('#objs').prepend( '<div class="recycle"><div id="recycler">♻</div><div class="rectext">Recycle</div></div>' )
    #♻
    $('#recycler').droppable
      drop: (ev, ui) ->
        name = ui.draggable.data 'name'
        ui.draggable.remove()
        window.savePage()
#

$ ->
  window.recycler = new Recycler()
