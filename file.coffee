http = require 'http'
fs = require 'fs'
 
server = http.createServer (request, response) ->
  fs.readFile 'ok.txt', 'utf8', (err, data) ->
    response.writeHead 200,
      'Content-Type': 'text/plain'
    response.end data

server.listen 3001

