(function() {
  var cwd, listFiles, showFiles, sortem;

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
    str = '';
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
    return $('.fmdir').click(function() {
      if (cwd === '.') cwd = './';
      cwd += $(this).text();
      console.log('new dir is ' + cwd);
      return listFiles();
    });
  };

  listFiles = function() {
    console.log('calling listfiles');
    return now.listFiles(cwd, function(files) {
      console.log('listfiles returned');
      return showFiles(files);
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
        height: 450
      });
      return listFiles();
    });
    return $('#refreshdir').click(listFiles);
  });

}).call(this);
