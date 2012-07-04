(function() {
  var IPWTextTool, IPWTextWidget;

  window.editorNum = 1;

  IPWTextWidget = (function() {

    function IPWTextWidget(parent, x, y, id) {
      var hoveroff, hoveron, idx, oFCKeditor;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="ipwtextwidget widgetcontainer" id ="' + this.id + '" ><div class="textmove"></div><div class="ipweditable">The quick brown fox jumped...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/></div></div>');
        idx = '#' + this.id;
        this.parent.append(this.el);
        this.el.css({
          position: 'absolute',
          top: this.y + 'px',
          left: this.x + 'px'
        });
      } else {
        this.el = $(this.id);
        idx = '#' + this.id;
      }
      $(idx).resizable();
      $(idx).draggable({
        stop: function(ev) {
          return ev.stopPropagation();
        }
      });
      hoveron = function() {
        if (!window.alreadyEditing) return $(this).find('.textmove').show();
      };
      hoveroff = function() {
        return $(this).find('.textmove').hide();
      };
      $(idx).hover(hoveron, hoveroff);
      oFCKeditor = new FCKeditor('editor1');
      oFCKeditor.ToolbarSet = 'Simple';
      oFCKeditor.BasePath = "/js/";
      $(idx).find('.ipweditable').editable({
        type: 'wysiwyg',
        editor: oFCKeditor,
        submit: 'save',
        cancel: 'cancel',
        onEdit: function(content) {
          $(idx).find('.textmove').hide();
          return window.alreadyEditing = true;
        },
        onSubmit: function(content) {
          return window.alreadyEditing = false;
        },
        onCancel: function(content) {
          return window.alreadyEditing = false;
        }
      });
    }

    return IPWTextWidget;

  })();

  IPWTextTool = (function() {

    function IPWTextTool() {
      var btn, data, widget, widgethtml;
      this.active = false;
      widgethtml = $('#ipwtexttemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'text');
      data = {
        name: 'text'
      };
      btn.data('widget', data);
      widget.draggable({
        helper: 'clone',
        stop: function(ev, ui) {
          var p;
          p = {};
          if (ev.offsetX != null) {
            p.left = ev.offsetX;
            p.top = ev.offsetY;
          } else {
            p.left = ev.pageX - $(ev.target).offsetLeft;
            p.top = ev.pageY - $(ev.target).offsetTop;
          }
          return new IPWTextWidget($('.activewidget'), p.left, p.top);
        }
      });
      $('#objlist').append(widget);
    }

    return IPWTextTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        window.IPWTextTool = new IPWTextTool();
        return $('.ipwtextwidget').each(function() {
          var text, x, y;
          if ($(this) != null) {
            console.log('creating IPWTextWidget');
            x = $(this).position().left;
            y = $(this).position().top;
            return text = new IPWTextWidget($('#page'), x, y, $(this).attr('id'));
          } else {
            return console.log('$(this)? false skipping');
          }
        });
      }
    });
  });

  window.saveFilters.push(function(sel) {
    $(sel).find('.ui-resizable-handle').remove();
    $(sel).find('.ipwtextwidget button').remove();
    $(sel).find('.sizewidget').removeClass('sizewidget');
    $(sel).find('#editor1___Frame').remove();
    $(sel).find('#editor1___Config').remove();
    $(sel).find('#editor1').remove();
    $(sel).find('#editor2___Frame').remove();
    $(sel).find('#editor2___Config').remove();
    $(sel).find('#editor2').remove();
    $(sel).find('#editor3___Frame').remove();
    $(sel).find('#editor3___Config').remove();
    $(sel).find('#editor3').remove();
    $(sel).find('#editor4___Frame').remove();
    $(sel).find('#editor4___Config').remove();
    $(sel).find('#editor4').remove();
    $(sel).find('#editor5___Frame').remove();
    $(sel).find('#editor5___Config').remove();
    $(sel).find('#editor5').remove();
    $(sel).find('#editor6___Frame').remove();
    $(sel).find('#editor6___Config').remove();
    return $(sel).find('#editor6').remove();
  });

}).call(this);
