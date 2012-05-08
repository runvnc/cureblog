everyone = process.everyone
fs = require 'fs'
childproc = require 'child_process'

allplugins = {}

fs.readFile 'oicplugins/all.json', 'utf8', (err, data) ->
  allplugins = JSON.parse data
  
everyone.now.getPluginIndex = (callback) ->
  callback allplugins
  
everyone.now.installPlugin = (name, callback) ->
  childproc.exec "./installplugin #{name}", (er, o, e) ->
    