fs = require 'fs'
zlib = require 'zlib'


basedir = ''

notstatic = {}

cached = {}

setbase = (dir) ->
  basedir = dir

iscachefile = (path) ->
  extensions = [
    '.ico'
    '.js'
    '.html'
    '.css'
  ]

  for ext in extensions
    if path.indexOf ext
      return true
  return false


contenttype = (filepath) ->
  filepath = filepath.toLowerCase()
  if filepath.indexOf('.js') > 0
    return 'application/x-javascript'
  else if filepath.indexOf('.ico') > 0
    return 'image/x-icon'
  else if filepath.indexOf('.css') > 0
    return 'text/css'
  else if filepath.indexOf('.html') > 0
    return 'text/html'
  else if filepath.indexOf('.png') > 0
    return 'image/png'
  else if filepath.indexOf('.jpg') > 0
    return 'image/jpeg'
  else if filepath.indexOf('.jpeg') > 0
    return 'image/jpeg'
  else if filepath.indexOf('.gif') > 0
    return 'image/gif'
  else
    return 'text/plain'


isbinary = (type) ->
  if not (type.indexOf('text') is 0 or type.indexOf('json')>0 or type.indexOf('javascript')>0)
    return true
  else
    return false

dropquery = (filepath) ->
  pos = filepath.indexOf('?')
  if pos > 0
    return filepath.substr(0, pos)
  else
    return filepath

filedata = {}

cacheFileInfo = (filepath, callback) ->
  fs.stat filepath, (err, stat) ->
    filedata[filepath] =
      size: stat.size
      modified: new Date(stat.mtime).toUTCString()
      etag: "\"#{stat.ino}-#{stat.size}-#{Date.parse(stat.mtime)}\""
    callback filedata[filepath]

cacheFileInfoGZ = (filepath, callback) ->
  fs.stat filepath + '.gz', (err, stat) ->
    filedata[filepath] =
      size: stat.size
      modified: new Date(stat.mtime).toUTCString()
      etag: "\"#{stat.ino}-#{stat.size}-#{Date.parse(stat.mtime)}\""
    callback? filedata[filepath]


checkETag = (filepath, req) ->
  fdata = filedata[filepath]
  headerFields = {}
  headerFields['Content-Length'] = fdata.size
  headerFields['ETag'] = fdata.etag
  headerFields['Last-Modified'] = fdata.modified
  statCode = 200
  if req.headers['if-none-match'] is fdata.etag
    statCode = 304
    headerFields['Content-Length'] = 0
  else if req.headers['if-modified-since']?
    since = Date.parse req.headers['if-modified-since']
    if Date.parse(fdata.modified) <= since
      statCode = 304
      headerFields['Content-Length'] = 0
  ret =
    headerFields: headerFields
    statCode: statCode
  return ret


readbinary = (filepath, type, res) ->
  fs.readFile filepath, (err, data) ->
    if err?
      console.log 'sending 404 for binary ' + filepath
      res.writeHead 404,
        'Content-Type': 'text/plain'
      res.end 'Not found'
      cached[filepath] = ''
    else
      res.writeHead 200,
        'Content-Type': type
      res.end data #, encoding
      cached[filepath] = data
      cacheFileInfo filepath, ->

readhtml = (filepath, type, res, callback) ->
  encoding = 'utf8'
  fs.readFile filepath, encoding, (err, data) ->
    res.writeHead 200,
      'Content-Type': type
    res.end data, encoding
    cached[filedpath] = data
    cacheFileInfo filepath, ->

readtext = (filepath, type, res, callback) ->
  encoding = 'utf8'
  fs.readFile filepath, encoding, (err, data) ->
    if err?
      console.log "Error in cachefiles reading #{filepath}"
      console.log err.message
      callback false
    else
      zlib.gzip data, (err, buffer) ->
        if err?
          res.writeHead 500,
            'Content-Type': type
          res.end 'deflate error'
         else
           res.writeHead 200,
             'Content-Encoding': 'gzip'
             #'Content-Length': filedata[filepath].size
             #'Vary': 'Accept-Encoding'
             #'Content-Type': type
             #res.end data, 'utf8' #buffer, 'binary' #'utf8'
           res.end buffer
           cached[filepath] = buffer
           callback true
           cacheFileInfo filepath, ->
             
   
set = (name, content, callback) ->
  #cached[name] = content
  #filedata[name] =
  #  size: content.length
  #  modified: new Date().toUTCString()
  #  etag: "\"#{Math.random()*999}#{content.substring(0,3)}-#{content.length}-#{new Date().toUTCString()}\""
  #callback?()
  zlib.gzip content, (err, buffer) ->
    cached[name] = buffer
    filedata[name] =
      size: buffer.length
      modified: new Date().toUTCString()
      etag: "\"#{Math.random()*999}#{content.substring(0,3)}-#{content.length}-#{new Date().toUTCString()}\""

    callback?()

get = (filepath, req, res, callback) ->
  filepath = dropquery filepath
  if filepath.substr(0) != '/'
    filepath = '/' + filepath
  if not (filepath.indexOf(basedir) is 0)
    filepath = basedir + filepath
  filepath = filepath.replace "#{basedir}\/\/", "#{basedir}/"
  if notstatic[filepath]?
    callback false
  else if cached[filepath]
    type = contenttype filepath
     
    check = checkETag filepath, req
    console.log 'filepath is' + filepath
    if filepath isnt 'public/devindex.html' and check.statCode is 304
      res.writeHead 304,
        'ETag' : check.headerFields.ETag
        'Date' : new Date().toUTCString()
        'Last-Modified': check.headerFields['Last-Modified']
        'Cache-Control': 'public, max-age=31540000'
      res.end()
    else
      if isbinary type
        res.writeHead 200,
          'Content-Type': type
          'ETag': check.headerFields.ETag
          'Date': new Date().toUTCString()
          'Last-Modified': check.headerFields['Last-Modified']
          'Cache-Control': 'public, max-age=31540000'
        res.end cached[filepath]
        callback true
      #else if type is 'text/html'
      #  res.writeHead 200,
      #    'Content-Type': type
      #  res.end cached[filepath]
      else
        dat = cached[filepath]
        res.writeHead 200,
          'Content-Encoding': 'gzip'
          'Date': new Date().toUTCString()
          'ETag': check.headerFields.ETag
          'Last-Modified': check.headerFields['Last-Modified']
          'Cache-Control': 'public, max-age=31540000'
          #'Content-Length': 1480 #check.headerFields['Content-Length']
          #'Content-Type': type
        res.end dat
        callback true
        #'Content-Type': type
        #'Vary': 'Accept-Encoding'
        #'Content-Length': check.headerFields['Content-Length']
  else
    type = contenttype filepath
    if isbinary type
      readbinary filepath, type, res
    #else if type is 'text/html'
    #  readhtml filepath, type, res
    else
      readtext filepath, type, res, callback


exports.get = get
exports.set = set
exports.setbase = setbase
exports.iscachefile = iscachefile
exports.dropquery = dropquery
