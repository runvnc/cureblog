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
    data = data + ''
    if data.indexOf('__SUCCESS__') >= 0
      donecallback true
    else
      datacallback data
  
  install.stderr.on 'data', (data) ->
    datacallback '' + data
  
  install.on 'exit', (code) ->
    console.log 'exited'
    console.log 'code is ' + code
    if code is 0
      donecallback true
    else
      donecallback false
      
  
    
