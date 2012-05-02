class RichTextWidget
  constructor: (@parent, @x, @y, @id) ->      
    if not @id?
      @id = guid()
      @el = $('<div class="richtextwidget" id ="'+@id+'">rt</div>')
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
        #$(this).find('.topofwidget').remove()
        window.savePage()
    ).bind 'click', (ev) ->
      if not (ev.target.id is eid)        
        return
      else
        console.log 'its ok target id is ' + ev.target.id
      console.log 'click event'
      $('#'+eid).ckeditor()
      $(this).focus()
      ev.stopPropagation()
      ev.preventDefault()
  
class RichTextTool
  constructor: ->
    @active = false
    widgethtml = $('#richtexttemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'text'
    data = 
      name: 'text'
    btn.data 'widget', data
      
    $('.richtexttool').live 'click', =>
      if !@active
        @boxShadow = $('.richtexttool.toolbutton').css 'boxShadow'
        $('.richtexttool.toolbutton').css 'boxShadow', 'none';
        $('.richtexttool.toolbutton').addClass 'active'
        @active = true
      else
        $('.richtexttool.toolbutton').css 'boxShadow', @boxShadow;
        $('.richtexttool.toolbutton').removeClass 'active'
        @active = false
        
    
    $('#page').bind 'click', (ev) =>
      if ev.offsetX?
        x = ev.offsetX
        y = ev.offsetY
      else
        x = ev.pageX - $('#page')[0].offsetLeft
        y = ev.pageY - $('#page')[0].offsetTop
      if @active
        text = new RichTextWidget($('#page'), x, y)      
      
      window.savePage()
        
    $('#objlist').append widget  
    console.log 'appended'
    
$ ->
  window.richtextTool = new RichTextTool()

                                        