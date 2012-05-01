(function() {
  var TextTool, TextWidget;

  TextWidget = (function() {

    function TextWidget(parent, x, y, id) {
      var idx;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="textwidget" contenteditable="true" id ="' + this.id + '"><div class="topofwidget">(      )</div>text</div>');
        idx = '#' + this.id;
        this.parent.append(this.el);
        this.el.css({
          position: 'absolute',
          top: this.y + 'px',
          left: this.x + 'px'
        });
        window.savePage();
      } else {
        this.el = $(this.id);
      }
      $('.textwidget').live('blur', function() {
        return window.savePage();
      });
      $('.textwidget').draggable({
        stop: function() {
          $(this).find('.topofwidget').hide();
          return window.savePage();
        }
      }).bind('click', function() {
        $(this).find('.topofwidget').show().css('color', 'red');
        return $(this).focus();
      });
    }

    return TextWidget;

  })();

  TextTool = (function() {

    function TextTool() {
      var btn, data, widget, widgethtml,
        _this = this;
      this.active = false;
      widgethtml = $('#texttemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'text');
      data = {
        name: 'text'
      };
      btn.data('widget', data);
      $('.texttool').live('click', function() {
        if (!_this.active) {
          _this.boxShadow = $('.texttool.toolbutton').css('boxShadow');
          $('.texttool.toolbutton').css('boxShadow', 'none');
          $('.texttool.toolbutton').addClass('active');
          return _this.active = true;
        } else {
          $('.texttool.toolbutton').css('boxShadow', _this.boxShadow);
          $('.texttool.toolbutton').removeClass('active');
          return _this.active = false;
        }
      });
      $('#page').bind('click', function(ev) {
        var text, x, y;
        if (ev.offsetX != null) {
          x = ev.offsetX;
          y = ev.offsetY;
        } else {
          x = ev.pageX - $('#page')[0].offsetLeft;
          y = ev.pageY - $('#page')[0].offsetTop;
        }
        if (_this.active) return text = new TextWidget($('#page'), x, y);
      });
      $('#objlist').append(widget);
      console.log('appended');
    }

    return TextTool;

  })();

  $(function() {
    window.textTool = new TextTool();
    return $('.textwidget').each(function() {
      var text, x, y;
      x = $(this).position().left;
      y = $(this).position().top;
      return text = new TextWidget($('#page'), x, y, $(this).attr('id'));
    });
  });

}).call(this);
