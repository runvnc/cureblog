everyone = process.everyone
fs = require 'fs'
util = require 'util'
childproc = require 'child_process'
sh = require 'shelljs'

everyone.now.getWidgetData = (name, callback) ->
  try
    data =
      name: name
      browser: fs.readFileSync "components/#{name}/js/#{name}.coffee", 'utf8'
      nodejs: fs.readFileSync "components/#{name}/#{name}.coffee", 'utf8'
      js: fs.readFileSync "components/#{name}/js/#{name}.js", 'utf8'
      html: fs.readFileSync "components/#{name}/#{name}.html", 'utf8'
      css: fs.readFileSync "components/#{name}/css/#{name}.css", 'utf8'
    
    callback data
  catch e
    console.log e
    callback null, e

everyone.now.saveWidgetData = (data, callback) ->
  name = data.name
  fs.writeFileSync "components/#{name}/js/#{name}.coffee", data.browser, 'utf8'
  fs.writeFileSync "components/#{name}/#{name}.coffee", data.nodejs, 'utf8'
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

everyone.now.deleteComponent = (name, callback) ->
  try
    sh.rm '-Rf', "components/#{name}"
    callback true
  catch e
    callback false, err
    
everyone.now.copyComponent = (name, callback) ->
  n = 1
  numarr = name.match /[0-9]+$/m  
  if numarr? then n = numarr[0]+1
  newname = name + (n.toString())
  sh.mkdir '-p', "components/#{newname}"
  sh.cp '-R', "components/#{name}/*", "components/#{newname}" 
  fs.rename "components/#{newname}/#{name}.coffee", "components/#{newname}/#{newname}.coffee"
  fs.rename "components/#{newname}/#{name}.html", "components/#{newname}/#{newname}.html"
  fs.rename "components/#{newname}/css/#{name}.css", "components/#{newname}/css/#{newname}.css"
  fs.rename "components/#{newname}/js/#{name}.coffee", "components/#{newname}/js/#{newname}.coffee", (err) ->
    if not err?
      childproc.exec "coffee -o components/#{newname}/js -c components/#{newname}/js/#{newname}.coffee", (er, o, e) ->
        callback true
    else
      callback false, err
  #add to loadorder 

