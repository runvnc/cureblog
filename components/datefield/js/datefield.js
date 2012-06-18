(function() {
  var DateFieldTool, DateFieldWidget,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  DateFieldWidget = (function() {

    function DateFieldWidget(parent, position, exists, widget) {
      this.blank = __bind(this.blank, this);
      var datefieldhtml,
        _this = this;
      if (!exists) {
        datefieldhtml = $('#datefieldwidgettemplate').html();
        this.datefield = $(datefieldhtml);
        this.datefield.css('position', 'absolute');
        this.datefield.css('top', position.top + 'px');
        this.datefield.css('left', position.left + 'px');
        parent.append(this.datefield);
      } else {
        this.datefield = widget;
      }
      try {
        this.datefield.resizable();
        this.datefield.draggable();
      } catch (e) {

      }
      this.obj = this.datefield;
      this.datefield.data('widget', this);
      this.datefield[0].widget = this;
      this.datefield.widget = this;
      this.datefield.find('.rename').off('click');
      this.datefield.find('.rename').on('click', function() {
        var name;
        name = prompt('Enter field name');
        _this.datefield.attr('data-fieldname', name);
        return _this.showname();
      });
      this.showname();
      if (window.loggedIn) this.designmode();
    }

    DateFieldWidget.prototype.showname = function() {
      var name, newhtml, template;
      name = this.obj.attr('data-fieldname');
      this.obj.find('.fieldname').html(name);
      template = this.datefield.find('.datetimeeditarea').html();
      newhtml = template.replace(/\{\{[a-z0-9]*\}\}/i, '{{' + name + '}}');
      return this.datefield.find('.datetimeeditarea').html(newhtml);
    };

    DateFieldWidget.prototype.blank = function() {
      return new Date();
    };

    DateFieldWidget.prototype.edit = function(record) {
      var name;
      name = this.obj.attr('data-fieldname');
      this.datefield.find('.dateinput').show();
      this.datefield.find('.datetimeeditarea').hide();
      record[name] = new Date();
      this.datefield.find('.dateinput').val(record[name]);
      this.datefield.find('.datetimeeditarea').hide();
      this.datefield.find('.dateinput').off('blur');
      return this.datefield.find('.dateinput').on('blur', function() {
        return record[name] = $(this).val();
      });
    };

    DateFieldWidget.prototype.display = function(record) {
      var name, newhtml, template, txt;
      name = this.obj.attr('data-fieldname');
      template = this.datefield.find('.datetimeeditarea').html();
      txt = dateFormat(record[name], "dddd, mmmm dS, yyyy, h:MM:ss TT");
      newhtml = template.replace('{{' + name + '}}', txt);
      this.datefield.find('.datetimedisplay').html(newhtml);
      this.datefield.find('.datetimeeditarea').hide();
      this.datefield.find('.rename,.fieldname').hide();
      return this.datefield.css('border', 'none');
    };

    DateFieldWidget.prototype.designmode = function() {
      var currhtml, name, oFCKeditor;
      name = this.obj.attr('data-fieldname');
      this.datefield.find('.dateinput').hide();
      currhtml = this.datefield.find('.datetimeeditarea').html();
      if (currhtml.indexOf('{{') < 0 || currhtml.indexOf('{{undefined}}') > 0) {
        this.datefield.find('.datetimeeditarea').html('{{' + name + '}}');
      }
      this.datefield.find('.datetimeeditarea').show();
      oFCKeditor = new FCKeditor('editor1');
      oFCKeditor.ToolbarSet = 'Simple';
      oFCKeditor.BasePath = "/js/";
      return this.datefield.find('.datetimeeditarea').editable({
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

    return DateFieldWidget;

  })();

  DateFieldTool = (function() {

    function DateFieldTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#datefieldtemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'datefieldcollector');
      data = {
        name: 'datefieldcollector'
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
          return new DateFieldWidget($('.activewidget'), p, false);
        }
      });
    }

    return DateFieldTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) window.DateFieldTool = new DateFieldTool();
      return $('.datefieldall').each(function() {
        var text, x, y;
        if ($(this) != null) {
          x = $(this).position().left;
          y = $(this).position().top;
          return text = new DateFieldWidget($(this).parent(), $(this).position(), true, $(this));
        }
      });
    });
  });

}).call(this);
