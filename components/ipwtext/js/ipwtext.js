(function() {
  var IPWTextTool, IPWTextWidget;

  IPWTextWidget = (function() {

    function IPWTextWidget(parent, x, y, id) {
      var idx, oFCKeditor;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="ipwtextwidget widgetcontainer sizewidget" id ="' + this.id + '"><div class="ipweditable">The quick brown fox jumped.</div></div>');
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
      $(idx).draggable()({
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
        cancel: 'cancel'
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
      $('#page').bind('click', function(ev) {
        var text, x, y;
        if (!ev.target === $('#page')[0]) return;
        if ($('#editor1___Frame').is(':visible')) return;
        if (ev.offsetX != null) {
          x = ev.offsetX;
          y = ev.offsetY;
        } else {
          x = ev.pageX - $('#page')[0].offsetLeft;
          y = ev.pageY - $('#page')[0].offsetTop;
        }
        if (_this.active) text = new IPWTextWidget($('#page'), x, y);
        return window.savePage();
      });
      $('#objlist').append(widget);
      console.log('appended');
    }

    return IPWTextTool;

  })();

  $(function() {
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
  });

  window.saveFilters.push(function(sel) {
    console.log('saveFilter');
    $(sel).find('.ui-resizable-handle').remove();
    $(sel).find('.ipwtextwidget button').remove();
    $(sel).find('#editor1___Frame').remove();
    $(sel).find('#editor1___Config').remove();
    return $(sel).find('#editor1').remove();
  });

}).call(this);
