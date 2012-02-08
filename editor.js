$(document).ready(function() {
  $('#savewidget').click(function() {
    data = { name: $('#widgetname').val(),
             code: $('#code').val(),
             html: $('#html').val(),
             css:  $('#css').val() };

    now.dbinsert('widgets', data);            
  });

  now.ready(function() {

    function editWidget(widget) {
      $('#widgetname').val(widget.name);
      $('#code').val(widget.code);
      $('#html').val(widget.html);
      $('#css').val(widget.css);
    }

    function widgetByName(name) {
      for (var i=0; i<widgets.length; i++) {
        if (widgets[i].name == name) {
          return widgets[i];
        }
      }
    }

    now.dbfind('widgets', function(widgets) {
      window.widgets = widgets;
      var ul = '';
      for (var i=0; i<widgets.length; i++) {
        console.log(widgets[i]);
        ul += '<li class="widgetsel" data-name="' + widgets[i].name + '" id="widget-"' + widgets[i].name + '">' + widgets[i].name + '</li>';  
      } 
      $('#widgetlist').html(ul);
      $('.widgetsel').click(function(ev) {
        var name = $(ev.target).attr('data-name');
        var widget = widgetByName(name);
        editWidget(widget);         
      });
    });
  });
  
});


