express = require 'express'
config = require './config'
childproc = require 'child_process'
fs = require 'fs'


app = express.createServer()


app.get '/', (req, res) ->
  pid = fs.readFileSync 'mypid', 'utf8'
  childproc.exec './restart ' + pid

app.listen config.restarterport


