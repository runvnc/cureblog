http = require 'http'
MongolianDeadBeef = require 'mongolian'
server = new MongolianDeadBeef
nowjs = require 'now'
fs = require 'fs'
util = require 'util'
request = require 'request'
childproc = require 'child_process'
cachefiles = require '../../cachefiles'

ObjectId = MongolianDeadBeef.ObjectId
ObjectId.prototype.toJSON = ->
  return @toString()

S4 = ->  (((1+Math.random())*0x10000)|0).toString(16).substring(1)
process.guid = -> S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()

db = server.db 'app'

app = http.createServer()

process.app = app

cachefiles.setbase 'public'

process.cachefiles = cachefiles

app.on 'request', (req, res) ->
  isdynamic = (req.url.indexOf('/dyn') >= 0)
  console.log 'isdynamic is ' + isdynamic
  console.log 'req.url is ' + req.url
  if isdynamic then return

  ispage = (req.url.indexOf('/page') is 0)
  if ispage
    req.url = '/'  
    console.log 'its a page??'
  if cachefiles.dropquery(req.url) is '/'  
    checkSession req, (session) ->
      if session? and session.user is 'admin'
        console.log 'returning devindex'
        filepath = 'devindex.html'
      else
        console.log 'session not found or not admin'
        filepath = 'index.html'
      cachefiles.get filepath, req, res, (success) ->
  else if req.url is '/socket.io/socket.io.js'
    filepath = 'js/socket.io.js'
  else
    filepath = req.url
    if cachefiles.iscachefile filepath
      cachefiles.get filepath, req, res, (success) ->


nowjs = require 'now'

socketoptions =
  socketio:
    'browser client gzip' : true
    'browser client etag' : true
    'browser client cache' : true

everyone = nowjs.initialize app, socketoptions

process.everyone = everyone

stdoutmsg = []
stderrmsg = []


nowisready = false


hookstd = (which, q) ->
  orig = process[which].write
  process[which].write = (string, encoding, fd) ->
    orig.call process[which], string, encoding, fd
    if process.nowisready and process.everyone.now.consolelog?     
      if q.length > 0
        for m in q
          process.everyone.now.consolelog m
      process.everyone.now.consolelog string
      q = []
    else
      q.push string


delayit = (time, func) ->
  setTimeout func, time

hookstd 'stdout', stdoutmsg
hookstd 'stderr', stderrmsg

delayit 10000, ->
  process.nowisready = true
  console.log 'Hello from server'

  

everyone.now.restartServer = ->
  request 'http://127.0.0.1:' + process.config.restarterport + '/'

  
sessions = {}

process.getCookie = (req, name) ->
  nameEQ = name + "="
  ca = req.headers.cookie.split(";")
  i = 0
  while i < ca.length
    c = ca[i]
    c = c.substring(1, c.length)  while c.charAt(0) is " "
    return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
    i++
  null

checkSession = (req, callback) ->
  if not req.headers.cookie?
    callback undefined
  else
    id = process.getCookie req, 'myid'
    if id?
      getSession id, callback
    else
      callback undefined

getSession = (id, callback) ->
  if sessions[id]?
    callback sessions[id]
  else
    criteria =
      guid: id
    console.log 'searching databsae for session'
    db.collection('sessions').findOne criteria, (err, session) ->
      if err?
        console.log 'findOne returned error ' + err.message
        callback null
      else
        sessions[id] = session
        callback session

        
everyone.now.login = (user, pass, callback) ->
  guid = process.guid()

  session =
    guid: guid
    loggedin: new Date()
    user: user
  sessions[guid] = session

  db.collection('sessions').insert session
    
  callback guid
  
  
everyone.now.logout = (id, callback) ->
  toremove =
    guid: id
  delete sessions[id]
  db.collection('sessions').remove toremove, (err) ->
    if err?
      console.log "error in remove"
      console.log err
      callback?()
    else
      callback?()
    

everyone.now.getAccountInfo = (sessionid, callback) ->
  getSession sessionid, (session) ->
    if session?
      callback session.user
    else
      callback undefined
  
  
everyone.now.savePage = (html, callback) ->
  console.log 'TRYING TO SAVE SOME HTML *********** '
  index = process.templates['devindex']
  index = index.replace '{{page}}', html
  cachefiles.set 'public/devindex.html', index

  index = process.templates['index']
  index = index.replace '{{page}}', html
  cachefiles.set 'public/index.html', index
  console.log 'OK SO FAR'
  fs.writeFile "static/page.html", html, (err) ->
    if err
      console.log err
      if callback? then callback false
    else
      if callback? then callback true

      
saveStaticPage = (name, html, callback) ->
  cachefiles.set 'public/' + name, html

  fs.writeFile "public/" + name, html, (err) ->
    if err
      console.log err
      if callback? then callback false
    else
      if callback? then callback true      

process.saveStaticPage = saveStaticPage  


everyone.now.saveStaticPage = (name, html, callback) ->
  cachefiles.set 'public/' + name, html

  fs.writeFile "public/" + name, html, (err) ->
    if err
      console.log err
      if callback? then callback false
    else
      if callback? then callback true     
      
  
everyone.now.saveStatic = (name, html, callback) ->
  fs.writeFile "static/#{name}", html, (err) ->
    if err
      console.log err
      if callback? then callback false
    else
      if callback? then callback true

everyone.now.dbinsert = (col, data, callback) ->
  db.collection(col).insert data
  callback?()

everyone.now.dbrestore = (criteria) ->
  db.collection('backups').findOne criteria: criteria, (err, backups) ->
    for backup in backups
      console.log backup
      

convertids = (obj) ->
  if obj['_id']?
    obj['_id'] = new ObjectId(obj['_id'])
  
  if obj['id']?
    obj['_id'] = new ObjectId(obj['id'])
    delete obj['id']
  
  
everyone.now.dbupdate = (col, criteria, data, callback) ->
  console.log 'id is ' + criteria['id']
  console.log 'criteria is ' + util.inspect(criteria)
  convertids criteria
  delete data['_id']
  console.log 'criteria is now ' + util.inspect(criteria)
  db.collection(col).update criteria, data, (err, val) ->
    console.log 'db collection update callback'
    console.log err
    console.log val
    callback?()
    
everyone.now.dbfind = (col, callback) ->
  db.collection(col).find().toArray (err, data) ->
    callback data

everyone.now.dbquery = (col, criteria, callback) ->
  console.log 'dbquery criteria is '
  console.log util.inspect criteria
  convertids criteria
  db.collection(col).find(criteria).toArray (err, data) ->
    callback? data
    
    
everyone.now.saveFile = (filename, filedata, callback) ->
  fs.writeFile filename, filedata, 'utf8', (err) ->
    callback err
    
loadpage = ->
  index = process.templates['devindex']
  index2 = process.templates['index']
  fs.readFile "static/page.html", 'utf8', (err, html) ->
    if err? then console.log err
    index = index.replace '{{page}}', html
    cachefiles.set 'public/devindex.html', index
    index2 = index2.replace '{{page}}', html
    cachefiles.set 'public/index.html', index2
    
loadpage()
    
console.log "OIC listening on port #{process.config.port}"
app.listen process.config.port


