formidable = require 'formidable'
util = require 'util'
sh = require 'shelljs'

process.app.on 'request', (req, res) ->
  if req.url.indexOf('/dyn/upload') is 0 and req.method.toLowerCase() is 'post'
    console.log 'upload'
    
    form = new formidable.IncomingForm()
    form.uploadDir = '.'
    form.parse req, (err, fields, files) ->
      res.writeHead 200, {'content-type': 'text/plain'}
      res.write 'received upload:\n\n'
      res.end util.inspect({fields: fields, files: files})
      console.log util.inspect({fields: fields, files: files})
      #upload = files.upload
      #if upload? and (not upload.path?)
      #  for file in upload
      #    console.log 'copied a file on upload multiple'
      #    sh.cp file.path, file.name
      #else
      #  console.log 'copied a single file on upload'
      #  sh.cp upload.path, upload.name
        
    return
    
  
