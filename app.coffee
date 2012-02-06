express = require 'express'
MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
nowjs = require 'now'
fs = require 'fs'
util = require 'util'

db = server.db 'app'

app = express.createServer()
app.use express.cookieParser()
app.use express.session { secret: 'burrito13' }

files = []

loadfiles = (files) ->
  for file in files
    do (file) ->
      files[file] = fs.readFileSync(file).toString()
      app.get "/#{file}", (req, res) ->
        res.end files[file]

files = [
  'main.js'
  'index.html'
  'jquery.min.js'
  'jquery-ui.min.js'
]

loadfiles files

app.get '/', (req, res) ->
  res.end files['index.html']
nowjs = require 'now'
everyone = nowjs.initialize app

everyone.now.dbinsert = (col, data) ->
  db.collection(col).insert data

everyone.now.dbfind = (col, callback) ->
  db.collection(col).find().toArray (err, data) ->
    callback data

app.listen 3000


###
everyone.now.dbinsert = (name, data) ->
  console.log "data is"
  console.log data
  db.collection(name).insert data           
  console.log "tried to call whatever"
###


