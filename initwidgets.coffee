MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
fs = require 'fs'

db = server.db 'app'

db.collection('widgets').remove()

db.collection('widgets').insert
  name: 'editor'
  code: fs.readFileSync('editor.js').toString()
  html: fs.readFileSync('editor.html').toString()
