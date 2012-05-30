window.login = ->
  console.log 'you clicked login'
  now.login 'admin', '', (guid) ->
    console.log 'guid is ' + guid
    window.createCookie 'myid', guid, 1
    window.location.assign '/?dev'
    
window.logout = ->
  myid = window.readCookie 'myid'
  window.eraseCookie 'myid'
  now.logout myid, ->
    window.location.assign '/'
  window.delay 500, ->
    window.location.assign '/'
  
$(document).bind 'sessionState', (user) ->
  console.log 'Inside of login window.loggedIn is ' + window.loggedIn
  if window.loggedIn? and window.loggedIn
    $('#loginout').text 'Logout'
    $('#loginout').click ->
      window.logout()
  else
    $('#loginout').text 'Login'
    $('#loginout').click ->
      window.login()
      
    
