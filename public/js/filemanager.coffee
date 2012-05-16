#file manager
#I need a way to upload an icon
#for the image plugin
#actually I don't have to upload anything
#since its on my hard disk
#but if it wasn't
#I would be stuck
#until I got scp or something set up

#how would I add a request handler to app
#anything that starts with /dyn will be ignored
#so I just use process.app.on 'request'

  
$ ->
  $('#objs').prepend '<button id=\"openfm\" class=\"white button\">File Manager</button>'
  $('#openfm').click ->
    $('#uploadform').dialog()