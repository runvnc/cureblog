fs = require 'fs'
path = require 'path'
proc = require 'child_process'

readIfExists = (fname) ->
  if path.existsSync fname
    fs.readFileSync fname, 'utf8'

together = (which, name, ext, str, outfile) ->
  if not name? or name == '' then return
  console.log "Name is *#{name}*"
  filepath = "components/#{name}/#{which}.#{ext}"
  if path.existsSync filepath
    try
      str += fs.readFileSync filepath, 'utf8'
      console.log "Writing file #{outfile}"
      fs.writeFileSync outfile, str

      if path.existsSync "components/#{name}/#{ext}"
        console.log "Copying files from components/#{name}/#{ext} to public/#{ext}"
        proc.exec "cp -R components/#{name}/#{ext} public/"

    catch e
      console.log "#{filepath}: #{e.message}"
  else
    console.log "Path does not exist: #{filepath}"

getorder = ->
  loadstr = fs.readFileSync 'loadorder', 'utf8'
  loadstr.split '\n'

toload = getorder() 

puttogether = (filename, ext, outfile) ->
  str = ''
  together filename, component, ext, str, outfile for component in toload


build = ->
  puttogether 'back', 'js', 'app.js'
  puttogether 'front', 'js', 'public/main.js'
  puttogether 'styles', 'css', 'public/styles.css'
  puttogether 'htmlhead', 'html', 'public/head.html'
  puttogether 'htmlmain', 'html', 'public/main.html'
  puttogether 'htmlfooter', 'html', 'public/footer.html'

  htmlhead = readIfExists 'public/head.html'
  htmlmain = readIfExists 'public/main.html'
  htmlfooter = readIfExists 'public/footer.html'
  html = htmlhead + htmlmain + htmlfooter + '</body></html>'
  console.log 'Writing file public/index.html'
  fs.writeFileSync 'public/index.html', html

exports.build = build 
 
