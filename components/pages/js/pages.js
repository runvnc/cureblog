(function() {
  var PagesTool, PagesWidget;

  PagesWidget = (function() {

    function PagesWidget(position, exists, widget) {
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
      } else {
        pages = widget;
      }
      pages.find('.pagesmenu li').off('click');
      pages.find('.pagesmenu li').on('click', function(ev) {
        var name;
        name = $(this).text();
        $('.activenav').removeClass('activenav');
        $(this).addClass('activenav');
        pages.find('.pagescontent').hide();
        pages.find(".page-" + name).show();
        $('.activewidget').removeClass('activewidget');
        return pages.find(".page-" + name).addClass('activewidget');
      });
      pages.find('.pagecontent').draggable();
      pages.find('.pagescontent').resizable();
      try {
        pages.find('.pagesmenu li').draggable();
      } catch (e) {

      }
      pages.find('.addpage').off('click');
      pages.find('.addpage').on('click', function() {
        var pagename;
        pagename = prompt('Page name:');
        pages.find('.pagesmenu').append('<li>' + pagename + '</li>');
        pages.find('.pagescontainer').append('<div class=\"pagescontent page-' + pagename + '\"></div>');
        return pages.find('.pagesmenu li').draggable();
      });
      pages.find('.pagesmenu:first-child').trigger('click');
      try {
        pages.draggable({
          handle: '.movepages'
        });
      } catch (e) {

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
    $('.movepages').hide();
    $('.pagesall').each(function() {
      var text, x, y;
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new PagesWidget($(this).position(), true, $(this));
      }
    });
    $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        $('.addpage').show();
        $('.movepages').show();
        return window.PagesTool = new PagesTool();
      } else {
        return $('.addpage').hide();
      }
    });
    return $('#page').on('click', function(ev) {
      if (ev.target.id === 'page') {
        $('.activewidget').removeClass('activewidget');
        return $('#page').addClass('activewidget');
      }
    });
  });

}).call(this);
