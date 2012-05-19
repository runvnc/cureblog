(function() {
  var ImageTool;

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
        onComplete: function(file, response) {
          return alert('uploaded');
        }
      };
      new AjaxUpload('imginsert', uploadopts);
    }

    return ImageTool;

  })();

  $(function() {
    return $(document).bind('sessionState', function(user) {
      if (window.loggedIn) return window.ImageTool = new ImageTool();
    });
  });

}).call(this);
