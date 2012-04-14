(function() {
  var MongolianDeadBeef, ObjectId, app, db, everyone, express, fs, nowjs, server, util;

  express = require('express');

  express = require('express');

  MongolianDeadBeef = require('mongolian');

  server = new MongolianDeadBeef;

  nowjs = require('now');

  fs = require('fs');

  util = require('util');

  ObjectId = MongolianDeadBeef.ObjectId;

  ObjectId.prototype.toJSON = function() {
    return this.toString();
  };

  db = server.db('app');

  app = express.createServer();

  app.use(express.cookieParser());

  app.use(express.session({
    secret: 'burrito13'
  }));

  app.use(express.static(__dirname + '/public'));

  app.set('view options', {
    layout: false
  });

  app.register('.html', require('jade'));

  app.get('/', function(req, res) {
    return res.render('index.html');
  });

  nowjs = require('now');

  everyone = nowjs.initialize(app);

  everyone.now.dbinsert = function(col, data) {
    return db.collection(col).insert(data);
  };

  everyone.now.dbrestore = function(criteria) {
    return db.collection('backups').findOne({
      criteria: criteria
    }, function(err, backups) {
      var backup, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = backups.length; _i < _len; _i++) {
        backup = backups[_i];
        _results.push(console.log(backup));
      }
      return _results;
    });
  };

  everyone.now.dbupdate = function(col, criteria, data) {
    return db.collection(col).find(criteria).toArray(function(err, doc) {
      if (err) console.log(err);
      db.collection('backups').insert({
        status: 'saved',
        col: col,
        modified: new Date(),
        criteria: criteria,
        data: doc
      });
      return db.collection(col).update(criteria, data);
    });
  };

  everyone.now.dbfind = function(col, callback) {
    return db.collection(col).find().toArray(function(err, data) {
      return callback(data);
    });
  };

  app.listen(3000);

}).call(this);
