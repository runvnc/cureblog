(function() {
  var cwd, deleteSelected, getlink, listFiles, shiftSel, showFiles, sortem;

  cwd = '.';

  sortem = function(files) {
    files.sort(function(a, b) {
      if (a.isDirectory) {
        return -1;
      } else {
        if (a.name < b.name) {
          return -1;
        } else if (a.name === b.name) {
          return 0;
        } else {
          return 1;
        }
      }
    });
    return files;
  };

  deleteSelected = function() {
    var todel;
    todel = [];
    $('.fmselected').each(function() {
      return todel.push($(this).text());
    });
    if (confirm("Delete " + todel.length + " files/directories??")) {
      return now.deleteFiles(todel, cwd, function() {
        return listFiles();
      });
    }
  };

  shiftSel = function(e, th) {
    var clickedIndex, i, max, min, selIndex, _results;
    selIndex = $('.fmselected').index();
    clickedIndex = $(th).index();
    min = Math.min(selIndex, clickedIndex);
    max = Math.max(selIndex, clickedIndex);
    $('.fmselected').each(function() {
      min = Math.min(min, $(this).index());
      return max = Math.max(max, $(this).index());
    });
    $('.fmitem').removeClass('fmselected');
    _results = [];
    for (i = min; min <= max ? i <= max : i >= max; min <= max ? i++ : i--) {
      _results.push($("#fsroot li:eq(" + i + ")").addClass('fmselected'));
    }
    return _results;
  };

  showFiles = function(files) {
    var classnm, file, listing, str, _i, _len;
    console.log('**** FileManager showFiles ****');
    str = '<li class=\"fmitem fmupdir\">..</li>';
    sortem(files);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      listing = file.name;
      classnm = "fmfile";
      if (file.isDirectory) {
        listing += '/';
        classnm = "fmdir";
      }
      str += "<li class=\"fmitem " + classnm + "\">" + listing + "</li>";
    }
    $('#fsroot').html(str);
    $('.fmdir').dblclick(function() {
      if (cwd === '.') cwd = './';
      cwd += $(this).text();
      return listFiles();
    });
    $('.fmupdir').dblclick(function() {
      var d, dirs, newdirs, _j, _len2;
      dirs = cwd.split('/');
      newdirs = [];
      for (_j = 0, _len2 = dirs.length; _j < _len2; _j++) {
        d = dirs[_j];
        if (d !== '') newdirs.push(d);
      }
      newdirs.splice(newdirs.length - 1, 1);
      cwd = newdirs.join('/');
      cwd = cwd + '/';
      return listFiles();
    });
    $('.fmitem').click(function(e) {
      if (e.ctrlKey) {
        return $(this).addClass('fmselected');
      } else if (e.shiftKey) {
        return shiftSel(e, this);
      } else {
        $('.fmitem').removeClass('fmselected');
        return $(this).addClass('fmselected');
      }
    });
    return $('#deletesel').click(deleteSelected);
  };

  listFiles = function() {
    return now.listFiles(cwd, function(files) {
      return showFiles(files);
    });
  };

  getlink = function() {
    var url;
    url = $('#loadfromurl').val();
    return now.loadAndUncompress(url, cwd, function(err) {
      $('#loadfromurl').val('');
      return listFiles();
    });
  };

  window.doneUploading = function() {
    $('#fileman iframe').attr('src', '/dyn/upframe');
    return listFiles();
  };

  $(function() {
    $('#objs').prepend('<button id=\"openfm\" class=\"white button\">File Manager</button>');
    $('#openfm').click(function() {
      $('#fileman').dialog({
        title: 'File Manager',
        width: 870,
        height: $(window).height() * .9
      });
      $('#upframe').show();
      $('#fileswin').height($(window).height() * .75);
      return listFiles();
    });
    $('#refreshdir').click(listFiles);
    return $('#getlink').click(getlink);
  });

}).call(this);
