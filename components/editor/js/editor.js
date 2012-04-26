(function() {
  var editWidget, editor, editorcode, editorcss, editorhtml, loadwidgets, makeEditable, thing;

  editor = void 0;

  editorhtml = void 0;

  editorcode = void 0;

  editorcss = void 0;

  thing = function() {};

  editWidget = function(widget) {
    $('#widgetname').data('mode', 'update');
    $('#widgetname').val(widget.name);
    $('#coffee').val(widget.coffee);
    $('#html').val(widget.html);
    return $('#css').val(widget.css);
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
            console.log('el is ');
            console.log(el);
            name = $(el).data('name');
            console.log('editing name is ' + name);
            now.getWidgetData(name, function(widgetdata) {
              var editorjs;
              editWidget(widgetdata);
              $('.demo').dialog({
                height: 'auto',
                width: '900'
              });
              widgetdata = $(el).data('widget');
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
              editorcss = CodeMirror.fromTextArea($("#css")[0], {
                value: widgetdata.css,
                mode: "text/css",
                lineNumbers: true
              });
              return editorjs = CodeMirror.fromTextArea($("#js")[0], {
                mode: "javascript",
                lineNumbers: true
              });
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
        if (window.drophandlers[name] != null) {
          return window.drophandlers[name](ev, ui, this);
        }
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
