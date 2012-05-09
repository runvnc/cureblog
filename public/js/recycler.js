(function() {
  var Recycler;

  Recycler = (function() {

    function Recycler() {
      console.log('Recycler new');
      $('#objs').prepend('<div class="recycle"><div id="recycler">♻</div><div class="rectext">Recycle</div></div>');
      $('#recycler').droppable({
        drop: function(ev, ui) {
          var name;
          alert('dropped on recycler');
          name = ui.draggable.data('name');
          ui.draggable.remove();
          return window.savePage();
        }
      });
    }

    return Recycler;

  })();

  $(function() {
    return window.recycler = new Recycler();
  });

}).call(this);
