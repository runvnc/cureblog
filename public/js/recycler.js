(function() {
  var Recycler;

  Recycler = (function() {

    function Recycler() {
      console.log('Recycler new');
      $('#objs').prepend('<div id="recycler">♻</div>');
      $('#recycler').droppable({
        drop: function(ev, ui) {
          var name;
          name = ui.draggable.data('name');
          return ui.draggable.remove();
        }
      });
    }

    return Recycler;

  })();

  $(function() {
    return window.recycler = new Recycler();
  });

}).call(this);
