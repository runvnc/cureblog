express = require 'express'
fs = require 'fs'
app = express.createServer()
process.app = app

app.use express.static("public")

app.get '/', (request, response) ->
  index = fs.readFileSync 'public/index.html', 'utf8'
  response.send index

port = 3000
app.listen port, ->
  console.log "Listening on " + port

