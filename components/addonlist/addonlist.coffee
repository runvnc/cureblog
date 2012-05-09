everyone = process.everyone
fs = require 'fs'
childproc = require 'child_process'

allplugins = {}

fs.readFile 'oicplugins/all.json', 'utf8', (err, data) ->
  allplugins = JSON.parse data
  
everyone.now.getPluginIndex = (callback) ->
  callback allplugins
  
everyone.now.installPlugin = (name, callback) ->
  ls = childproc.spawn 'du', ['-h']

  ls.stdout.on 'data', (data) ->
    console.log '' + data
    callback '' + data
  
  ls.stderr.on 'data', (data) ->
    console.log 'stderr: ' + data
    callback '' + data
  
  ls.on 'exit', (code) ->
    console.log 'child process exited with code ' + code
    callback 'child process exited with code ' + code
    
  
  #childproc.exec "./installplugin #{name}", (er, o, e) ->
    