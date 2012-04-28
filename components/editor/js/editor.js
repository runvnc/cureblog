(function() {
  var editWidget, editor, editorcode, editorcss, editorhtml, initeditortabs, initialized, loadwidgets, makeEditable, thing;

  editor = void 0;

  editorhtml = void 0;

  editorcode = void 0;

  editorcss = void 0;

  initialized = false;

  thing = function() {};

  editWidget = function(widget) {
    console.log('inside of editwidget');
    console.log(widget);
    $('#widgetname').data('mode', 'update');
    $('#widgetname').val(widget.name);
    editorcode.setValue(widget.coffee);
    editorhtml.setValue(widget.html);
    return editorcss.setValue(widget.css);
  };

  initeditortabs = function() {
    initialized = true;
    editorhtml = CodeMirror.fromTextArea($("#html")[0], {
      mode: "text/html",
      lineNumbers: true
    });
    editorcode = CodeMirror.fromTextArea($("#coffee")[0], {
      mode: "coffeescript",
      lineNumbers: true
    });
    return editorcss = CodeMirror.fromTextArea($("#css")[0], {
      mode: "text/css",
      lineNumbers: true
    });
  };

  makeEditable = function() {
    return $.contextMenu({
      selector: '.designwidget',
      trigger: 'right',
      callback: function(key, options, e) {
        var el, name;
        el = window.lastMenuEvent.currentTarget;
        switch (key) {
          case 'delete':
            console.log('delete');
            break;
          case 'copy':
            console.log(el);
            now.copyComponent($(el).data('name'), function() {
              return window.location.reload();
            });
            break;
          case 'edit':
            name = $(el).data('name');
            now.getWidgetData(name, function(widgetdata) {
              editWidget(widgetdata);
              $('.demo').dialog({
                title: name + ' component - Code Editor',
                position: 'top',
                height: 'auto',
                width: '900'
              });
              widgetdata = $(el).data('widget');
              if (!initialized) {
                return initeditortabs(widgetdata);
              } else {
                editorcode.setValue(widgetdata.coffee);
                editorhtml.setValue(widgetdata.html);
                return editorcss.setValue(widgetdata.css);
              }
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
          name: "Make a Copy",
          icon: "copy"
        },
        "edit": {
          name: "Edit Code",
          icon: "edit"
        }
      }
    });
  };

  window.savePage = function() {
    console.log('saving html: ' + $('#page').html());
    return now.saveStatic('page', $('#page').html());
  };

  loadwidgets = function() {
    $('#page').droppable({
      drop: function(ev, ui) {
        var name;
        name = ui.draggable.data('name');
        return $('#page').trigger('drop', [ev, ui, this]);
      }
    });
    now.listComponents(function(components) {
      var component, str, _i, _len;
      str = '';
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        str += "<li>" + component + "</li>";
      }
      $('#components').html(str);
      return $('#components li').click(function() {
        return now.getWidgetData($(this).text(), function(widgetdata) {
          return editWidget(widgetdata);
        });
      });
    });
    return makeEditable();
  };

  $(function() {
    $('body').prepend($('#editorui'));
    $('#objs').height($(window).height());
    $('#tabs').tabs({
      show: function(event, ui) {
        if (editorhtml != null) editorhtml.refresh();
        if (editorcode != null) editorcode.refresh();
        if (editorcss != null) return editorcss.refresh();
      }
    });
    $('#savewidget').click(function() {
      var data;
      console.log('you clicked savewidget');
      data = {
        name: $('#widgetname').val(),
        coffee: editorcode.getValue(),
        html: editorhtml.getValue(),
        css: editorcss.getValue()
      };
      now.saveWidgetData(data, function() {
        return alert('Saved');
      });
      return now.restartServer();
    });
    return now.ready(function() {
      var btn;
      loadwidgets();
      btn = $('#objs').prepend('<a href="#" class="button white">Code Editor</a>');
      return btn.click(function() {
        return $('.demo').dialog({
          title: name + ' component - Code Editor',
          position: 'top',
          height: 'auto',
          width: $(window).width() * .7
        }, initeditortabs());
      });
    });
  });

}).call(this);
