(function() {
  var PagedDataTool, PagedDataWidget;

  PagedDataWidget = (function() {

    function PagedDataWidget(parent, position, exists, widget) {
      var pageddata, pageddatahtml,
        _this = this;
      if (!exists) {
        pageddatahtml = $('#pageddatawidgettemplate').html();
        this.pageddata = $(pageddatahtml);
        this.pageddata.css('position', 'absolute');
        this.pageddata.css('top', position.top + 'px');
        this.pageddata.css('left', position.left + 'px');
        parent.append(this.pageddata);
      } else {
        this.pageddata = widget;
      }
      try {
        pageddata = this.pageddata;
        this.pageddata.draggable();
        this.pageddata.resizable();
        this.pageddata.find('.widgetcontent').off('click');
        this.pageddata.find('.widgetcontent').on('click', function() {
          $('.activewidget').removeClass('activewidget');
          return $(this).addClass('activewidget');
        });
        this.pageddata.find('.pagedtype').off('change');
        this.pageddata.find('.pagedtype').on('change', function() {
          return pageddata.attr('data-collection', $(this).val());
        });
        if (this.pageddata.attr('data-collection') != null) {
          this.pageddata.find('.pagedtype').val(this.pageddata.attr('data-collection'));
        }
        this.pageddata.find('.addpaged').off('click');
        this.pageddata.find('.addpaged').on('click', function() {
          var record;
          record = _this.newblank();
          return now.dbinsert(_this.pageddata.attr('data-collection'), record, function() {
            return _this.listrecords();
          });
        });
        this.pageddata.find('.toggletop').off('click');
        this.pageddata.find('.toggletop').on('click', function() {
          return _this.pageddata.find('.pagedtop').toggle(100);
        });
        this.listrecords();
      } catch (e) {
        console.log(e);
      }
    }

    PagedDataWidget.prototype.getfields = function() {
      var fields, s;
      fields = [];
      s = this;
      this.pageddata.find('.field').each(function() {
        var field;
        field = {
          name: $(this).attr('data-fieldname')
        };
        field.value = s.blank(field);
        return fields.push(field);
      });
      return fields;
    };

    PagedDataWidget.prototype.blank = function(field) {
      return 'New';
    };

    PagedDataWidget.prototype.newblank = function() {
      var field, fields, obj, _i, _len;
      fields = this.getfields();
      obj = {};
      for (_i = 0, _len = fields.length; _i < _len; _i++) {
        field = fields[_i];
        obj[field.name] = field.value;
      }
      return obj;
    };

    PagedDataWidget.prototype.edit = function(record) {
      var pageddata;
      pageddata = this.pageddata;
      return this.pageddata.find('.field').each(function() {
        var widget;
        console.log('trying to edit something');
        console.log(this);
        console.log('this.data is ');
        console.log($(this).data('widget'));
        widget = $(this).data('widget');
        return widget.edit(record);
      });
    };

    PagedDataWidget.prototype.listrecords = function() {
      var _this = this;
      return now.dbfind(this.pageddata.attr('data-collection'), function(records) {
        var fieldname, fieldstr, id, pageddata, record, str, val, _i, _len;
        str = '';
        for (_i = 0, _len = records.length; _i < _len; _i++) {
          record = records[_i];
          fieldstr = '';
          id = record['_id'];
          for (fieldname in record) {
            val = record[fieldname];
            if (fieldname.indexOf('_') !== 0) fieldstr += fieldname + ':' + val;
          }
          str += '<li class=\"pagedrecord\" id=\"' + id + '\">' + fieldstr + '</li>';
        }
        _this.pageddata.find('.pagedlist').html(str);
        _this.pageddata.find('.pagedrecord').off('click');
        pageddata = _this;
        return _this.pageddata.find('.pagedrecord').on('click', function() {
          var col, obj;
          alert('you clicked');
          col = pageddata.pageddata.attr('data-collection');
          obj = {
            id: $(this).attr('id')
          };
          return now.dbquery(col, obj, function(record) {
            alert('returned');
            console.log(record);
            return pageddata.edit.call(pageddata, record);
          });
        });
      });
    };

    return PagedDataWidget;

  })();

  PagedDataTool = (function() {

    function PagedDataTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#pageddatatemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'pageddatacollector');
      data = {
        name: 'pageddatacollector'
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
          return new PagedDataWidget($('.activewidget'), p, false);
        }
      });
    }

    return PagedDataTool;

  })();

  $(function() {
    now.ready(function() {
      return $('.pageddataall').each(function() {
        var text, x, y;
        if ($(this) != null) {
          x = $(this).position().left;
          y = $(this).position().top;
          return text = new PagedDataWidget($(this).parent(), $(this).position(), true, $(this));
        }
      });
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.PagedDataTool = new PagedDataTool();
    });
  });

}).call(this);
