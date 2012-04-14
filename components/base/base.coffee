express = require 'express'
jade = require 'jade'
MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
nowjs = require 'now'
fs = require 'fs'
util = require 'util'

ObjectId = MongolianDeadBeef.ObjectId
ObjectId.prototype.toJSON = ->
  return @toString()

db = server.db 'app'

app = express.createServer()
app.use express.cookieParser()
app.use express.session { secret: 'burrito13' }
app.use express.static("public")

app.set 'view options', { layout: false }
app.register('.html', require('jade'));

app.get '/', (request, response) ->
  index = fs.readFileSync 'public/index.html', 'utf8'
  response.send index

nowjs = require 'now'
everyone = nowjs.initialize app

everyone.now.dbinsert = (col, data) ->
  db.collection(col).insert data

everyone.now.dbrestore = (criteria) ->
  db.collection('backups').findOne criteria: criteria, (err, backups) ->
    for backup in backups
      console.log backup

everyone.now.dbupdate = (col, criteria, data) ->
  db.collection(col).find(criteria).toArray (err, doc) ->
    if (err)
      console.log err
    db.collection('backups').insert
      status: 'saved'
      col: col
      modified: new Date()
      criteria: criteria
      data : doc
    db.collection(col).update criteria, data

everyone.now.dbfind = (col, callback) ->
  db.collection(col).find().toArray (err, data) ->
    callback data

app.listen 3000


