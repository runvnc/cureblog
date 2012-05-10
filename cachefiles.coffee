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
      modified: new Date(stat.mtime).toUTCString()
      etag: "\"#{stat.ino}-#{stat.size}-#{Date.parse(stat.mtime)}\""
    callback filedata[filepath]


checkETag = (filepath, req) ->
  fdata = filedata[filepath]
  headerFields = {}
  headerFields['ETag'] = fdata.etag
  headerFields['Last-Modified'] = fdata.modified
  statCode = 200
  if req.headers['if-none-match'] is fdata.etag
    statCode = 304
    headerFields['Content-Length'] = 0
  ret =
    headerFields: headerFields
    statCode: statCode
  return ret


readbinary = (filepath, type, res) ->
  encoding = 'binary'
  fs.readFile filepath, encoding, (err, data) ->
    if err?
      res.writeHead 404,
        'Content-Type': 'text/plain'
      res.end 'Not found'
      cached[filepath] = ''
    else
      res.writeHead 200,
        'Content-Type': type
      res.end data, encoding
      cached[filepath] = data
      cacheFileInfo filepath, ->

readtext = (filepath, type, res, callback) ->
  encoding = 'utf8'
  fs.readFile filepath, encoding, (err, data) ->
    if err?
      console.log "Error in cachefiles reading #{filepath}"
      console.log err.message
      callback false
    else
      zlib.deflate data, (err, buffer) ->
        if err?
          res.writeHead 500,
            'Content-Type': type
            res.end 'deflate error'
         else
           res.writeHead 200,
             'Content-Type': type
             'Content-Encoding': 'deflate'
             'Content-Length': buffer.length
           res.end buffer, 'binary'
           cached[filepath] = buffer
           callback true
           cacheFileInfo filepath, ->

 
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
    if check.statCode is 304
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
        res.end cached[filepath], 'binary'
        callback true
      else
        dat = cached[filepath]
        res.writeHead 200,
          'Content-Type': type
          'Content-Encoding': 'deflate'
          'Date': new Date().toUTCString()
          'Content-Length': dat.length
          'ETag': check.headerFields.ETag
          'Last-Modified': check.headerFields['Last-Modified']
          'Cache-Control': 'public, max-age=31540000'
        res.end dat, 'binary'
        callback true
  else
    type = contenttype filepath
    if isbinary type
      readbinary filepath, type, res
    else
      readtext filepath, type, res, callback


exports.get = get
exports.setbase = setbase
exports.iscachefile = iscachefile

