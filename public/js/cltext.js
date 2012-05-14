(function() {
  var CLTextTool, CLTextWidget;

  CLTextWidget = (function() {

    function CLTextWidget(parent, x, y, id) {
      var eid, idx;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<textarea class="cltextwidget" id ="' + this.id + '">text</textarea>');
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
          return window.savePage();
        }
      }).bind('click', function(ev) {
        if (!(ev.target.id === eid)) {
          return;
        } else {
          console.log('its ok target id is ' + ev.target.id);
        }
        $(this).cleditor();
        $(this).focus();
        ev.stopPropagation();
        return ev.preventDefault();
      });
    }

    return CLTextWidget;

  })();

  CLTextTool = (function() {

    function CLTextTool() {
      var btn, data, widget, widgethtml,
        _this = this;
      this.active = false;
      widgethtml = $('#cltexttemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'text');
      data = {
        name: 'text'
      };
      btn.data('widget', data);
      $('.cltexttool').live('click', function() {
        if (!_this.active) {
          _this.boxShadow = $('.cltexttool.toolbutton').css('boxShadow');
          $('.cltexttool.toolbutton').css('boxShadow', 'none');
          $('.cltexttool.toolbutton').addClass('active');
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
        if (_this.active) text = new CLTextWidget($('#page'), x, y);
        return window.savePage();
      });
      $('#objlist').append(widget);
      console.log('appended');
    }

    return CLTextTool;

  })();

  $(function() {
    window.textTool = new CLTextTool();
    return $('.cltextwidget').each(function() {
      var text, x, y;
      x = $(this).position().left;
      y = $(this).position().top;
      return text = new CLTextWidget($('#page'), x, y, $(this).attr('id'));
    });
  });

}).call(this);
