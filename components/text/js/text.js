(function() {

  console.log('test from text component');

  $(function() {
    var btn, data, id, widget, widgethtml;
    console.log('text comp');
    widgethtml = $('#texttemplate').html();
    widget = $(widgethtml);
    btn = widget.find('.designwidget');
    btn.data('name', 'text');
    data = {
      name: 'text'
    };
    btn.data('widget', data);
    if (!(window.drophandlers != null)) window.drophandlers = {};
    id = guid();
    $('.texttool').live('click', function() {
      return $('.texttool.toolbutton').css('boxShadow', 'none');
    });
    window.drophandlers['text'] = function(ev, ui, droppedon) {
      var idx, newel;
      newel = $('<div class="textwidget" contenteditable="true" id ="' + id + '">text</div>');
      idx = '#' + id;
      $(droppedon).append(newel);
      newel.css({
        position: 'absolute',
        top: ui.position.top + 'px',
        left: ui.position.left + 'px'
      });
      window.savePage();
      return console.log(this);
    };
    $('.textwidget').blur(function() {
      return window.savePage();
    });
    $('.textwidget').draggable().bind('click', function() {
      return $(this).focus();
    });
    $('#objlist').append(widget);
    console.log('appended');
    return $('.texticon').draggable({
      helper: 'clone'
    });
  });

}).call(this);
