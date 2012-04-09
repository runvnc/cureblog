fs = require 'fs'
util = require 'util'
path = require 'path'
proc = require 'child_process'
sh = require 'shelljs'

console.log "Hello from thing"

getorder = -> 
  loadstr = fs.readFileSync 'loadorder', 'utf8' 
  loadstr.split '\n' 
 
toload = getorder() 

head = ''

trim = (string) ->
  string.replace /^\s*|\s*$/g, ''

listfile = (fname) ->
  str = fs.readFileSync fname, 'utf8'
  console.log "Loaded #{str}"
  list = str.split '\n'
  (trim item for item in list when item? and trim(item).length>0)
  
readstyles = (name) ->
  try
    list = listfile "components/#{name}/styles"
    str = ''
    for fname in list
      str += '<link type="text/css" href="public/css/' + fname + '"/>\n'
    
    if path.existsSync "components/#{name}/css" 
      console.log "Copying files from components/#{name}/css to public/css" 
      sh.cp '-Rf', "components/#{name}/css/*", 'public/css'
    str 
    
  catch e
    console.log "#{e.message}\n#{e.stack}"

headcss = (toload) ->
  head = ''
  for component in toload 
    if component? and component.length > 0
      head += readstyles component

headjs = ->  
  #build head scripts
  # go into each components folder in order
  #  read list of scripts from scripts  
  #    put js in head
  #    copy js/* into public/js

build = ->
  css = headcss()
  scripts = headjs()
  fs.writeFileSync "public/index.html", css + scripts, 'utf8'

startup = ->
  build()
  # go into each components folder in the order from loadorder
  #  require componentname.coffee
  #    call component.startup app

vows = require 'vows'
assert = require 'assert'

vows
  .describe('CureBlog main app')
  .addBatch
    'listfile for list1':
      topic: -> (listfile 'datatest/list1')                

      'returns two items': (topic) ->
        console.log util.inspect topic
        assert.equal topic.length, 2
        
      'they are apples and orange': (topic) ->
        assert.equal topic[0], 'apples'
        assert.equal topic[1], 'oranges'

      'read test styles':
        topic: -> readstyles 'test'

        'returns a link element to the test.css': (topic) ->
          console.log util.inspect topic
          assert.equal topic, '<link type="text/css" href="public/css/test.css"/>\n'
    
    

  .export module
