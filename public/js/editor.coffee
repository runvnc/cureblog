editor = undefined
editorhtml = undefined
editorcode = undefined
editorcss = undefined

initialized = false

thing = () ->

editWidget = (widget) ->
  $('#widgetname').data 'mode', 'update'
  $('#widgetname').val widget.name
  $('#coffee').val widget.coffee
  $('#html').val widget.html
  $('#css').val widget.css

initeditortabs = (widgetdata) ->
  initialized = true
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
          now.copyComponent($(el).data('name'), -> window.location.reload())
        when 'edit' 
          name = $(el).data 'name'
          now.getWidgetData name, (widgetdata) -> 
            editWidget widgetdata
            $('.demo').dialog
              title: name + ' component - Code Editor' 
              position: 'top'
              height: 'auto'
              width: '900'
            widgetdata = $(el).data 'widget'  
            if not initialized
              initeditortabs widgetdata
            else
              editorcode.setValue widgetdata.coffee
              editorhtml.setValue widgetdata.html
              editorcss.setValue widgetdata.css
      true
   
    items:
      "delete": {name: "Delete", icon: "delete"}
      "copy": {name: "Make a Copy", icon: "copy"}
      "edit": {name: "Edit Code", icon: "edit"}

window.savePage = ->
  console.log 'saving html: ' + $('#page').html()
  now.saveStatic 'page', $('#page').html()

loadwidgets = ->
  $('#page').droppable
    drop: (ev, ui) ->
      name = ui.draggable.data 'name'
      $('#page').trigger 'drop', [ev, ui, @];
      
  makeEditable()

$ ->
 $('body').prepend $('#editorui')
 $('#objs').height($(window).height());
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

