(function() {
  var EtherCalcTool, EtherCalcWidget;

  EtherCalcWidget = (function() {

    function EtherCalcWidget(parent, position, exists, widget) {
      var ethercalc, ethercalchtml, id;
      if (!exists) {
        id = window.guid();
        ethercalchtml = $('#ethercalcwidgettemplate').html();
        ethercalc = $(ethercalchtml);
        ethercalc.attr('id', id);
        ethercalc.find('iframe').attr('src', "http://localhost:8000/" + id);
        ethercalc.css('position', 'absolute');
        ethercalc.css('top', position.top + 'px');
        ethercalc.css('left', position.left + 'px');
        parent.append(ethercalc);
      } else {
        ethercalc = widget;
      }
      try {
        ethercalc.draggable();
        ethercalc.resizable();
      } catch (e) {

      }
    }

    return EtherCalcWidget;

  })();

  EtherCalcTool = (function() {

    function EtherCalcTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#ethercalctemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'ethercalc');
      data = {
        name: 'ethercalc'
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
          return new EtherCalcWidget($('.activewidget'), p, false);
        }
      });
    }

    return EtherCalcTool;

  })();

  $(function() {
    $('.ethercalcall').each(function() {
      var text, x, y;
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new EtherCalcWidget($(this).parent(), $(this).position(), true, $(this));
      }
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.EtherCalcTool = new EtherCalcTool();
    });
  });

  window.saveFilters.push(function(sel) {
    $(sel).find('.ui-resizable-handle').remove();
    return $(sel).find('.sizewidget').removeClass('sizewidget');
  });

}).call(this);
