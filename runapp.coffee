process.on 'uncaughtException', (e) ->
  console.log e

fs = require 'fs'

fs.writeFile 'mypid', process.pid.toString(), 'utf8'

applib = require './applib'
process.applib = applib
applib.startup 'loadorder'


