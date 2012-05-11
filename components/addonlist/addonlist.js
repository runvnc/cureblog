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

  everyone.now.installPlugin = function(name, callback) {
    var ls;
    ls = childproc.spawn('du', ['-h']);
    ls.stdout.on('data', function(data) {
      console.log('' + data);
      return callback('' + data);
    });
    ls.stderr.on('data', function(data) {
      console.log('stderr: ' + data);
      return callback('' + data);
    });
    return ls.on('exit', function(code) {
      console.log('child process exited with code ' + code);
      return callback('child process exited with code ' + code);
    });
  };

}).call(this);
