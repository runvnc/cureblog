(function() {
  var TextTool, TextWidget;

  TextWidget = (function() {

    function TextWidget(parent, x, y, id) {
      var eid, idx;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="textwidget" contenteditable="true" id ="' + this.id + '">text</div>');
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
      $('#' + this.id).live('blur', function() {
        return window.savePage();
      });
      eid = this.id;
      $('#' + this.id).draggable({
        stop: function() {
          $(this).find('.topofwidget').remove();
          return window.savePage();
        }
      }).bind('click', function(ev) {
        if (!(ev.target.id === eid)) {
          return;
        } else {
          console.log('its ok target id is ' + ev.target.id);
        }
        console.log('click event');
        $(this).find('.topofwidget').remove();
        $(this).prepend($('#fonttemplate').html());
        $(this).find('.font').off('change');
        $(this).find('.font').on('change', function() {
          console.log('4444444444444444 selected val is ' + $(this).val());
          window.document.execCommand('fontname', false, $(this).val());
          return ev.stopPropagation();
        });
        $(this).focus();
        ev.stopPropagation();
        return ev.preventDefault();
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
        if (_this.active) text = new TextWidget($('#page'), x, y);
        $('.topofwidget').remove();
        return window.savePage();
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
