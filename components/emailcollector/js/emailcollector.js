(function() {
  var EmailCollectorTool, EmailCollectorWidget;

  EmailCollectorWidget = (function() {

    function EmailCollectorWidget(parent, position, exists, widget) {
      var emails, emailshtml;
      if (!exists) {
        emailshtml = $('#emailswidgettemplate').html();
        emails = $(emailshtml);
        emails.css('position', 'absolute');
        emails.css('top', position.top + 'px');
        emails.css('left', position.left + 'px');
        parent.append(emails);
      } else {
        emails = widget;
      }
      try {
        emails.draggable();
        $('.saveemail').off('blur');
        $('.saveemail').on('blur', function() {
          now.saveEmail($(this).val());
          return $(this).val('');
        });
      } catch (e) {

      }
    }

    return EmailCollectorWidget;

  })();

  EmailCollectorTool = (function() {

    function EmailCollectorTool() {
      var btn, data, widget, widgethtml;
      widgethtml = $('#emailstemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'emailcollector');
      data = {
        name: 'emailcollector'
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
          return new EmailCollectorWidget($('.activewidget'), p, false);
        }
      });
    }

    return EmailCollectorTool;

  })();

  $(function() {
    $('.emailsall').each(function() {
      var text, x, y;
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new EmailCollectorWidget($(this).parent(), $(this).position(), true, $(this));
      }
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        return window.EmailCollectorTool = new EmailCollectorTool();
      }
    });
  });

}).call(this);
