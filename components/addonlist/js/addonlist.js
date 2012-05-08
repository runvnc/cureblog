(function() {
  var allplugins, complete, highlightSel, plugitem, selectedplugin;

  allplugins = [];

  plugitem = -1;

  selectedplugin = '';

  complete = function(search, strings) {
    var str, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = strings.length; _i < _len; _i++) {
      str = strings[_i];
      if (str.indexOf(search) === 0) _results.push(str);
    }
    return _results;
  };

  highlightSel = function() {
    console.log('highlighting ' + plugitem);
    $('#matches li').css('backgroundColor', '#fff');
    selectedplugin = $('#matches').eq(plugitem).text();
    return $('#matches').eq(plugitem).css('backgroundColor', '#EEDAF5');
  };

  $(function() {
    $('#objs').prepend('<button id="plugins" class="button white">Plugins..</button>');
    $('#plugins').click(function() {
      $('#pluginauto').dialog({
        title: 'Add plugins',
        position: 'top',
        height: $(window).height() * .93,
        width: $(window).width() * .7
      });
      $('#inp').keyup(function(e) {
        var list, matches, str, _i, _len;
        if ($('#inp').val() === '') {
          matches = [];
        } else {
          matches = complete($('#inp').val().toLowerCase(), allplugins);
        }
        console.log('matches:');
        console.log(matches);
        list = '';
        for (_i = 0, _len = matches.length; _i < _len; _i++) {
          str = matches[_i];
          list += '<li>' + str + '</li>';
        }
        $('#matches').html(list);
        if (matches.length === 1) {
          plugitem = 1;
          return setTimeout(highlightSel, 100);
        }
      });
      return $('#inp').keydown(function(e) {
        switch (e.which) {
          case 40:
            console.log('hi there plugitem is ' + plugitem);
            if (plugitem < allplugins.length) {
              plugitem++;
              return highlightSel();
            }
            break;
          case 38:
            if (plugitem > -1) {
              plugitem--;
              return highlightSel();
            }
            break;
          case 13:
            return noty({
              text: 'Installing plugin ' + selectedplugin,
              type: 'information'
            });
        }
      });
    });
    return now.ready(function() {
      return now.getPluginIndex(function(list) {
        var key, val, _results;
        _results = [];
        for (key in list) {
          val = list[key];
          _results.push(allplugins.push(val.name + '  ' + val.description));
        }
        return _results;
      });
    });
  });

}).call(this);
