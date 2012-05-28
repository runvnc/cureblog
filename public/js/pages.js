(function() {
  var PagesTool, PagesWidget;

  PagesWidget = (function() {

    function PagesWidget(position, exists) {
      var pages, pageshtml;
      console.log('position.top is ' + position.top);
      console.log('position.left is ' + position.left);
      if (!exists) {
        pageshtml = $('#pageswidgettemplate').html();
        pages = $(pageshtml);
        pages.css('position', 'absolute');
        pages.css('top', position.top + 'px');
        pages.css('left', position.left + 'px');
        $('#page').append(pages);
        pages.find('.pagesmenu li').off('click');
        pages.find('.pagesmenu li').on('click', function(ev) {
          var name;
          name = $(this).text();
          pages.find('.pagescontent').hide();
          return pages.find(".page-" + name).show();
        });
        pages.find('.pagesmenu:first-child').trigger('click');
      }
    }

    return PagesWidget;

  })();

  PagesTool = (function() {

    function PagesTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#pagestemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'pages');
      data = {
        name: 'pages'
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
            p.left = ev.pageX - $('#page')[0].offsetLeft;
            p.top = ev.pageY - $('#page')[0].offsetTop;
          }
          return new PagesWidget(p, false);
        }
      });
    }

    return PagesTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.PagesTool = new PagesTool();
    });
  });

}).call(this);
