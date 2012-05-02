class CLTextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<textarea class="cltextwidget" id ="'+@id+'">text</textarea>')
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
        window.savePage()
    ).bind 'click', (ev) ->
      if not (ev.target.id is eid)        
        return
      else
        console.log 'its ok target id is ' + ev.target.id
      $(@).cleditor()
      $(this).focus()
      ev.stopPropagation()
      ev.preventDefault()
      
  
class CLTextTool
  constructor: ->
    @active = false
    widgethtml = $('#cltexttemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'text'
    data = 
      name: 'text'
    btn.data 'widget', data
      
    $('.cltexttool').live 'click', =>
      if !@active
        @boxShadow = $('.cltexttool.toolbutton').css 'boxShadow'
        $('.cltexttool.toolbutton').css 'boxShadow', 'none';
        $('.cltexttool.toolbutton').addClass 'active'
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
        text = new CLTextWidget($('#page'), x, y)      
      window.savePage()
        
    $('#objlist').append widget  
    console.log 'appended'
    
    
$ ->
  window.textTool = new CLTextTool()
  $('.cltextwidget').each ->
    x = $(this).position().left
    y = $(this).position().top
    text = new CLTextWidget($('#page'), x, y, $(this).attr('id'))
                                        
