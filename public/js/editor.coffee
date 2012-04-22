editor = undefined
editorhtml = undefined
editorcode = undefined
editorcss = undefined

thing = () ->

editWidget = (widget) ->
  $('#widgetname').data 'mode', 'update'
  $('#widgetname').val widget.name
  $('#coffee').val widget.coffee
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
          console.log 'el is '
          console.log el
          name = $(el).data 'name'
          console.log 'editing name is ' + name
          now.getWidgetData name, (widgetdata) -> 
            editWidget widgetdata
            $('.demo').dialog
              height: 'auto'
              width: '900'
            widgetdata = $(el).data 'widget'  
            editorhtml = CodeMirror.fromTextArea $("#html")[0],
              value: widgetdata.html 
              mode: "text/html"
              lineNumbers: true
            editorcode = CodeMirror.fromTextArea $("#coffee")[0],
              value: widgetdata.coffee
              mode: "coffeescript"
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

window.savePage = ->
  console.log 'saving html: ' + $('#page').html()
  now.saveStatic 'page', $('#page').html()

loadwidgets = ->
  $('#page').droppable
    drop: (ev, ui) ->
      name = ui.draggable.data 'name'
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

  $('#savewidget').click ->
    console.log 'you clicked savewidget' 
    data =
      name: $('#widgetname').val()
      coffee: editorcode.getValue()
      html: editorhtml.getValue()
      css:  editorcss.getValue()

    now.saveWidgetData data, ->
      alert 'Saved'

    now.restartServer()

 now.ready ->
    console.log 'now.ready fired'
    loadwidgets()

