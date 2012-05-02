(function() {
  var RichTextTool, RichTextWidget;

  RichTextWidget = (function() {

    function RichTextWidget(parent, x, y, id) {
      var eid, idx;
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.id = id;
      if (!(this.id != null)) {
        this.id = guid();
        this.el = $('<div class="richtextwidget" id ="' + this.id + '">rt</div>');
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
        console.log('click event');
        $('#' + eid).ckeditor();
        $(this).focus();
        ev.stopPropagation();
        return ev.preventDefault();
      });
    }

    return RichTextWidget;

  })();

  RichTextTool = (function() {

    function RichTextTool() {
      var btn, data, widget, widgethtml,
        _this = this;
      this.active = false;
      widgethtml = $('#richtexttemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'text');
      data = {
        name: 'text'
      };
      btn.data('widget', data);
      $('.richtexttool').live('click', function() {
        if (!_this.active) {
          _this.boxShadow = $('.richtexttool.toolbutton').css('boxShadow');
          $('.richtexttool.toolbutton').css('boxShadow', 'none');
          $('.richtexttool.toolbutton').addClass('active');
          return _this.active = true;
        } else {
          $('.richtexttool.toolbutton').css('boxShadow', _this.boxShadow);
          $('.richtexttool.toolbutton').removeClass('active');
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
        if (_this.active) text = new RichTextWidget($('#page'), x, y);
        return window.savePage();
      });
      $('#objlist').append(widget);
      console.log('appended');
    }

    return RichTextTool;

  })();

  $(function() {
    return window.richtextTool = new RichTextTool();
  });

}).call(this);
