(function() {
  var editWidget, editor, loadwidget, loadwidgets, makeEditable, thing;

  editor = void 0;

  loadwidget = function(data) {
    var deswidget;
    try {
      $('#widgets').append(data.html);
      $('head').append("<style>" + data.css + "</style>");
      $('head').append("<script>" + data.code + "</script>");
      deswidget = $("<li class=\"deswidget\">" + data.name + "</li>");
      deswidget.data('name', data.name);
      deswidget.data('widget', data);
      return $('#objlist').append(deswidget);
    } catch (e) {
      return console.log(e);
    }
  };

  thing = function() {};

  editWidget = function(widget) {
    $('#widgetname').data('mode', 'update');
    $('#widgetname').val(widget.name);
    $('#code').val(widget.code);
    $('#html').val(widget.html);
    return $('#css').val(widget.css);
  };

  makeEditable = function() {
    return $.contextMenu({
      selector: '.deswidget',
      trigger: 'right',
      callback: function(key, options, e) {
        var el, name, widgetdata;
        el = window.lastMenuEvent.currentTarget;
        switch (key) {
          case 'delete':
            console.log('delete');
            break;
          case 'copy':
            console.log(el);
            break;
          case 'edit':
            name = $(el).data('name');
            editWidget($(el).data('widget'));
            $('.demo').dialog({
              height: '450',
              width: '900'
            });
            widgetdata = $(el).data('widget');
            editor = CodeMirror.fromTextArea($("#html")[0], {
              value: widgetdata.html,
              mode: "text/html",
              lineNumbers: true
            });
        }
        return true;
      },
      items: {
        "delete": {
          name: "Delete",
          icon: "delete"
        },
        "copy": {
          name: "Copy",
          icon: "copy"
        },
        "edit": {
          name: "Edit Code",
          icon: "edit"
        }
      }
    });
  };

  /*
    $('#savewidget').click(function() {
      data = { name: $('#widgetname').val(),
               code: $('#code').val(),
               html: $('#html').val(),
               css:  $('#css').val() };
  
      var mode = $('#widgetname').data('mode');
      if (mode == 'update') {
        now.dbupdate('widgets', { name: data.name }, data);
      } else {
        now.dbinsert('widgets', data);
      }
    });
  
    now.ready(function() {
  */

  loadwidgets = function() {
    now.dbfind('widgets', function(widgets) {
      var widget, _i, _len;
      window.widgets = widgets;
      for (_i = 0, _len = widgets.length; _i < _len; _i++) {
        widget = widgets[_i];
        loadwidget(widget);
      }
      $('.deswidget').draggable({
        helper: 'clone'
      });
      return $('#page').droppable({
        drop: function(ev, ui) {
          var name;
          name = ui.draggable.text();
          console.log('name is ' + name);
          $('head').append("<script>window.newobj = new " + name + "</script>");
          window.newobj.init({
            parent: $('#page'),
            data: {
              test: 'blah'
            }
          });
          return window.newobj.render();
        }
      });
    });
    return makeEditable();
  };

  $(function() {
    $('#tabs').tabs({
      show: function(event, ui) {
        if (editor != null) return editor.refresh();
      }
    });
    return now.ready(function() {
      return loadwidgets();
    });
  });

}).call(this);
