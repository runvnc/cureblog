MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
fs = require 'fs'

db = server.db 'app'

db.collection('widgets').remove()

dirs = fs.readdirSync 'widgets'

for dir in dirs
  p = 'widgets/' + dir + '/' + dir
  db.collection('widgets').insert
    name: dir
    code: fs.readFileSync(p + '.js').toString()
    html: fs.readFileSync(p + '.html').toString()
    css:  fs.readFileSync(p + '.css').toString()
