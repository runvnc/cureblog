(function() {
  var PagedDataTool, PagedDataWidget;

  PagedDataWidget = (function() {

    function PagedDataWidget(parent, position, exists, widget) {
      var pageddata, pageddatahtml;
      if (!exists) {
        pageddatahtml = $('#pageddatawidgettemplate').html();
        pageddata = $(pageddatahtml);
        pageddata.css('position', 'absolute');
        pageddata.css('top', position.top + 'px');
        pageddata.css('left', position.left + 'px');
        parent.append(pageddata);
      } else {
        pageddata = widget;
      }
      try {
        pageddata.draggable();
        pageddata.resizable();
        pageddata.off('click');
        pageddata.on('click', function() {
          $('.activewidget').removeClass('activewidget');
          return $(this).addClass('activewidget');
        });
      } catch (e) {

      }
    }

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
    $('.pageddataall').each(function() {
      var text, x, y;
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new PagedDataWidget($(this).parent(), $(this).position(), true, $(this));
      }
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.PagedDataTool = new PagedDataTool();
    });
  });

}).call(this);
