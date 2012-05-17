cwd = '.'
      
  
sortem = (files) ->
  files.sort (a, b) ->
    if a.isDirectory
      return -1
    else
      if a.name < b.name
        return -1
      else if a.name is b.name
        return 0
      else
        return 1
  files   


deleteSelected = ->
  todel = []
  $('.fmselected').each ->
    todel.push $(this).text()
  if confirm "Delete #{todel.length} files/directories??"
    now.deleteFiles todel, cwd, ->
      listFiles()
  
  
shiftSel = (e, th) ->
  selIndex = $('.fmselected').index()
  clickedIndex = $(th).index()
  min = Math.min selIndex, clickedIndex
  max = Math.max selIndex, clickedIndex
  
  $('.fmselected').each ->
    min = Math.min min, $(this).index()
    max = Math.max max, $(this).index()
     
  $('.fmitem').removeClass 'fmselected'
  for i in [min..max]
    $("#fsroot li:eq(#{i})").addClass 'fmselected'
  
  
showFiles = (files) ->
  console.log '**** FileManager showFiles ****'
  str = '<li class=\"fmitem fmupdir\">..</li>'
  sortem files
  for file in files
    listing = file.name
    classnm = "fmfile"
    if file.isDirectory
      listing += '/'
      classnm = "fmdir"
    str += "<li class=\"fmitem #{classnm}\">#{listing}</li>"
    
  $('#fsroot').html str
  
  $('.fmdir').dblclick ->    
    if cwd is '.' then cwd = './'
    cwd += $(this).text()
    listFiles()
    
  $('.fmupdir').dblclick ->
    dirs = cwd.split '/'
    newdirs = []
    for d in dirs
      if d isnt ''
        newdirs.push d

    newdirs.splice newdirs.length-1, 1
    cwd = newdirs.join '/'
    cwd = cwd + '/'
    listFiles()
    
  $('.fmitem').click (e) ->
    if e.ctrlKey
      $(this).addClass 'fmselected'
    else if e.shiftKey
      shiftSel e, this
    else
      $('.fmitem').removeClass 'fmselected'
      $(this).addClass 'fmselected'
      
  $('#deletesel').click deleteSelected
  
  
listFiles = ->  
  now.listFiles cwd, (files) ->
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
      width: 870
      height: $(window).height() *.9
    $('#upframe').show()  
    $('#fileswin').height $(window).height() * .75
    listFiles()
    
    
  $('#refreshdir').click listFiles
  
  $('#getlink').click getlink
  