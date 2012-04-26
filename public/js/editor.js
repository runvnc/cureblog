(function() {
  var editWidget, editor, editorcode, editorcss, editorhtml, initeditortabs, initialized, loadwidgets, makeEditable, thing;

  editor = void 0;

  editorhtml = void 0;

  editorcode = void 0;

  editorcss = void 0;

  initialized = false;

  thing = function() {};

  editWidget = function(widget) {
    $('#widgetname').data('mode', 'update');
    $('#widgetname').val(widget.name);
    $('#coffee').val(widget.coffee);
    $('#html').val(widget.html);
    return $('#css').val(widget.css);
  };

  initeditortabs = function(widgetdata) {
    initialized = true;
    editorhtml = CodeMirror.fromTextArea($("#html")[0], {
      value: widgetdata.html,
      mode: "text/html",
      lineNumbers: true
    });
    editorcode = CodeMirror.fromTextArea($("#coffee")[0], {
      value: widgetdata.coffee,
      mode: "coffeescript",
      lineNumbers: true
    });
    return editorcss = CodeMirror.fromTextArea($("#css")[0], {
      value: widgetdata.css,
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
      console.log('now.ready fired');
      return loadwidgets();
    });
  });

}).call(this);
