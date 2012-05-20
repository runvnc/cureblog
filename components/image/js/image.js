(function() {
  var ImageTool, ImageWidget;

  ImageWidget = (function() {

    function ImageWidget(jqueryObj) {
      jqueryObj.css('position', 'absolute');
      jqueryObj.draggable();
    }

    return ImageWidget;

  })();

  ImageTool = (function() {

    function ImageTool() {
      var btn, data, uploadopts, widget, widgethtml,
        _this = this;
      this.active = false;
      widgethtml = $('#imagetemplate').html();
      widget = $(widgethtml);
      btn = widget.find('.designwidget');
      btn.data('name', 'image');
      data = {
        name: 'image'
      };
      btn.data('widget', data);
      $('.imagetool').live('click', function() {
        $('.imagetool.toolbutton').addClass('active');
        return window.delay(500, function() {
          return $('.imagetool.toolbutton').removeClass('active');
        });
      });
      $('#objlist').append(widget);
      uploadopts = {
        action: '/dyn/upload',
        name: 'imageupload',
        onComplete: function(file, response) {
          console.log(file);
          return window.delay(150, function() {
            $('#page').prepend("<img class=\"oicimage\" src=\"images/" + file + "\"/>");
            return $('.oicimage').draggable();
          });
        }
      };
      new AjaxUpload('imginsert', uploadopts);
    }

    return ImageTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) {
        window.ImageTool = new ImageTool();
        return $('.oicimage').each(function() {
          var text;
          if ($(this) != null) {
            return text = new ImageWidget($(this));
          } else {
            return console.log('$(this)? false skipping');
          }
        });
      }
    });
  });

}).call(this);
