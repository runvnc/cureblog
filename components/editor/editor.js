(function() {
  var childproc, everyone, fs, sh, util,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  everyone = process.everyone;

  fs = require('fs');

  util = require('util');

  childproc = require('child_process');

  sh = require('shelljs');

  everyone.now.getWidgetData = function(name, callback) {
    var data;
    try {
      data = {
        name: name,
        browser: fs.readFileSync("components/" + name + "/js/" + name + ".coffee", 'utf8'),
        nodejs: fs.readFileSync("components/" + name + "/" + name + ".coffee", 'utf8'),
        js: fs.readFileSync("components/" + name + "/js/" + name + ".js", 'utf8'),
        html: fs.readFileSync("components/" + name + "/" + name + ".html", 'utf8'),
        css: fs.readFileSync("components/" + name + "/css/" + name + ".css", 'utf8')
      };
      return callback(data);
    } catch (e) {
      console.log(e);
      return callback(null, e);
    }
  };

  everyone.now.saveWidgetData = function(data, callback) {
    var name;
    name = data.name;
    fs.writeFileSync("components/" + name + "/js/" + name + ".coffee", data.browser, 'utf8');
    fs.writeFileSync("components/" + name + "/" + name + ".coffee", data.nodejs, 'utf8');
    childproc.exec("coffee -o components/" + name + "/js -c components/" + name + "/js/" + name + ".coffee", function(er, o, e) {
      console.log(util.inspect(er));
      console.log(o);
      return console.log(e);
    });
    fs.writeFileSync("components/" + name + "/css/" + name + ".css", data.css, 'utf8');
    fs.writeFileSync("components/" + name + "/" + name + ".html", data.html, 'utf8');
    return callback();
  };

  everyone.now.listComponents = function(callback) {
    var active;
    active = process.listfile('loadorder');
    return fs.readdir('components', function(err, dirs) {
      var comp, dir, ret, _i, _j, _len, _len2;
      ret = [];
      for (_i = 0, _len = active.length; _i < _len; _i++) {
        comp = active[_i];
        ret.push({
          name: comp,
          active: true
        });
      }
      for (_j = 0, _len2 = dirs.length; _j < _len2; _j++) {
        dir = dirs[_j];
        if (!(__indexOf.call(active, dir) >= 0)) {
          ret.push({
            name: dir,
            active: (__indexOf.call(active, dir) >= 0)
          });
        }
      }
      return callback(ret);
    });
  };

  everyone.now.setActiveComponents = function(list, callback) {
    var str;
    str = list.join('\n');
    return fs.writeFile('loadorder', str, 'utf8', function(err) {
      return callback(err);
    });
  };

  everyone.now.deleteComponent = function(name, callback) {
    try {
      sh.rm('-Rf', "components/" + name);
      return callback(true);
    } catch (e) {
      return callback(false, err);
    }
  };

  everyone.now.copyComponent = function(name, callback) {
    var n, newname, numarr, scripts, styles;
    n = 1;
    numarr = name.match(/[0-9]+$/m);
    if (numarr != null) n = numarr[0] + 1;
    newname = name + (n.toString());
    sh.mkdir('-p', "components/" + newname);
    sh.cp('-R', "components/" + name + "/*", "components/" + newname);
    fs.rename("components/" + newname + "/" + name + ".coffee", "components/" + newname + "/" + newname + ".coffee");
    fs.rename("components/" + newname + "/" + name + ".html", "components/" + newname + "/" + newname + ".html");
    fs.rename("components/" + newname + "/css/" + name + ".css", "components/" + newname + "/css/" + newname + ".css");
    scripts = fs.readFile("components/" + newname + "/scripts", 'utf8', function(err, data) {
      scripts = data.replace("" + name + ".js", "" + newname + ".js");
      return fs.writeFile("components/" + newname + "/scripts", scripts, 'utf8');
    });
    styles = fs.readFile("components/" + newname + "/styles", 'utf8', function(err, data) {
      styles = data.replace("" + name + ".css", "" + newname + ".css");
      return fs.writeFile("components/" + newname + "/styles", styles, 'utf8');
    });
    return fs.rename("components/" + newname + "/js/" + name + ".coffee", "components/" + newname + "/js/" + newname + ".coffee", function(err) {
      if (!(err != null)) {
        return childproc.exec("coffee -o components/" + newname + "/js -c components/" + newname + "/js/" + newname + ".coffee", function(er, o, e) {
          return callback(true);
        });
      } else {
        return callback(false, err);
      }
    });
  };

  everyone.now.renameComponent = function(name, newname, callback) {
    var scripts, styles;
    console.log('received rename for ' + name + ' to ' + newname);
    fs.rename("components/" + name + "/" + name + ".coffee", "components/" + name + "/" + newname + ".coffee");
    fs.rename("components/" + name + "/" + name + ".html", "components/" + name + "/" + newname + ".html");
    fs.rename("components/" + name + "/css/" + name + ".css", "components/" + name + "/css/" + newname + ".css");
    scripts = fs.readFile("components/" + name + "/scripts", 'utf8', function(err, data) {
      scripts = data.replace("" + name + ".js", "" + newname + ".js");
      return fs.writeFile("components/" + name + "/scripts", scripts, 'utf8');
    });
    styles = fs.readFile("components/" + name + "/styles", 'utf8', function(err, data) {
      styles = data.replace("" + name + ".css", "" + newname + ".css");
      return fs.writeFile("components/" + name + "/styles", styles, 'utf8');
    });
    return fs.rename("components/" + name + "/js/" + name + ".coffee", "components/" + name + "/js/" + newname + ".coffee", function(err) {
      if (!(err != null)) {
        return childproc.exec("coffee -o components/" + name + "/js -c components/" + name + "/js/" + newname + ".coffee", function(er, o, e) {
          fs.rename("components/" + name, "components/" + newname);
          return callback(true);
        });
      } else {
        return callback(false, err);
      }
    });
  };

}).call(this);
