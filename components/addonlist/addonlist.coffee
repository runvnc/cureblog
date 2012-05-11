everyone = process.everyone
fs = require 'fs'
childproc = require 'child_process'

allplugins = {}

fs.readFile 'oicplugins/all.json', 'utf8', (err, data) ->
  allplugins = JSON.parse data
  
everyone.now.getPluginIndex = (callback) ->
  callback allplugins
  
everyone.now.installPlugin = (name, datacallback, donecallback) ->
  install = childproc.spawn './installplugin', [name]

  install.stdout.on 'data', (data) ->
    console.log '' + data
    datacallback '' + data
  
  install.stderr.on 'data', (data) ->
    '' + data
    datacallback '' + data
  
  install.on 'exit', (code) ->    
    if code is 0
      datacallback true
    else
      datacallback false
      
  
    