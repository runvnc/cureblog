(function() {

  $(function() {
    $('#objs').prepend('<button id=\"openfm\" class=\"white button\">File Manager</button>');
    return $('#openfm').click(function() {
      return $('#uploadform').dialog();
    });
  });

}).call(this);
