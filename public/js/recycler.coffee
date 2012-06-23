   
class Recycler
  constructor: ->
    $('#objs').prepend( '<div class="recycle" title="Recycle (drag widgets here to remove them from the page)"><div id="recycler">♻</div></div>' )
    #♻
    $('#recycler').droppable
      tolerance: 'touch'
      drop: (ev, ui) ->
        if ui.draggable.hasClass 'ui-dialog' then return
        name = ui.draggable.data 'name'
        ui.draggable.remove()
        window.savePage()
#

$ ->
  window.recycler = new Recycler()
