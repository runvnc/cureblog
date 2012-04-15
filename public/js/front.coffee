editor = undefined
editorhtml = undefined
editorcode = undefined
editorcss = undefined

thing = () ->

editWidget = (widget) ->
  $('#widgetname').data 'mode', 'update'
  $('#widgetname').val widget.name
  $('#code').val widget.code
  $('#html').val widget.html
  $('#css').val widget.css

  
makeEditable = ->
  $.contextMenu
    selector: '.designwidget'
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
  console.log 'inside of loadwidgets'
  console.log $('.designwidget')

  $('#page').droppable
    drop: (ev, ui) ->
      console.log 'inside of drop'
      console.log ui
      name = ui.draggable.data 'name'
      console.log 'name is ' + name
      if window.drophandlers[name]?
        window.drophandlers[name] ev, ui, @
      
  makeEditable()

$ ->
 $('body').prepend $('#editorui')
 $('#tabs').tabs
   show: (event, ui) ->
     if editorhtml? then editorhtml.refresh()
     if editorcode? then editorcode.refresh()
     if editorcss? then editorcss.refresh()

 now.ready ->
    console.log 'now.ready fired'
    loadwidgets()

