(function() {
  var allplugins, complete, highlightSel, matches, plugitem, selectedplugin;

  allplugins = [];

  plugitem = 0;

  selectedplugin = '';

  complete = function(search, strings) {
    var str, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = strings.length; _i < _len; _i++) {
      str = strings[_i];
      if (str.indexOf(search) >= 0) _results.push(str);
    }
    return _results;
  };

  highlightSel = function() {
    $('#matches li').css('backgroundColor', '#fff');
    selectedplugin = $('#matches li').eq(plugitem).text();
    return $('#matches li').eq(plugitem).css('backgroundColor', '#EEDAF5');
  };

  matches = [];

  $(function() {
    $('#objs').prepend('<button id="plugins" class="button white"><img src="images/plugins.png"/>Plugins..</button>');
    $('#plugins').click(function() {
      $('#pluginauto').dialog({
        title: 'Add plugins',
        position: 'top',
        height: $(window).height() * .93,
        width: $(window).width() * .7
      });
      return $('#inp').keyup(function(e) {
        var list, str, toks, _i, _len;
        switch (e.which) {
          case 40:
            if (plugitem < matches.length - 1) {
              plugitem++;
              console.log('plugitem is now ' + plugitem);
              return highlightSel();
            } else {
              return console.log('40 no plugitem is ' + plugitem + ' matches is ' + matches.length);
            }
            break;
          case 38:
            if (plugitem > 0) {
              plugitem--;
              return highlightSel();
            } else {
              return console.log('38 no plugitem is ' + plugitem + ' matches is ' + matches.length);
            }
            break;
          case 13:
            toks = selectedplugin.split(' ');
            selectedplugin = toks[0];
            noty({
              text: 'Installing plugin ' + selectedplugin,
              type: 'information'
            });
            return now.installPlugin(selectedplugin, function(msg) {
              $('#installmsg').append(msg);
              return $('#installmsg')[0].scrollTop = $('#installmsg')[0].scrollHeight;
            });
          default:
            if ($('#inp').val() === '') {
              matches = [];
            } else {
              matches = complete($('#inp').val().toLowerCase(), allplugins);
            }
            list = '';
            for (_i = 0, _len = matches.length; _i < _len; _i++) {
              str = matches[_i];
              list += '<li>' + str + '</li>';
            }
            plugitem = -1;
            $('#matches').html(list);
            if (matches.length === 1) {
              plugitem = 0;
              return setTimeout(highlightSel, 100);
            }
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
