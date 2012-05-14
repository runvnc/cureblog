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

process.templates = {}

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
  
readstyles = (name, which) ->
  try
    list = listfile "components/#{name}/styles"
    str = ''
    for fname in list
      if which is '' and fname.substr(fname.length-1,1) isnt '*'
        console.log 'skipping ' + fname
        continue #static/non-design mode doesn't include styles unless they end in *
      else
        console.log 'not skipping ' + fname
        if fname.substr(fname.length-1, 1) is '*'
          fname = fname.substr 0, fname.length-1
      console.log 'its ' + fname
      if fname.indexOf('/') is 0
        prefix = ''
      else
        prefix = 'css/'
      filepath = "components/#{name}/#{prefix}#{fname}"
      if path.existsSync filepath
        str += fs.readFileSync filepath, 'utf8'
    
    if path.existsSync "components/#{name}/css"
      sh.cp '-Rf', "components/#{name}/css/*", 'public/css'
    str
    
  catch e
    console.log "#{e.message}\n#{e.stack}"

readscripts = (name, which) ->
  try
    list = listfile "components/#{name}/scripts"
    str = ''
    headscripts = ''
    for fname in list
      if which is '' and fname.substr(fname.length-1,1) isnt '*'
        continue #static/non-design mode doesn't include scripts unless they end in *
      else
        if fname.substr(fname.length-1, 1) is '*'
          fname = fname.substr 0, fname.length-1
      if fname.indexOf('/') is 0
        prefix = ''
        headscripts += "<script src=\"#{fname}\"></script>"
      else
        prefix = 'js/'
      if fname.indexOf('//') is 0
        headscripts += "<script src=\"#{fname}\"></script>"
        continue
      filepath = "components/#{name}/#{prefix}#{fname}"
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

headcss = (toload, which) ->
  head = ''
  for component in toload
    if component? and component.length > 0
      head += readstyles component, which
  console.log "Minifying CSS: start #{head.length} characters"
  head2 = cssmin head
  console.log "CSS now has #{head2.length} characters"
  fs.writeFile "public/css/combined#{buildTime}.css", head2, 'utf8'
  "<link rel=\"stylesheet\" href=\"css/combined#{buildTime}.css\">"

combinedcss = (toload, which) ->
  head = ''
  for component in toload
    if component? and component.length > 0
      head += readstyles component, which
  console.log "Minifying CSS: start #{head.length} characters"
  head2 = '<style>' + cssmin head + '</style>'
  console.log "CSS now has #{head2.length} characters"
  head2
 
  
headjs = (toload, which) ->
  head = ''
  headext = ''
  for component in toload
    if component? and component.length > 0
      ret = readscripts component, which
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

dropitem = (array, todrop) ->
  dropnum = -1
  for num in [0..array.length]
    if array[num] is todrop
      dropnum = num
  if dropnum > -1
    array.splice dropnum, 1
  array

checkcomponents = (toload) ->
  for component in toload
    if not path.existsSync "components/#{component}"
      console.log 'not found so dropping ' + component
      dropitem toload, component
  str = toload.join "\n"
  fs.writeFileSync 'loadorder', str
  toload
 

build = (toload, which) ->
  buildTime = new Date().getTime()
  #css = headcss toload, which
  css = combinedcss toload, which
  scripts = headjs toload, which
  body = loadbody toload, which
  body += "<script src=\"js/combined#{buildTime}.js\"></script>"
  for component in toload
    copyimages component

  #addCss =  '<script>var headHTML = document.getElementsByTagName("head")[0].innerHTML;'
  #addCss += 'headHTML+= \'' + css + '\';'
  #addCss += 'document.getElementsByTagName("head")[0].innerHTML = headHTML;</script>'
  "<!doctype html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><title>Cure CMS</title>#{css}</head><body>#{body}#{scripts}</body></html>"

writebuild = (source, which) ->
  process.templates["#{which}index"] = source
  fs.writeFileSync "public/#{which}index.html", source, 'utf8'

exports.startup = (file) ->
  toload = listfile file
  toload = checkcomponents toload
  comps = {}
  html = build toload, 'dev'
  writebuild html, 'dev'
  html2 = build toload, ''
  writebuild html2, ''

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

