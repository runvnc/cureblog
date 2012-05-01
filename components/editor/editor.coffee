everyone = process.everyone
fs = require 'fs'
util = require 'util'
childproc = require 'child_process'
sh = require 'shelljs'
GitHubApi = require "github"
request = require 'request'


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
  active = process.listfile 'loadorder'
  fs.readdir 'components', (err, dirs) ->
    ret = []
    for comp in active
      ret.push
        name: comp
        active: true
    for dir in dirs
      if not (dir in active)
        ret.push
          name: dir
          active: (dir in active)
    callback ret

everyone.now.setActiveComponents = (list, callback) ->
  str = list.join '\n'
  fs.writeFile 'loadorder', str, 'utf8', (err) ->
    callback err
    
    
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
  scripts = fs.readFile "components/#{newname}/scripts", 'utf8', (err, data) ->
    scripts = data.replace "#{name}.js", "#{newname}.js"    
    fs.writeFile "components/#{newname}/scripts", scripts, 'utf8'
  styles = fs.readFile "components/#{newname}/styles", 'utf8', (err, data) ->
    styles = data.replace "#{name}.css", "#{newname}.css"    
    fs.writeFile "components/#{newname}/styles", styles, 'utf8'
    
  fs.rename "components/#{newname}/js/#{name}.coffee", "components/#{newname}/js/#{newname}.coffee", (err) ->
    if not err?
      childproc.exec "coffee -o components/#{newname}/js -c components/#{newname}/js/#{newname}.coffee", (er, o, e) ->
        callback true
    else
      callback false, err
  #add to loadorder 

everyone.now.renameComponent = (name, newname, callback) ->
  console.log 'received rename for ' + name + ' to ' + newname
  fs.rename "components/#{name}/#{name}.coffee", "components/#{name}/#{newname}.coffee"
  fs.rename "components/#{name}/#{name}.html", "components/#{name}/#{newname}.html"
  fs.rename "components/#{name}/css/#{name}.css", "components/#{name}/css/#{newname}.css"
  scripts = fs.readFile "components/#{name}/scripts", 'utf8', (err, data) ->
    scripts = data.replace "#{name}.js", "#{newname}.js"    
    fs.writeFile "components/#{name}/scripts", scripts, 'utf8'
  styles = fs.readFile "components/#{name}/styles", 'utf8', (err, data) ->
    styles = data.replace "#{name}.css", "#{newname}.css"    
    fs.writeFile "components/#{name}/styles", styles, 'utf8'
    
  fs.rename "components/#{name}/js/#{name}.coffee", "components/#{name}/js/#{newname}.coffee", (err) ->
    if not err?
      childproc.exec "coffee -o components/#{name}/js -c components/#{name}/js/#{newname}.coffee", (er, o, e) ->
        fs.rename "components/#{name}", "components/#{newname}"
        callback true
    else
      callback false, err

###      
#everyone.now.testGit = ->
#  #GET /gists/:gist_id/comments
#  options =
#    method: 'GET'
#    url: "https://api.github.com/gists/'
###


