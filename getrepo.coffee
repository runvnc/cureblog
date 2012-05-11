fs = require 'fs'

if process.argv.length isnt 3
  console.log 'Specify plugin name. Argv length should be 3.'
  process.exit 1

else
  name = process.argv[2]
  fs.readFile 'oicplugins/all.json', 'utf8', (err, data) ->
    if err?
      console.log "Error reading plugin list: #{err.message}"
      process.exit 1
    else
      list = JSON.parse data
      plugin = list[name]
      if not plugin?
        console.log "Plugin not found."
        process.exit 1
      else
        console.log "git@github.com:#{plugin.user}/#{plugin.repo}.git"
        process.exit 0
 
