window.editorNum = 1

class IPWTextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="ipwtextwidget widgetcontainer" id ="'+@id+'"><div class="ipweditable">The quick brown fox jumped.</div></div>')
      idx = '#' + @id
      @parent.append @el
      @el.css
        position: 'absolute'
        top: @y + 'px'
        left: @x + 'px'          
    else
      @el = $(@id)
      idx = '#' + @id
    
    $(idx).resizable()
        
    $(idx).draggable
      stop: (ev) ->
        ev.stopPropagation()
          
    oFCKeditor = new FCKeditor('editor1') # + window.editorNum++)
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"   
    
    $(idx).find('.ipweditable').editable
      type: 'wysiwyg'
      editor: oFCKeditor       
      submit:'save',
      cancel:'cancel'
      onEdit: (content) ->
        window.alreadyEditing = true
      onSubmit: (content) ->
        window.alreadyEditing = false
      onCancel: (content) ->
        window.alreadyEditing = false
              
  
class IPWTextTool
  constructor: ->
    @active = false
    widgethtml = $('#ipwtexttemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'text'
    data = 
      name: 'text'
    btn.data 'widget', data
    
    
    $('.ipwtexttool').live 'click', =>
      if !@active
        @boxShadow = $('.ipwtexttool.toolbutton').css 'boxShadow'
        $('.ipwtexttool.toolbutton').css 'boxShadow', 'none';
        $('.ipwtexttool.toolbutton').addClass 'active'
        @active = true
      else
        $('.ipwtexttool.toolbutton').css 'boxShadow', @boxShadow;
        $('.ipwtexttool.toolbutton').removeClass 'active'
        @active = false
        
    
    $('#page').bind 'click', (ev) =>
      if not ev.target is $('#page')[0] then return
      if window.alreadyEditing then return
      if $('#editor1___Frame').is(':visible') then return
      if ev.offsetX?
        x = ev.offsetX
        y = ev.offsetY
      else
        x = ev.pageX - $('#page')[0].offsetLeft
        y = ev.pageY - $('#page')[0].offsetTop
      if @active
        text = new IPWTextWidget($('#page'), x, y)            
      
        
    $('#objlist').append widget  
    console.log 'appended'
    
    
$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.IPWTextTool = new IPWTextTool()
      
      $('.ipwtextwidget').each ->    
        if $(@)?
          console.log 'creating IPWTextWidget'
          x = $(@).position().left
          y = $(@).position().top
          text = new IPWTextWidget($('#page'), x, y, $(@).attr('id'))
        else
          console.log '$(this)? false skipping'

window.saveFilters.push (sel) ->      
  $(sel).find('.ui-resizable-handle').remove()
  $(sel).find('.ipwtextwidget button').remove()
  $(sel).find('.sizewidget').removeClass 'sizewidget'
  $(sel).find('#editor1___Frame').remove()
  $(sel).find('#editor1___Config').remove()
  $(sel).find('#editor1').remove()
  $(sel).find('#editor2___Frame').remove()
  $(sel).find('#editor2___Config').remove()
  $(sel).find('#editor2').remove()  
  $(sel).find('#editor3___Frame').remove()
  $(sel).find('#editor3___Config').remove()
  $(sel).find('#editor3').remove()  
  $(sel).find('#editor4___Frame').remove()
  $(sel).find('#editor4___Config').remove()
  $(sel).find('#editor4').remove()  
  $(sel).find('#editor5___Frame').remove()
  $(sel).find('#editor5___Config').remove()
  $(sel).find('#editor5').remove()  
  $(sel).find('#editor6___Frame').remove()
  $(sel).find('#editor6___Config').remove()
  $(sel).find('#editor6').remove()  
        
