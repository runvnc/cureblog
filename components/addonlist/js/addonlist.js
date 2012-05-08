(function() {
  var complete, strings;

  strings = [];

  complete = function(search, strings) {
    var str, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = strings.length; _i < _len; _i++) {
      str = strings[_i];
      if (str.indexOf(search) === 0) _results.push(str);
    }
    return _results;
  };

  $('#inp').keyup(function(e) {
    var list, matches, str, _i, _len;
    if ($('#inp').val()('')) {
      matches = [];
    } else {
      matches = complete($('#inp').val().toLowerCase(), strings);
    }
    list = '';
    for (_i = 0, _len = matches.length; _i < _len; _i++) {
      str = matches[_i];
      list += '<li>' + str + '</li>';
    }
    return $('#matches').html(list);
  });

  $(function() {
    $('#objs').prepend('<button id="plugins" class="button white">Plugins..</button>');
    $('#plugins').click(function() {
      return $('#pluginauto').dialog({
        title: 'Add plugins',
        position: 'top',
        height: $(window).height() * .93,
        width: $(window).width() * .7
      });
    });
    return now.ready(function() {
      return now.getPluginIndex(function(list) {
        var plugin, str, _i, _len, _results;
        str = '';
        _results = [];
        for (_i = 0, _len = list.length; _i < _len; _i++) {
          plugin = list[_i];
          str += '<li id="pl_"' + plugin.name + '>';
          str += plugin.name + '&nbsp;&nbsp;';
          str += plugin.description;
          _results.push(str += '</li>');
        }
        return _results;
      });
    });
  });

}).call(this);
