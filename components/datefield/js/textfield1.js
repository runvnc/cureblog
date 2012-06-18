(function() {
  var TextFieldTool, TextFieldWidget;

  TextFieldWidget = (function() {

    function TextFieldWidget(parent, position, exists, widget) {
      var textfieldhtml,
        _this = this;
      if (!exists) {
        textfieldhtml = $('#textfieldwidgettemplate').html();
        this.textfield = $(textfieldhtml);
        this.textfield.css('position', 'absolute');
        this.textfield.css('top', position.top + 'px');
        this.textfield.css('left', position.left + 'px');
        parent.append(this.textfield);
      } else {
        this.textfield = widget;
      }
      try {
        this.textfield.resizable();
        this.textfield.draggable();
      } catch (e) {

      }
      this.obj = this.textfield;
      this.textfield.data('widget', this);
      this.textfield[0].widget = this;
      this.textfield.widget = this;
      this.textfield.find('.rename').off('click');
      this.textfield.find('.rename').on('click', function() {
        var name;
        name = prompt('Enter field name');
        _this.textfield.attr('data-fieldname', name);
        return _this.showname();
      });
      this.showname();
      if (window.loggedIn) this.designmode();
    }

    TextFieldWidget.prototype.showname = function() {
      var name, newhtml, template;
      name = this.obj.attr('data-fieldname');
      this.obj.find('.fieldname').html(name);
      template = this.textfield.find('.texthtmleditarea').html();
      newhtml = template.replace(/\{\{[a-z0-9]*\}\}/i, '{{' + name + '}}');
      return this.textfield.find('.texthtmleditarea').html(newhtml);
    };

    TextFieldWidget.prototype.edit = function(record) {
      var name;
      name = this.obj.attr('data-fieldname');
      this.textfield.find('.textinput').show();
      this.textfield.find('.texthtmleditarea').hide();
      this.textfield.find('.textinput').val(record[name]);
      this.textfield.find('.texthtmleditarea').hide();
      this.textfield.find('.textinput').off('blur');
      return this.textfield.find('.textinput').on('blur', function() {
        return record[name] = $(this).val();
      });
    };

    TextFieldWidget.prototype.display = function(record) {
      var name, newhtml, template;
      name = this.obj.attr('data-fieldname');
      template = this.textfield.find('.texthtmleditarea').html();
      newhtml = template.replace('{{' + name + '}}', record[name]);
      this.textfield.find('.texthtmldisplay').html(newhtml);
      this.textfield.find('.texthtmleditarea').hide();
      this.textfield.find('.rename,.fieldname').hide();
      return this.textfield.css('border', 'none');
    };

    TextFieldWidget.prototype.designmode = function() {
      var currhtml, name, oFCKeditor;
      name = this.obj.attr('data-fieldname');
      this.textfield.find('.textinput').hide();
      currhtml = this.textfield.find('.texthtmleditarea').html();
      if (currhtml.indexOf('{{') < 0 || currhtml.indexOf('{{undefined}}') > 0) {
        this.textfield.find('.texthtmleditarea').html('{{' + name + '}}');
      }
      this.textfield.find('.texthtmleditarea').show();
      oFCKeditor = new FCKeditor('editor1');
      oFCKeditor.ToolbarSet = 'Simple';
      oFCKeditor.BasePath = "/js/";
      return this.textfield.find('.texthtmleditarea').editable({
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
    };

    return TextFieldWidget;

  })();

  TextFieldTool = (function() {

    function TextFieldTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#textfieldtemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'textfieldcollector');
      data = {
        name: 'textfieldcollector'
      };
      btn.data('widget', data);
      $('#advobjlist').append(widget);
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
          return new TextFieldWidget($('.activewidget'), p, false);
        }
      });
    }

    return TextFieldTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) window.TextFieldTool = new TextFieldTool();
      return $('.textfieldall').each(function() {
        var text, x, y;
        if ($(this) != null) {
          x = $(this).position().left;
          y = $(this).position().top;
          return text = new TextFieldWidget($(this).parent(), $(this).position(), true, $(this));
        }
      });
    });
  });

}).call(this);
