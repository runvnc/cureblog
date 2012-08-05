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
        if (window.loggedIn) {
          this.pageddata.draggable({
            handle: '.movehandle'
          });
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
              alert('callinf lisr');
              return _this.listrecords();
            });
          });
          this.pageddata.find('.savepaged').off('click');
          this.pageddata.find('.savepaged').on('click', function() {
            return _this.save();
          });
          this.listrecords();
          this.pageddata.find('.pgdatatabs').tabs();
        } else {
          this.displaymode();
          if (!(window.location.hash != null) || window.location.hash.length < 3) {
            if (window.location.href.lastIndexOf('/') === window.location.href.length - 1) {
              this.loadrecent();
            }
          }
        }
        $(window).bind('hashchange', function() {
          return _this.checkHash();
        });
        this.checkHash();
      } catch (e) {
        console.log(e);
      }
    }

    PagedDataWidget.prototype.checkHash = function() {
      var collection, criteria, path, title, tokens,
        _this = this;
      if (window.location.hash != null) {
        path = window.location.hash.substr(1);
        if (path.indexOf('content/' >= 0)) {
          tokens = path.split('/');
          collection = tokens[1];
          if (collection === this.pageddata.attr('data-collection')) {
            title = tokens[2];
            title = title.replace(/\-/g, ' ');
            criteria = {
              title: title
            };
            return now.dbquery(collection, criteria, function(record) {
              alert('got the record');
              console.log(record);
              if (record != null) {
                record = record[0];
                if (!(record != null)) {
                  return _this.designmode();
                } else {
                  _this.displaymode();
                  _this.record = record;
                  return _this.display();
                }
              }
            });
          }
        }
      }
    };

    PagedDataWidget.prototype.loadrecent = function(callback) {
      var _this = this;
      return now.dbfind(this.pageddata.attr('data-collection'), function(records) {
        _this.records = records;
        _this.record = records[records.length - 1];
        return setTimeout((function() {
          return _this.display();
        }), 50);
      });
    };

    PagedDataWidget.prototype.displaymode = function() {
      this.pageddata.find('.pagedtop,.toggletop,.movehandle').hide();
      return this.pageddata.css('border', 'none');
    };

    PagedDataWidget.prototype.display = function() {
      var rec;
      rec = this.record;
      return this.pageddata.find('.field').each(function() {
        var widget;
        widget = this.widget;
        return widget.display.call(widget, rec);
      });
    };

    PagedDataWidget.prototype.getfields = function() {
      var fields, s;
      fields = [];
      s = this;
      this.pageddata.find('.field').each(function() {
        var field, widget;
        widget = this.widget;
        field = {
          name: $(this).attr('data-fieldname')
        };
        field.value = widget.blank();
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

    PagedDataWidget.prototype.designmode = function() {
      this.pageddata.find('.editcontrols').hide();
      return this.pageddata.find('.field').each(function() {
        var widget;
        widget = $(this).data('widget');
        return widget.designmode(this.record);
      });
    };

    PagedDataWidget.prototype.save = function() {
      var criteria,
        _this = this;
      this.col = this.pageddata.attr('data-collection');
      criteria = {
        "id": this.record["_id"]
      };
      return now.dbupdate(this.col, criteria, this.record, function() {
        var title;
        _this.listrecords();
        _this.designmode();
        _this.pageddata.find('.widgetcontent').hide();
        _this.pageddata.find('.pagedtop').show();
        now.cachePage('/');
        title = _this.record['title'];
        if (title != null) {
          title = title.replace(/\ /g, '-');
          return now.cachePage(title, _this.col);
        }
      });
    };

    PagedDataWidget.prototype.edit = function(record) {
      var pageddata;
      this.record = record;
      pageddata = this.pageddata;
      this.pageddata.find('.editcontrols').show();
      this.pageddata.find('.pagedtop').hide(100);
      this.pageddata.find('.widgetcontent').show(100);
      this.pageddata.find('#templatehead').text('Post Entry').trigger('click');
      return this.pageddata.find('.field').each(function() {
        var widget;
        widget = $(this).data('widget');
        return widget.edit(record);
      });
    };

    PagedDataWidget.prototype.fieldlist = function(records) {
      var key, keys, record, val, _i, _len;
      keys = {};
      for (_i = 0, _len = records.length; _i < _len; _i++) {
        record = records[_i];
        for (key in record) {
          val = record[key];
          if (key.indexOf('_') !== 0 && !(keys[key] != null)) keys[key] = true;
        }
      }
      return keys;
    };

    PagedDataWidget.prototype.listrecords = function() {
      var col,
        _this = this;
      col = this.pageddata.attr('data-collection');
      if (!(col != null)) return;
      return now.dbfind(this.pageddata.attr('data-collection'), function(records) {
        var fieldname, fields, id, pageddata, record, str, val, _i, _len;
        str = '';
        _this.records = records;
        fields = _this.fieldlist(_this.records);
        str += '<table><tr>';
        for (fieldname in fields) {
          val = fields[fieldname];
          str += '<th class=\"recordhead\">' + fieldname + '</th>';
        }
        str += '</tr>';
        for (_i = 0, _len = records.length; _i < _len; _i++) {
          record = records[_i];
          id = record['_id'];
          str += '<tr class=\"pagedrecord\" id=\"' + id + '\">';
          for (fieldname in fields) {
            val = fields[fieldname];
            if (fieldname.indexOf('_') !== 0 && fieldname === 'title') {
              str += '<td class=\"recorditem\">' + record[fieldname] + '</td>';
            }
          }
          str += '</tr>';
        }
        str += '</table>';
        _this.pageddata.find('.pagedlist').html(str);
        _this.pageddata.find('.pagedrecord').off('click');
        pageddata = _this;
        return _this.pageddata.find('.pagedrecord').on('click', function() {
          var obj;
          col = pageddata.pageddata.attr('data-collection');
          obj = {
            "_id": $(this).attr('id')
          };
          return now.dbquery(col, obj, function(record) {
            record = record[0];
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
          return new PagedDataWidget($('.activewidget'), p, false);
        }
      });
    }

    return PagedDataTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        $('.designonly').show();
        window.PagedDataTool = new PagedDataTool();
        window.saveFilters.push(function(sel) {
          return $(sel).find('.pagedlist li').remove();
        });
      }
      return $('.pageddataall').each(function() {
        var text, x, y;
        if ($(this) != null) {
          x = $(this).position().left;
          y = $(this).position().top;
          return text = new PagedDataWidget($(this).parent(), $(this).position(), true, $(this));
        }
      });
    });
  });

  if (!(window.saveFilters != null)) window.saveFilters = [];

  window.saveFilters.push(function(sel) {
    $(sel).find('.pagedlist table').remove();
    return $(sel).find('.designonly').hide();
  });

}).call(this);
