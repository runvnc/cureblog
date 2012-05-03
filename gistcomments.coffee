request = require 'request'

auth =
  user: ''
  pass: ''

config = (user, pass) ->
  auth.user = user
  auth.pass = pass    

listcomments = (id, callback) ->
  console.log "url is " + "https://api.github.com/gists/#{id}/comments"
  request "https://api.github.com/gists/#{id}/comments", (err, res, body) ->
    if callback? then callback err, res, body

addcomment = (id, body, callback) ->
  options =
    method: 'POST'
    uri: "https://#{auth.user}:#{auth.pass}@api.github.com/gists/#{id}/comments"
    json: body
  request options, (err, res, body) ->
    if err? then console.log err
    console.log res
    console.log body
    if callback? then callback err, res, body  

exports.config = config
exports.listcomments = listcomments
exports.addcomment = addcomment


