class TextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="textwidget" contenteditable="true" id ="'+@id+'"><div class="topofwidget">(      )</div>text</div>')
      idx = '#' + @id
      @parent.append @el
      @el.css
        position: 'absolute'
        top: @y + 'px'
        left: @x + 'px'      
      window.savePage()
    else
      @el = $(@id)
          
    $('.textwidget').live 'blur', ->  
      window.savePage()
  
    $('.textwidget').draggable(
      stop: ->
        $(this).find('.topofwidget').hide()
        window.savePage()
    ).bind 'click', ->
      $(this).find('.topofwidget').show().css('color', 'red')
      $(this).focus()
    
  
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
        
    $('#objlist').append widget  
    console.log 'appended'
    
    
$ ->
  window.textTool = new TextTool()
  $('.textwidget').each ->
    x = $(this).position().left
    y = $(this).position().top
    text = new TextWidget($('#page'), x, y, $(this).attr('id'))
                                        
