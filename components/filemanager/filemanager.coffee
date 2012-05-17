everyone = process.everyone
formidable = require 'formidable'
util = require 'util'
sh = require 'shelljs'
fs = require 'fs'
async = require 'async'
request = require 'request'
childproc = require 'child_process'


mydir = ''

addstat = (file, callback) ->
  fs.stat mydir + file, (err, stats) ->
    ret =
      name: file
      stats: stats
      isDirectory: stats.isDirectory()
      
    callback undefined, ret

    
fileordir = (dir, files, callback) ->
  mydir = dir
  if mydir is '.' then mydir = './'
  async.map files, addstat, (err, results) ->
    callback results
  

process.app.on 'request', (req, res) ->

  if req.url.indexOf('/dyn/upframe') is 0
    uploadform = """  
    <form id="uploadform" action="/dyn/upload" enctype="multipart/form-data" method="post">
      <input type="file" name="upload" multiple="multiple"><br>
      <input type="submit" value="Upload">
    </form>
                 """
    res.writeHead 200, {'content-type': 'text/html'}
    res.end uploadform, 'utf8'
    
  else if req.url.indexOf('/dyn/upload') is 0 and req.method.toLowerCase() is 'post'
    form = new formidable.IncomingForm()

    form.on 'file', (name, file) ->
      fs.rename file.path, file.name
    
    form.parse req, (err, fields, files) ->
      res.writeHead 200, {'content-type': 'text/html'}
      res.end '<script>window.parent.doneUploading();</script>'      
        
    return


fnameFromUrl = (url) ->
  url.substring(0, (if (url.indexOf("#") is -1) then url.length else url.indexOf("#")))
  url = url.substring(0, (if (url.indexOf("?") is -1) then url.length else url.indexOf("?")))
  url = url.substring(url.lastIndexOf("/") + 1, url.length)
  url
  
  
everyone.now.loadAndUncompress = (url, dir, callback) ->
  request {url:url, encoding: null}, (err, res, body) ->
    if err? then console.log err
    if body?
      fname = fnameFromUrl url
      if dir is '.' or dir is './' then dir = ''
      fs.writeFile dir + fname, body, (err) ->
        if not err?
          childproc.exec "cd #{dir};unzip #{fname};tar xvf #{dir + fname}", (er, o, e) ->
            console.log er
            console.log o
            console.log e
            callback undefined
        else
          callback? err
  

everyone.now.listFiles = (dir, callback) ->
  console.log 'listing files'
  fs.readdir dir, (err, files) ->
    console.log 'readdir returned'    
    fileordir dir, files, callback    

