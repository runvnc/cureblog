(function() {
  var Recycler;

  Recycler = (function() {

    function Recycler() {
      $($('#recycler').html()).insertAfter($('#editcode'));
    }

    return Recycler;

  })();

  $(function() {
    return window.recycler = new Recycler();
  });

}).call(this);
