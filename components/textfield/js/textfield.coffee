
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
    @textfield[0].widget = this
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
    @textfield.find('.textinput').val record[name]
    @textfield.find('.texthtmleditarea').hide()
    @textfield.find('.textinput').off 'blur'
    @textfield.find('.textinput').on 'blur', ->
      record[name] = $(this).val()

  display: (record) ->  
    name = @obj.attr 'data-fieldname'
    template = @textfield.find('.texthtmleditarea').html()
    newhtml = template.replace '{{'+name+'}}', record[name]
    @textfield.find('.texthtmleditarea').html newhtml
    @textfield.find('.rename,.fieldname').hide()
    @textfield.css 'border', 'none'
    
      
  designmode: ->    
    name = @obj.attr 'data-fieldname'
    @textfield.find('.textinput').hide()
    currhtml = @textfield.find('.texthtmleditarea').html()
    if currhtml.indexOf('{{') < 0
      @textfield.find('.texthtmleditarea').html '{{' + name + '}}'
    @textfield.find('.texthtmleditarea').show()
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
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.TextFieldTool = new TextFieldTool()
    $('.textfieldall').each ->    
      if $(@)?      
        x = $(@).position().left
        y = $(@).position().top
        text = new TextFieldWidget($(this).parent(),$(this).position(), true, $(this))  
        
      