#When you aren't logged in
#panel on left is hidden
#therefore we need a way to log in
#to start, just make a link that you click
#which sets a logged in state on the server
#session

#how am I going to do sessions?

window.login = ->
  console.log 'you clicked login'
  now.login 'admin', '', (guid) ->
    console.log 'guid is ' + guid
    window.createCookie 'myid', guid, 1
    
