(function() {

  console.log('hello from text component');

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
    window.drophandlers['text'] = function(ev, ui, droppedon) {
      var idx, newel;
      newel = $('<div class="widgetcontainer"><div class="textwidget" contenteditable="false" id ="' + id + '">text</div></div>');
      idx = '#' + id;
      $(droppedon).append(newel);
      window.savePage();
      return console.log(this);
    };
    $('.textwidget').live('click', function() {
      console.log('clicked live');
      return $(this).find('.textwidget').attr('contenteditable', true);
    });
    $('.textwidget').blur(function() {
      return window.savePage();
    });
    $('.widgetcontainer').draggable();
    console.log('objlist is');
    console.log($('#objlist'));
    console.log('widget is ');
    console.log(widget);
    $('#objlist').append(widget);
    console.log('appended');
    return $('.texticon').draggable({
      helper: 'clone'
    });
  });

}).call(this);
