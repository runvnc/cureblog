(function() {
  var cwd, getlink, listFiles, showFiles, sortem;

  cwd = '.';

  sortem = function(files) {
    files.sort(function(a, b) {
      if (a.isDirectory) {
        return -1;
      } else {
        return a.name - b.name;
      }
    });
    return files;
  };

  showFiles = function(files) {
    var classnm, file, listing, str, _i, _len;
    str = '<li class=\"fmupdir\">..</li>';
    sortem(files);
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      console.log(file);
      listing = file.name;
      classnm = "fmfile";
      if (file.isDirectory) {
        listing += '/';
        classnm = "fmdir";
      }
      str += "<li class=\"" + classnm + "\">" + listing + "</li>";
    }
    $('#fsroot').html(str);
    $('.fmdir').click(function() {
      console.log('you clicked fmdir');
      if (cwd === '.') cwd = './';
      cwd += $(this).text();
      console.log('new dir is ' + cwd);
      return listFiles();
    });
    return $('.fmupdir').click(function() {
      var d, dirs, newdirs, _j, _len2;
      dirs = cwd.split('/');
      newdirs = [];
      for (_j = 0, _len2 = dirs.length; _j < _len2; _j++) {
        d = dirs[_j];
        if (d !== '') {
          newdirs.push(d);
        } else {
          console.log('d is 3' + d + '3');
        }
      }
      newdirs.splice(newdirs.length - 1, 1);
      cwd = newdirs.join('/');
      cwd = cwd + '/';
      return listFiles();
    });
  };

  listFiles = function() {
    return now.listFiles(cwd, function(files) {
      console.log('listfiles returned');
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
        width: 600,
        height: 495
      });
      $('#upframe').show();
      return listFiles();
    });
    $('#refreshdir').click(listFiles);
    return $('#getlink').click(getlink);
  });

}).call(this);
