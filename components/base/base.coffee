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

oneYear = 31557600000

cachefiles.setbase 'public'

app.on 'request', (req, res) ->
  checkSession req, (session) ->
    if req.url is '/'
      filepath = 'index.html'
    else if req.url is '/socket.io/socket.io.js'
      filepath = 'js/socket.io.js'
    else
      filepath = req.url
    if req.url is '/' or cachefiles.iscachefile filepath
      cachefiles.get filepath, req, res, (success) ->
        #if not success
  
    #page = fs.readFileSync 'static/page', 'utf8'
    #index = index.replace '{{page}}', page
  
    #response.send index

nowjs = require 'now'

socketoptions =
  socketio:
    'browser client gzip' : true
    'browser client etag' : true
    'browser client cache' : true

everyone = nowjs.initialize app, socketoptions

process.everyone = everyone

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
    console.log 'getSession return from memory ' + sessions[id]
    callback sessions[id]
  else
    criteria =
      guid: id
    console.log 'inside of getSession for id ' + id
    db.collection('sessions').findOne criteria, (err, session) ->
      if err?
        console.log 'findOne returned error ' + err.message
        callback null
      else
        
        console.log 'findOne returned ' + session
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
  console.log 'inside of logout'
  toremove =
    guid: id
  console.log 'about to delete id ' + id
  delete sessions[id]
  console.log 'deleted the id'
  db.collection('sessions').remove toremove, (err) ->
    if err?
      console.log "error in remove"
      console.log err
      callback?()
    else
      console.log 'successfully deleted ' + id + ' from database'
      callback?()
    

everyone.now.getAccountInfo = (sessionid, callback) ->
  getSession sessionid, (session) ->
    if session?
      callback session.user
    else
      callback undefined
  
  
everyone.now.savePage = (html, callback) ->
  index = process.templates['index']
  index = index.replace '{{page}}', html
  cachefiles.set 'public/index.html', index
  fs.writeFile "static/page.html", html, (err) ->
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

everyone.now.dbinsert = (col, data) ->
  db.collection(col).insert data

everyone.now.dbrestore = (criteria) ->
  db.collection('backups').findOne criteria: criteria, (err, backups) ->
    for backup in backups
      console.log backup

everyone.now.dbupdate = (col, criteria, data) ->
  db.collection(col).find(criteria).toArray (err, doc) ->
    if (err)
      console.log err
    db.collection('backups').insert
      status: 'saved'
      col: col
      modified: new Date()
      criteria: criteria
      data : doc
    db.collection(col).update criteria, data

everyone.now.dbfind = (col, callback) ->
  db.collection(col).find().toArray (err, data) ->
    callback data

everyone.now.saveFile = (filename, filedata, callback) ->
  fs.writeFile filename, filedata, 'utf8', (err) ->
    callback err
    
loadpage = ->
  index = process.templates['index']
  fs.readFile "static/page.html", 'utf8', (err, html) ->
    if err? then console.log err
    index = index.replace '{{page}}', html
    cachefiles.set 'public/index.html', index
    
loadpage()
    
console.log "OIC listening on port #{process.config.port}"
app.listen process.config.port


