class TextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="textwidget" contenteditable="true" id ="'+@id+'">text</div>')
      idx = '#' + @id
      @parent.append @el
      @el.css
        position: 'absolute'
        top: @y + 'px'
        left: @x + 'px'      
      window.savePage()
    else
      @el = $(@id)
          
    $('#'+@id).live 'blur', ->  
      window.savePage()
  
    eid = @id
    $('#'+@id).draggable(
      stop: ->
        $(this).find('.topofwidget').remove()
        window.savePage()
    ).bind 'click', (ev) ->
      if not (ev.target.id is eid)        
        return
      else
        console.log 'its ok target id is ' + ev.target.id
      console.log 'click event'
      $(this).find('.topofwidget').remove()
      $(this).prepend $('#fonttemplate').html()
      $(this).find('.font').off 'change'
      $(this).find('.font').on 'change', ->
        console.log '4444444444444444 selected val is ' + $(this).val()
        window.document.execCommand 'fontname',false, $(this).val()
        ev.stopPropagation()
        
      $(this).focus()
      ev.stopPropagation()
      ev.preventDefault()
      
  
class TextTool
  constructor: ->
    @active = false
    widgethtml = $('#texttemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'text'
    data = 
      name: 'text'
    btn.data 'widget', data
      
    $('.texttool').live 'click', =>
      if !@active
        @boxShadow = $('.texttool.toolbutton').css 'boxShadow'
        $('.texttool.toolbutton').css 'boxShadow', 'none';
        $('.texttool.toolbutton').addClass 'active'
        @active = true
      else
        $('.texttool.toolbutton').css 'boxShadow', @boxShadow;
        $('.texttool.toolbutton').removeClass 'active'
        @active = false
        
    
    $('#page').bind 'click', (ev) =>
      if ev.offsetX?
        x = ev.offsetX
        y = ev.offsetY
      else
        x = ev.pageX - $('#page')[0].offsetLeft
        y = ev.pageY - $('#page')[0].offsetTop
      if @active
        text = new TextWidget($('#page'), x, y)      
      $('.topofwidget').remove()
      window.savePage()
        
    $('#objlist').append widget  
    console.log 'appended'
    
    
$ ->
  window.textTool = new TextTool()
  $('.textwidget').each ->
    x = $(this).position().left
    y = $(this).position().top
    text = new TextWidget($('#page'), x, y, $(this).attr('id'))
                                        
