process.on 'uncaughtException', (e) ->
  console.log e

applib = require './applib'
process.applib = applib
applib.startup 'loadorder'


