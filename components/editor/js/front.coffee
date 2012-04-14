editor = undefined
editorhtml = undefined
editorcode = undefined
editorcss = undefined

loadwidget = (data) ->
  try
    $('#widgets').append data.html
    $('head').append "<style>#{data.css}</style>"
    $('head').append "<script>#{data.code}</script>"
    deswidget = $("<li class=\"deswidget\">#{data.name}</li>")
    deswidget.data 'name', data.name
    deswidget.data 'widget', data
    $('#objlist').append deswidget
  catch e
    console.log e

thing = () ->

editWidget = (widget) ->
  $('#widgetname').data 'mode', 'update'
  $('#widgetname').val widget.name
  $('#code').val widget.code
  $('#html').val widget.html
  $('#css').val widget.css

  
makeEditable = ->
  $.contextMenu
    selector: '.deswidget'
    trigger: 'right'
    callback: (key, options, e) ->
      el = window.lastMenuEvent.currentTarget
      switch key
        when 'delete' then console.log 'delete'
          
        when 'copy'
          console.log el
        when 'edit' 
          name = $(el).data 'name'
          editWidget $(el).data 'widget'
          $('.demo').dialog
            height: '450'
            width: '900'
          widgetdata = $(el).data 'widget'  
          editorhtml = CodeMirror.fromTextArea $("#html")[0],
            value: widgetdata.html 
            mode: "text/html"
            lineNumbers: true
          editorcode = CodeMirror.fromTextArea $("#code")[0],
            value: widgetdata.code 
            mode: "text/javascript"
            lineNumbers: true
          editorcss = CodeMirror.fromTextArea $("#css")[0],
            value: widgetdata.css 
            mode: "text/css"
            lineNumbers: true

      true
   
    items:
      "delete": {name: "Delete", icon: "delete"}
      "copy": {name: "Copy", icon: "copy"}
      "edit": {name: "Edit Code", icon: "edit"}

$('#savewidget').click ->
  data =
    name: $('#widgetname').val()
    code: editorcode.getValue()
    html: editorhtml.getValue()
    css:  editorcss.getValue()

  mode = $('#widgetname').data 'mode'
  if mode is 'update'
    now.dbupdate 'widgets', { name: data.name }, data
  else
    now.dbinsert 'widgets', data


loadwidgets = ->
  $('.deswidget').draggable
    helper: 'clone'
  $('#page').droppable
    drop: (ev, ui) ->
      name = ui.draggable.text()
      console.log 'name is ' + name
      $('head').append("<script>window.newobj = new #{name}</script>")
      window.newobj.init
        parent: $('#page')
        data: {test:'blah'} 
      window.newobj.render()

  makeEditable()

$ ->
 $('body').prepend $('#editorui')
 $('#tabs').tabs
   show: (event, ui) ->
     if editorhtml? then editorhtml.refresh()
     if editorcode? then editorcode.refresh()
     if editorcss? then editorcss.refresh()

 now.ready ->
    loadwidgets()

