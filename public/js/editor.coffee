#testing
editor = undefined
editorhtml = undefined
editorbrowser = undefined
editornodejs = undefined
editorcss = undefined

initialized = false

thing = () ->

editWidget = (widget) -> 
  $('#widgetname').data 'mode', 'update'
  $('#widgetname').val widget.name
  window.createCookie 'lastScreen', widget.name
  $('.demo').dialog 'option', 'title', widget.name
  editorbrowser.setValue widget.browser
  editornodejs.setValue widget.nodejs
  editorhtml.setValue widget.html
  editorcss.setValue widget.css

initeditortabs =  ->
  if initialized then return
  initialized = true
  editorhtml = CodeMirror.fromTextArea $("#html")[0],
    mode: "text/html"
    lineNumbers: true
  editorbrowser = CodeMirror.fromTextArea $("#browser")[0],
    mode: "coffeescript"
    lineNumbers: true
  editornodejs = CodeMirror.fromTextArea $("#nodejs")[0],
    mode: "coffeescript"
    lineNumbers: true
  editorcss = CodeMirror.fromTextArea $("#css")[0],
    mode: "text/css"
    lineNumbers: true
  lastScreen = window.readCookie 'lastScreen'
  if lastScreen?
    now.getWidgetData lastScreen, (widgetdata, err) -> 
      if err?
        alert 'Error loading widget data: ' + err.message
      else
        editWidget widgetdata    

  
makeEditable = ->
  $.contextMenu
    selector: '.compmenu'
    trigger: 'hover'
    autoHide: false
    callback: (key, options, e) ->
      el = window.lastMenuEvent.currentTarget
      name = $(el).parent().find('.compname').text()

      switch key
        when 'delete'
          if window.confirm "Delete #{name}? (Can't be undone!)"
            now.deleteComponent name, (success, err) ->
              if err?
                alert 'Failed: ' + err.message
              else
                $('.demo').html 'Component was deleted.  Reloading application..'
                window.delay 2000, -> window.location.reload()
                now.restartServer()
          
          else
            console.log "Not deleting"
          
        when 'copy'          
          now.copyComponent name, (success, err) ->
            if not err?
              $('.demo').html "#{name} copied successfully. Reloading application."              
              window.delay 2000, -> window.location.reload()
            else
              alert 'Error copying component: ' + err.message
            
        when 'edit' 
          now.getWidgetData name, (widgetdata, err) ->      
            if err?
              alert 'Error loading widget data: ' + err.message
            else
              editWidget widgetdata
              
        when 'rename'
        	$(el).parent().find('.compname').attr('contenteditable', true).focus().select().blur ->
              now.renameComponent name, $(el).parent().find('.compname').text()

      true

    items:
      "edit": {name: "Edit Code", icon: "edit"}  
      "rename": {name: "Rename", icon: "edit"}
      "copy": {name: "Make a Copy", icon: "copy"}
      "delete": {name: "Delete", icon: "delete"}
      
window.savePage = ->
  console.log 'saving html: ' + $('#page').html()
  now.saveStatic 'page', $('#page').html()

loadwidgets = ->
  $('#page').droppable
    drop: (ev, ui) ->
      name = ui.draggable.data 'name'
      $('#page').trigger 'drop', [ev, ui, @];

  now.listComponents (components) ->
    str = ''
    for component in components
      checked = ''
      if component.active then checked = 'checked="checked"'
      check = '<input type="checkbox" ' + checked + '/>'
      str += "<li>#{check}&nbsp;<span class=\"compname\">#{component.name}</span><span class=\"compmenu\">▼</span></li>"
    $('#components').html str  
    $('.compname').click ->
      now.getWidgetData $(@).text(), (widgetdata, err) ->      
        if err?
          alert 'Error loading widget data: ' + err.message
        else
          editWidget widgetdata
  
  makeEditable()

$ ->
  $('body').prepend $('#editorui')
  $('#objs').height $(window).height()
  
  $('#tabs').tabs
    show: (event, ui) ->
      if editorhtml? then editorhtml.refresh()
      if editorbrowser? then editorbrowser.refresh()
      if editorcss? then editorcss.refresh()
      if editornodejs? then editornodejs.refresh()

  $('#savewidget').click -> 
    data =
      name: $('#widgetname').val()
      browser: editorbrowser.getValue()
      html: editorhtml.getValue()
      css:  editorcss.getValue()
      nodejs:  editornodejs.getValue()

    now.saveWidgetData data, ->
      $('.demo').html 'Your edits have been saved.  Reloading application..'
      setTimeout ( -> window.location.reload() ), 2000

    active = []
    $('#components li').each ->
      if $(@).find('input').is(':checked')
        active.push $(@).find('.compname').text()
    now.setActiveComponents active                                          
      
    now.restartServer()

  now.ready ->
    loadwidgets()
    $('#objs').prepend '<button id="editcode" class="button white">Code Editor</button>'
    $('#editcode').click ->
      $('.demo').dialog
        title: name + ' component - Code Editor' 
        position: 'top'
        height: $(window).height() * .9
        width: $(window).width() * .7

      window.delay 500, ->      
        $(".ui-tabs-panel").height $(window).height() * .7
        $(".CodeMirror").height $(window).height() * .65
        window.delay 500, ->
          $(".CodeMirror-scroll").height $(window).height() * .7
          
      initeditortabs()

