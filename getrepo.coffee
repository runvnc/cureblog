fs = require 'fs'

if process.argv.length isnt 3
  console.log 'Specify plugin name. Argv length should be 3.'
  process.exit 1

plugin = process.argv[2]

console.log "Searching for #{plugin}.."

###
else
  fs.readFile argv[1]
###
