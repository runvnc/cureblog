(function() {
  var allplugins, complete, currentlyinstalling, highlightSel, install, installdone, installmsg, listplugins, matches, plugitem, selectedplugin, updateActive;

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

  currentlyinstalling = '';

  installmsg = function(msg) {
    if (msg.indexOf('__SUCCESS__') >= 0) {
      return installdone(true);
    } else {
      $('#installmsg').append(msg);
      return $('#installmsg')[0].scrollTop = $('#installmsg')[0].scrollHeight;
    }
  };

  listplugins = function() {
    return now.listComponents(function(components) {
      var check, checked, component, str, _i, _len;
      str = '';
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        checked = '';
        if (component.active) checked = 'checked="checked"';
        check = '<input type="checkbox" ' + checked + '/>';
        str += "<li>" + check + "&nbsp;<span class=\"compname\">" + component.name + "</span></li>";
      }
      return $('#pluginlist').html(str);
    });
  };

  updateActive = function() {
    var active;
    active = [];
    $('#pluginlist li').each(function() {
      if ($(this).find('input').is(':checked')) {
        return active.push($(this).find('.compname').text());
      }
    });
    now.setActiveComponents(active);
    $('#plugindonemsg').html('Your edits have been saved.  Reloading application..');
    now.restartServer();
    return setTimeout((function() {
      return window.location.reload();
    }), 2000);
  };

  installdone = function(success) {
    var msg, type;
    if (success) {
      type = 'success';
      msg = currentlyinstalling + ' finished installing.';
      noty({
        text: msg,
        type: type,
        layout: 'topRight'
      });
      $('#installmsg').hide();
      $('#pluginlist').show();
      $('#plugindonemsg').html('Installation successful.  Click Save Changes to restart.');
      $('#plugindonemsg').css('backgroundColor', 'white');
      return listplugins();
    } else {
      type = 'error';
      msg = 'Installation of plugin ' + currentlyinstalling + ' failed.  See log';
      return noty({
        text: msg,
        type: type,
        layout: 'topRight'
      });
    }
  };

  install = function(plugin) {
    currentlyinstalling = plugin;
    noty({
      text: 'Installing plugin ' + plugin,
      type: 'information',
      layout: 'topRight'
    });
    $('#installmsg').show();
    $('#pluginlist').hide();
    return now.installPlugin(plugin, installmsg, installdone);
  };

  $(function() {
    $('#advobjs').prepend('<button id="plugins" class="button white"><img src="images/plugins.png"/>Plugins..</button>');
    $('#updateactive').click(updateActive);
    $('#plugins').click(function() {
      $('#pluginauto').dialog({
        title: 'Add plugins',
        position: 'top',
        height: $(window).height() * .93,
        width: $(window).width() * .7
      });
      $('#installmsg').hide();
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
            return install(selectedplugin);
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
              setTimeout(highlightSel, 100);
            }
            return $('#matches li').click(function() {
              toks = $(this).text().split(' ');
              selectedplugin = toks[0];
              return install(selectedplugin);
            });
        }
      });
    });
    return now.ready(function() {
      listplugins();
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
