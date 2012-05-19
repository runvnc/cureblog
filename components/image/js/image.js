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
        name: 'imageupload',
        onComplete: function(file, response) {
          var style;
          console.log(file);
          style = 'style="position: absolute; top: 100px; left: 100px;"';
          return window.delay(150, function() {
            $('#page').append("<img class=\"oicimage\" src=\"images/" + file + "\"/>");
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
      if (window.loggedIn) return window.ImageTool = new ImageTool();
    });
  });

}).call(this);
