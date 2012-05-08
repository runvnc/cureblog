class IPWTextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="ipwtextwidget widgetcontainer sizewidget" id ="'+@id+'"><div class="ipweditable">The quick brown fox jumped.</div></div>')
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
        
    $(idx).draggable()
      stop: (ev) ->
        ev.stopPropagation()
    
    oFCKeditor = new FCKeditor('editor1')
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"   
    
    $(idx).find('.ipweditable').editable
      type: 'wysiwyg'
      editor: oFCKeditor       
      submit:'save',
      cancel:'cancel'
      #onSubmit: (content) ->
      #  #$('#editor1').remove()
      #  #window.delay 200, ->
      #  #  window.savePage()       
      
          
    #$('#'+@id).live 'blur', ->  
    #  window.savePage()
  

    

    #    console.log 'drag stop'
    #    console.log 'saving page'
    #    window.savePage()
    #) .bind 'click', (ev) ->
    
      #if not (ev.target.id is eid)        
      #  return
      #else
      #  window.delay 1400, ->
      #    $('#'+eid).css 'minWidth', '550px'
      #  console.log 'its ok target id is ' + ev.target.id
      #$(@).cleditor()
      #$(this).focus()
      #ev.stopPropagation()
      #ev.preventDefault()
      
  
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
      if $('#editor1___Frame').is(':visible') then return
      if ev.offsetX?
        x = ev.offsetX
        y = ev.offsetY
      else
        x = ev.pageX - $('#page')[0].offsetLeft
        y = ev.pageY - $('#page')[0].offsetTop
      if @active
        text = new IPWTextWidget($('#page'), x, y)      
      window.savePage()
      
        
    $('#objlist').append widget  
    console.log 'appended'
    
    
$ ->
  window.IPWTextTool = new IPWTextTool()
  
  $('.ipwtextwidget').each ->    
    if $(this)?
      console.log 'creating IPWTextWidget'
      x = $(this).position().left
      y = $(this).position().top
      text = new IPWTextWidget($('#page'), x, y, $(this).attr('id'))
    else
      console.log '$(this)? false skipping'

window.saveFilters.push (sel) ->      
  console.log 'saveFilter'
  $(sel).find('.ui-resizable-handle').remove()
  $(sel).find('.ipwtextwidget button').remove()
  $(sel).find('#editor1___Frame').remove()
  $(sel).find('#editor1___Config').remove()
  $(sel).find('#editor1').remove()
        
