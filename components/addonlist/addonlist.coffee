everyone = process.everyone
fs = require 'fs'

allplugins = {}

fs.readFile 'oicplugins/all.json', 'utf8', (err, data) ->
  allplugins = JSON.parse data
  
everyone.now.getPluginIndex = (callback) ->
  callback allplugins