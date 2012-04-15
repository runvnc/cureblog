(function() {

  $(function() {
    var data, widget;
    console.log('text comp');
    widget = $("<li class=\"designwidget texticon\" data-name=\"text\">text</li>");
    widget.data('name', 'text');
    data = {
      name: 'text'
    };
    widget.data('widget', data);
    if (!(window.drophandlers != null)) window.drophandlers = {};
    window.drophandlers['text'] = function(ev, ui, droppedon) {
      var newel;
      console.log('DROP HANDLER');
      console.log(ev);
      console.log(ui);
      newel = $('<div contenteditable="true">text</div>');
      $(droppedon).append(newel);
      newel.css('position', 'relative');
      newel.css('display', 'inline-block');
      newel.css({
        position: 'absolute',
        top: ui.position.top + 'px',
        left: ui.position.left + 'px'
      });
      return console.log(this);
    };
    $('#objlist').append(widget);
    console.log('appended');
    return $('.texticon').draggable({
      helper: 'clone'
    });
  });

}).call(this);
