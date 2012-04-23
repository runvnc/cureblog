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
    /*
      $('.textwidget').live 'click', ->
        console.log 'clicked live'
        #$(this).parent('.widgetcontainer').draggable('disable')
        #$(this).find('.widgetcontainer').draggable('disable');
        #$(this).draggable('disable');
        $(this).find('.textwidget').attr 'contenteditable', true
        #$(this).find('.textwidget').focus()
    */
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
