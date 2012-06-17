(function() {
  var EmailCollectorTool, EmailCollectorWidget;

  EmailCollectorWidget = (function() {

    function EmailCollectorWidget(parent, position, exists, widget) {
      var emails, emailshtml;
      console.log('constructor for emailconstructorwidget');
      if (!exists) {
        console.log('not exists');
        emailshtml = $('#emailswidgettemplate').html();
        emails = $(emailshtml);
        emails.css('position', 'absolute');
        emails.css('top', position.top + 'px');
        emails.css('left', position.left + 'px');
        parent.append(emails);
        emails.draggable();
      } else {
        console.log('exists');
        emails = widget;
      }
      try {
        console.log('.saveemail is ');
        console.log($('.saveemail'));
        $('.saveemail').off('blur');
        $('.saveemail').on('blur', function() {
          console.log('blur activated');
          console.log('value is ' + $(this).val());
          return now.saveEmail($(this).val(), function(success, msg) {
            if (success) return $(this).val('');
          });
        });
      } catch (e) {
        console.log(e);
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
    console.log('emailcollector startup');
    $('.emailsall').each(function() {
      var text, x, y;
      console.log('found an email collector');
      if ($(this) != null) {
        x = $(this).position().left;
        y = $(this).position().top;
        return text = new EmailCollectorWidget($(this).parent(), $(this).position(), true, $(this));
      } else {
        return console.log('email collector failed');
      }
    });
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        return window.EmailCollectorTool = new EmailCollectorTool();
      }
    });
  });

}).call(this);
