cwd = '.'


sortem = (files) ->
  files.sort (a, b) ->
    if a.isDirectory
      return -1
    else
      return a.name - b.name
  files   


showFiles = (files) ->
  str = ''
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
    if cwd is '.' then cwd = './'
    cwd += $(this).text()
    console.log 'new dir is ' + cwd
    listFiles()
    
  
listFiles = ->
  console.log 'calling listfiles'
  now.listFiles cwd, (files) ->
    console.log 'listfiles returned'
    showFiles files


window.doneUploading = ->
  $('#fileman iframe').attr 'src', '/dyn/upframe'
  listFiles()
  
$ ->
  $('#objs').prepend '<button id=\"openfm\" class=\"white button\">File Manager</button>'
  $('#openfm').click ->
    $('#fileman').dialog
      title: 'File Manager'
      width: 600
      height: 450
      
    listFiles()
    
  $('#refreshdir').click listFiles