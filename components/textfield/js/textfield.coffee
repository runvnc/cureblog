
class TextFieldWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      textfieldhtml = $('#textfieldwidgettemplate').html()
      @textfield = $(textfieldhtml)    
      @textfield.css 'position', 'absolute'
      @textfield.css 'top', position.top + 'px'
      @textfield.css 'left', position.left + 'px'
      parent.append @textfield
    else
      @textfield = widget
      
    try
      @textfield.resizable()
      @textfield.draggable()
    catch e
    
    @obj = @textfield
    @textfield.data 'widget', this
    @textfield.widget = this
    @textfield.find('.rename').off 'click'
    @textfield.find('.rename').on 'click', =>
      name = prompt 'Enter field name'
      @textfield.attr 'data-fieldname', name
      @showname()
      
    @showname()
    if window.loggedIn
      @designmode()
    
  showname: ->
    @obj.find('.fieldname').html @obj.attr 'data-fieldname'
    
  edit: (record) ->
    name = @obj.attr 'data-fieldname'
    @textfield.find('.textinput').show()
    @textfield.find('.textinput').off 'blur'
    @textfield.find('.textinput').on 'blur', ->
      record[name] = $(this).val()

  display: (record) ->  
    name = @obj.attr 'data-fieldname'
    template = @htmlfield.find('.texthtmleditarea').html()
    newhtml = template.replace '{{'+name+'}}', record[name]
    @htmlfield.find('.texthtmleditarea').html newhtml
    
      
  designmode: ->    
    @textfield.find('.textinput').hide()
    @textfield.find('.texthtmleditarea').html '{{' + name + '}}'
    oFCKeditor = new FCKeditor('editor1')
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"       

    @textfield.find('.texthtmleditarea').editable
      type: 'wysiwyg'
      editor: oFCKeditor       
      submit:'save',
      cancel:'cancel'
      onEdit: (content) ->
        window.alreadyEditing = true
      onSubmit: (content) ->
        record[name] = content.current        
        window.alreadyEditing = false
      onCancel: (content) ->
        window.alreadyEditing = false    
  
class TextFieldTool
  constructor: ->
    widgethtml = $('#textfieldtemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'textfieldcollector'
    data = 
      name: 'textfieldcollector'
    btn.data 'widget', data    
    $('#objlist').append widget 
    
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
        new TextFieldWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.textfieldall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new TextFieldWidget($(this).parent(),$(this).position(), true, $(this))  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.TextFieldTool = new TextFieldTool()
      
      