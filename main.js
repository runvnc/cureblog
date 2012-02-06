(function() {
  var loadwidget, loadwidgets;

  loadwidget = function(data) {
    $('#widgets').append(data.html);
    return $('head').append("<script>" + data.code + "</script>");
  };

  loadwidgets = function() {
    return now.dbfind('widgets', function(widgets) {
      var widget, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = widgets.length; _i < _len; _i++) {
        widget = widgets[_i];
        _results.push(loadwidget(widget));
      }
      return _results;
    });
  };

  $(function() {
    return now.ready(function() {
      return loadwidgets();
    });
  });

}).call(this);
