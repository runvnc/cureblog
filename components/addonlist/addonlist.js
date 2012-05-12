(function() {
  var allplugins, childproc, everyone, fs;

  everyone = process.everyone;

  fs = require('fs');

  childproc = require('child_process');

  allplugins = {};

  fs.readFile('oicplugins/all.json', 'utf8', function(err, data) {
    return allplugins = JSON.parse(data);
  });

  everyone.now.getPluginIndex = function(callback) {
    return callback(allplugins);
  };

  everyone.now.installPlugin = function(name, datacallback, donecallback) {
    var install;
    install = childproc.spawn('./installplugin', [name]);
    install.stdout.on('data', function(data) {
      console.log('' + data);
      return datacallback('' + data);
    });
    install.stderr.on('data', function(data) {
      '' + data;
      return datacallback('' + data);
    });
    return install.on('exit', function(code) {
      if (code === 0) {
        return datacallback(true);
      } else {
        return datacallback(false);
      }
    });
  };

}).call(this);
