(function() {
  var HtmlFieldTool, HtmlFieldWidget;

  HtmlFieldWidget = (function() {

    function HtmlFieldWidget(parent, position, exists, widget) {
      var htmlfield, htmlfieldhtml,
        _this = this;
      if (!exists) {
        htmlfieldhtml = $('#htmlfieldwidgettemplate').html();
        htmlfield = $(htmlfieldhtml);
        htmlfield.css('position', 'absolute');
        htmlfield.css('top', position.top + 'px');
        htmlfield.css('left', position.left + 'px');
        parent.append(htmlfield);
      } else {
        htmlfield = widget;
      }
      try {
        htmlfield.resizable();
        htmlfield.draggable();
      } catch (e) {

      }
      this.obj = htmlfield;
      htmlfield.find('.rename').off('click');
      htmlfield.find('.rename').on('click', function() {
        var name;
        name = prompt('Enter field name');
        htmlfield.attr('data-fieldname', name);
        return _this.showname();
      });
      this.showname();
    }

    HtmlFieldWidget.prototype.showname = function() {
      return this.obj.find('.fieldname').html(this.obj.attr('data-fieldname'));
    };

    return HtmlFieldWidget;

  })();

  HtmlFieldTool = (function() {

    function HtmlFieldTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#htmlfieldtemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'htmlfieldcollector');
      data = {
        name: 'htmlfieldcollector'
      };
      btn.data('widget', data);
      $('#objlist').append(widget);
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
          return new HtmlFieldWidget($('.activewidget'), p, false);
        }
      });
    }

    return HtmlFieldTool;

  })();

  $(function() {
    $('.htmlfieldall').each(function() {
      var text, x, y;
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new HtmlFieldWidget($(this).parent(), $(this).position(), true, $(this));
      }
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.HtmlFieldTool = new HtmlFieldTool();
    });
  });

}).call(this);
