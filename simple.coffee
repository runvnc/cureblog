http = require 'http'
fs = require 'fs'
 
server = http.createServer (request, response) ->
  body = 'ok'
  response.writeHead 200,
    'Content-Type': 'text/plain'
  response.end 'ok'

server.listen 3001

