fs = require 'fs'
util = require 'util'
path = require 'path'
proc = require 'child_process'
sh = require 'shelljs'
jsmin = require('jsmin').jsmin
cssmin = require('cssmin').cssmin

if path.existsSync 'localconfig.coffee'
  config = require './localconfig'
else
  config = require './config'

process.config = config

getorder = (fname) ->
  loadstr = fs.readFileSync fname, 'utf8'
  loadstr.split '\n'
 
head = ''

trim = (string) ->
  string.replace /^\s*|\s*$/g, ''

listfile = (fname) ->
  str = fs.readFileSync fname, 'utf8'
  list = str.split '\n'
  (trim item for item in list when item? and trim(item).length>0)

process.listfile = listfile
  
readstyles = (name) ->
  try
    list = listfile "components/#{name}/styles"
    str = ''
    for fname in list
      if fname.indexOf('/') is 0
        prefix = ''
      else
        prefix = 'css/'
      filepath = 'public/' + prefix + fname
      if path.existsSync filepath
        str += fs.readFileSync filepath, 'utf8'
    
    if path.existsSync "components/#{name}/css"
      sh.cp '-Rf', "components/#{name}/css/*", 'public/css'
    str
    
  catch e
    console.log "#{e.message}\n#{e.stack}"

readscripts = (name) ->
  try
    list = listfile "components/#{name}/scripts"
    str = ''
    headscripts = ''
    for fname in list
      if fname.indexOf('/') is 0
        prefix = ''
        headscripts += "<script src=\"#{fname}\"></script>"
      else
        prefix = 'js/'
      if fname.indexOf('//') is 0
        headscripts += "<script src=\"#{fname}\"></script>"
        continue
      filepath = 'public/' + prefix + fname
      if path.existsSync filepath
        filedat = fs.readFileSync filepath, 'utf8'
        filedat = filedat.replace /^\uFEFF/g, ''
        str += filedat

    if path.existsSync "components/#{name}/js"
      sh.cp '-Rf', "components/#{name}/js/*", 'public/js'
    return { str: str, headscripts: headscripts }
    
  catch e
    console.log "#{e.message}\n#{e.stack}"

copyimages = (name) ->
  try
    if path.existsSync "components/#{name}/images"
      sh.cp '-Rf', "components/#{name}/images/*", 'public/images'
  catch e
    console.log "#{e.message}\n#{e.stack}"


readbody = (name) ->
  try
    if path.existsSync "components/#{name}/#{name}.html"
      return fs.readFileSync "components/#{name}/#{name}.html", 'utf8'
    else
      return ''
  catch e
    console.log "#{e.message}\n#{e.stack}"

buildTime = null

headcss = (toload) ->
  head = ''
  for component in toload
    if component? and component.length > 0
      head += readstyles component
  console.log "Minifying CSS: start #{head.length} characters"
  head2 = cssmin head
  console.log "CSS now has #{head2.length} characters"
  fs.writeFile "public/css/combined#{buildTime}.css", head2, 'utf8'
  "<link rel=\"stylesheet\" href=\"css/combined#{buildTime}.css\">"
  
headjs = (toload) ->
  head = ''
  headext = ''
  for component in toload
    if component? and component.length > 0
      ret = readscripts component
      head += ret.str
      headext += ret.headscripts
  #console.log "Minifying JS code: start #{head.length} characters"
  #head2 = jsmin head, 3
  #console.log "JS code now #{head2.length} characters"
  fs.writeFile "public/js/combined#{buildTime}.js", head, 'utf8'
  headext #+ '<script src="js/combined.js"></script>'
 

loadbody = (toload) ->
  body = ''
  for component in toload
    if component? and component.length > 0
      body += readbody component
  body

build = (toload) ->
  buildTime = new Date().getTime()
  css = headcss toload
  scripts = headjs toload
  body = loadbody toload
  body += "<script src=\"js/combined#{buildTime}.js\"></script>"
  for component in toload
    copyimages component

  "<!doctype html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><title>Cure CMS</title>#{css}</head><body>#{body}#{scripts}</body></html>"

writebuild = (source) ->
  fs.writeFileSync "public/index.html", source, 'utf8'

exports.startup = (file) ->
  toload = listfile file
  comps = {}
  for component in toload
    try
      console.log "Building #{component}"
      comps[component] = require "./components/#{component}/#{component}"
      comps[component]?.build?()
    catch e
      console.log util.inspect e

  for component in toload
    try
      console.log "Starting #{component}"
      key = "./components/#{component}/#{component}"
      if key in require.cache then delete require.cache[key]
      comps[component] = require key
      comps[component]?.startup?()
    catch e
      console.log util.inspect e

  html = build toload
  writebuild html

