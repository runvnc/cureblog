everyone = process.everyone
fs = require 'fs'
util = require 'util'
childproc = require 'child_process'
sh = require 'shelljs'

everyone.now.getWidgetData = (name, callback) ->
  data =
    name: name
    coffee: fs.readFileSync "components/#{name}/js/#{name}.coffee", 'utf8'
    js: fs.readFileSync "components/#{name}/js/#{name}.js", 'utf8'
    html: fs.readFileSync "components/#{name}/#{name}.html", 'utf8'
    css: fs.readFileSync "components/#{name}/css/#{name}.css", 'utf8'
  
  callback data

everyone.now.saveWidgetData = (data, callback) ->
  name = data.name
  fs.writeFileSync "components/#{name}/js/#{name}.coffee", data.coffee, 'utf8'
  childproc.exec "coffee -o components/#{name}/js -c components/#{name}/js/#{name}.coffee", (er, o, e) ->
    console.log util.inspect er
    console.log o
    console.log e
    
  fs.writeFileSync "components/#{name}/css/#{name}.css", data.css, 'utf8'
  fs.writeFileSync "components/#{name}/#{name}.html", data.html, 'utf8'
  callback()  

everyone.now.listComponents = (callback) ->
  fs.readdir 'components', (err, files) ->
    callback files 

everyone.now.copyComponent = (name, callback) ->
  n = 1
  numarr = name.match /[0-9]+$/m  
  if numarr? then n = numarr[0]+1
  newname = name + (n.toString())
  sh.mkdir '-p', "components/#{newname}"
  sh.cp '-R', "components/#{name}/*", "components/#{newname}" 
  #sh.mv '', "components/#{newname}/#{name}.coffee", "components/#{newname}/#{newname}.coffee"
  #sh.mv '', "components/#{newname}/#{name}.html", "components/#{newname}/#{newname}.html"
  #sh.mv '', "components/#{newname}/css/#{name}.css", "components/#{newname}/css/#{newname}.css"
  #sh.mv '', "components/#{newname}/js/#{name}.coffee", "components/#{newname}/js/#{newname}.coffee"
  #childproc.exec "coffee -o components/#{newname}/js -c components/#{newname}/js/#{newname}.coffee", (er, o, e) ->
  #  callback()  
  #add to loadorder 
 
