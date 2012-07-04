window.editorNum = 1

class IPWTextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="ipwtextwidget widgetcontainer" id ="'+@id+'" ><div class="textmove"></div><div class="ipweditable">The quick brown fox jumped...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/></div></div>')
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
    
    hoveron = ->
      if not window.alreadyEditing
        $(this).find('.textmove').show()
    hoveroff = ->
      $(this).find('.textmove').hide()
    $(idx).hover hoveron, hoveroff
          
    oFCKeditor = new FCKeditor('editor1') # + window.editorNum++)
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"   
    
    $(idx).find('.ipweditable').editable
      type: 'wysiwyg'
      editor: oFCKeditor       
      submit:'save',
      cancel:'cancel'
      onEdit: (content) ->
        $(idx).find('.textmove').hide()
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
    
    widget.draggable
      helper: 'clone'
      stop: (ev, ui) ->
        p = {}
        if ev.offsetX?
          p.left = ev.offsetX
          p.top = ev.offsetY
        else
          p.left = ev.pageX - $(ev.target).offsetLeft
          p.top = ev.pageY - $(ev.target).offsetTop
        new IPWTextWidget($('.activewidget'), p.left, p.top)    

    $('#objlist').append widget      
        
    #$('.ipwtexttool').live 'click', =>
    #  if !@active
    #    @boxShadow = $('.ipwtexttool.toolbutton').css 'boxShadow'
    #    $('.ipwtexttool.toolbutton').css 'boxShadow', 'none';
    #    $('.ipwtexttool.toolbutton').addClass 'active'
    #    @active = true
    #  else
    #    $('.ipwtexttool.toolbutton').css 'boxShadow', @boxShadow;
    #    $('.ipwtexttool.toolbutton').removeClass 'active'
    #    @active = false
                
        
    #$('#page, .pagescontent, .widgetcontent').bind 'click', (ev) =>
    #  ispage = (ev.target.className.indexOf('pagescontent') >= 0) 
    #  iswidget = (ev.target.className.indexOf('widgetcontent') >= 0)
    #  if not (ev.target is $('#page')[0] or ispage or iswidget) then return
    #  if window.alreadyEditing then return
    #  if $('#editor1___Frame').is(':visible') then return
    #  if ev.offsetX?
    #    x = ev.offsetX
    #    y = ev.offsetY
    #  else
    #    x = ev.pageX - $(ev.target).offsetLeft
    #    y = ev.pageY - $(ev.target).offsetTop
    #  if @active
    #    text = new IPWTextWidget($(ev.target), x, y)            
      
    
    
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
        
