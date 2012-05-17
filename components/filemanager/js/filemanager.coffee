cwd = '.'
      
  
sortem = (files) ->
  files.sort (a, b) ->
    if a.isDirectory
      return -1
    else
      return a.name - b.name
  files   

 
showFiles = (files) ->
  str = '<li class=\"fmupdir\">..</li>'
  sortem files
  for file in files
    console.log file
    listing = file.name
    classnm = "fmfile"
    if file.isDirectory
      listing += '/'
      classnm = "fmdir"
    str += "<li class=\"#{classnm}\">#{listing}</li>"
  $('#fsroot').html str
  $('.fmdir').click ->    
    console.log 'you clicked fmdir'
    if cwd is '.' then cwd = './'
    cwd += $(this).text()
    console.log 'new dir is ' + cwd
    listFiles()
  $('.fmupdir').click ->
    dirs = cwd.split '/'
    newdirs = []
    for d in dirs
      if d isnt ''
        newdirs.push d
      else
        console.log 'd is 3' + d + '3' 
    newdirs.splice newdirs.length-1, 1
    cwd = newdirs.join '/'
    cwd = cwd + '/'
    listFiles()
    
  
listFiles = ->  
  now.listFiles cwd, (files) ->
    console.log 'listfiles returned'
    showFiles files

    
getlink = ->
  url = $('#loadfromurl').val()
  now.loadAndUncompress url, cwd, (err) ->
    $('#loadfromurl').val ''
    listFiles()
    

window.doneUploading = ->
  $('#fileman iframe').attr 'src', '/dyn/upframe'
  listFiles()
  
  
$ ->
  $('#objs').prepend '<button id=\"openfm\" class=\"white button\">File Manager</button>'
  $('#openfm').click ->
    $('#fileman').dialog
      title: 'File Manager'
      width: 600
      height: 495
    $('#upframe').show()  
    listFiles()
    
  $('#refreshdir').click listFiles
  
  $('#getlink').click getlink
  