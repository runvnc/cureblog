childprocess = require 'child_process'
childprocess.exec 'ethercalc', (er, o, e) ->
  console.log 'tried to start ethercalc'
  console.log er
  console.log o
  console.log e
