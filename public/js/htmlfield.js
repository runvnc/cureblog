(function() {
  var HtmlFieldTool, HtmlFieldWidget;

  HtmlFieldWidget = (function() {

    function HtmlFieldWidget(parent, position, exists, widget) {
      var htmlfieldhtml,
        _this = this;
      if (!exists) {
        htmlfieldhtml = $('#htmlfieldwidgettemplate').html();
        this.htmlfield = $(htmlfieldhtml);
        this.htmlfield.css('position', 'absolute');
        this.htmlfield.css('top', position.top + 'px');
        this.htmlfield.css('left', position.left + 'px');
        parent.append(this.htmlfield);
      } else {
        this.htmlfield = widget;
      }
      try {
        this.htmlfield.resizable();
        this.htmlfield.draggable();
      } catch (e) {

      }
      this.obj = this.htmlfield;
      this.htmlfield.data('widget', this);
      this.htmlfield.widget = this;
      this.htmlfield.find('.rename').off('click');
      this.htmlfield.find('.rename').on('click', function() {
        var name;
        name = prompt('Enter field name');
        _this.htmlfield.attr('data-fieldname', name);
        return _this.showname();
      });
      this.showname();
    }

    HtmlFieldWidget.prototype.showname = function() {
      return this.obj.find('.fieldname').html(this.obj.attr('data-fieldname'));
    };

    HtmlFieldWidget.prototype.edit = function(record) {
      var name, oFCKeditor;
      name = this.obj.attr('data-fieldname');
      this.htmlfield.find('.htmleditarea').html(record[name]);
      oFCKeditor = new FCKeditor('editor1');
      oFCKeditor.ToolbarSet = 'Simple';
      oFCKeditor.BasePath = "/js/";
      return this.htmlfield.find('.htmleditarea').editable({
        type: 'wysiwyg',
        editor: oFCKeditor,
        submit: 'save',
        cancel: 'cancel',
        onEdit: function(content) {
          return window.alreadyEditing = true;
        },
        onSubmit: function(content) {
          record[name] = content;
          alert('tried to update record with new val ' + content);
          return window.alreadyEditing = false;
        },
        onCancel: function(content) {
          return window.alreadyEditing = false;
        }
      });
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
