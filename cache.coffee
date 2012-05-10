http = require 'http'
fs = require 'fs'

cache = {}

server = http.createServer (request, response) ->
  if cache['/']?
    response.writeHead 200,
      'Content-Type': 'text/plain'
    response.end cache['/']
  else
    fs.readFile 'ok.txt', 'utf8', (err, data) ->
      cache['/'] = data
      response.writeHead 200,
        'Content-Type': 'text/plain'
      response.end cache['/']

server.listen 3001

