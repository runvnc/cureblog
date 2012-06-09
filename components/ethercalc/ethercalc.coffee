childprocess = require 'child_process'

console.log 'about to try running ethercalc'

childprocess.exec 'components/ethercalc/start', (er, o, e) ->
  console.log 'tried to start ethercalc'
  console.log er
  console.log o
  console.log e
  