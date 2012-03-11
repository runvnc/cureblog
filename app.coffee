express = require 'express'
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
app.use express.static(__dirname + '/public')

files = []

loadfiles = (files) ->
  for file in files
    do (file) ->
      files[file] = fs.readFileSync(file).toString()
      app.get "/#{file}", (req, res) ->
        res.end files[file]

files = [
  'style.css'
  'main.js'
  'index.html'
  'index.js'
  'handlebars.js'
  'jquery.ui.position.js'
  'jquery.contextMenu.css'
  'jquery.contextMenu.js'
  'jquery.min.js'
  'jquery-ui-1.8.18.custom.min.js'
  'jquery-ui.min.js'
]

loadfiles files

app.get '/', (req, res) ->
  res.end files['index.html']
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


