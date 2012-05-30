(function() {
  var IPWTextTool, IPWTextWidget;

  window.editorNum = 1;

  IPWTextWidget = (function() {

    function IPWTextWidget(parent, x, y, id) {
      var idx, oFCKeditor;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="ipwtextwidget widgetcontainer" id ="' + this.id + '"><div class="ipweditable">The quick brown fox jumped.</div></div>');
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
      console.log('its on there');
      $(idx).resizable();
      $(idx).draggable({
        stop: function(ev) {
          return ev.stopPropagation();
        }
      });
      oFCKeditor = new FCKeditor('editor1');
      oFCKeditor.ToolbarSet = 'Simple';
      oFCKeditor.BasePath = "/js/";
      $(idx).find('.ipweditable').editable({
        type: 'wysiwyg',
        editor: oFCKeditor,
        submit: 'save',
        cancel: 'cancel',
        onEdit: function(content) {
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
      var btn, data, widget, widgethtml,
        _this = this;
      this.active = false;
      widgethtml = $('#ipwtexttemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'text');
      data = {
        name: 'text'
      };
      btn.data('widget', data);
      $('.ipwtexttool').live('click', function() {
        if (!_this.active) {
          _this.boxShadow = $('.ipwtexttool.toolbutton').css('boxShadow');
          $('.ipwtexttool.toolbutton').css('boxShadow', 'none');
          $('.ipwtexttool.toolbutton').addClass('active');
          return _this.active = true;
        } else {
          $('.ipwtexttool.toolbutton').css('boxShadow', _this.boxShadow);
          $('.ipwtexttool.toolbutton').removeClass('active');
          return _this.active = false;
        }
      });
      $('#page, .pagescontent').bind('click', function(ev) {
        var ispage, text, x, y;
        ispage = ev.target.className.indexOf('pagescontent') >= 0;
        if (!(ev.target === $('#page')[0] || ispage)) return;
        if (window.alreadyEditing) return;
        if ($('#editor1___Frame').is(':visible')) return;
        if (ev.offsetX != null) {
          x = ev.offsetX;
          y = ev.offsetY;
        } else {
          x = ev.pageX - $(ev.target).offsetLeft;
          y = ev.pageY - $(ev.target).offsetTop;
        }
        if (_this.active) return text = new IPWTextWidget($(ev.target), x, y);
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
