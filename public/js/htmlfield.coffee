
class HtmlFieldWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      htmlfieldhtml = $('#htmlfieldwidgettemplate').html()
      @htmlfield = $(htmlfieldhtml)    
      @htmlfield.css 'position', 'absolute'
      @htmlfield.css 'top', position.top + 'px'
      @htmlfield.css 'left', position.left + 'px'
      parent.append @htmlfield
    else
      @htmlfield = widget
      
    try
      @htmlfield.resizable()
      @htmlfield.draggable()
    catch e
    
    @obj = @htmlfield
    @htmlfield.data 'widget', this
    @htmlfield[0].widget = this
    @htmlfield.widget = this
    if window.loggedIn
      @htmlfield.find('.rename').off 'click'
      @htmlfield.find('.rename').on 'click', =>
        name = prompt 'Enter field name'
        @htmlfield.attr 'data-fieldname', name
        @showname()
        
      @showname()
    else
      @displaymode()
      
    console.log 'htmlfield constructor done'
  
  blank: =>
    'New'
    
  showname: ->
    @obj.find('.fieldname').html @obj.attr 'data-fieldname'
    
  designmode: (record) ->
    @htmlfield.find('.htmleditarea').html 'Rich Text Field'
    @htmlfield.find('.htmleditarea').editable 'disable'
    
    
  display: (record) ->  
    name = @obj.attr 'data-fieldname'
    @htmlfield.find('.htmleditarea').html record[name]
    
  displaymode: ->
    @htmlfield.find('.rename,.fieldname').hide()
    @htmlfield.css 'border', 'none'
    
  edit: (record) ->
    name = @obj.attr 'data-fieldname'
    @htmlfield.find('.htmleditarea').html record[name]
    oFCKeditor = new FCKeditor('editor1')
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"   
    
    @htmlfield.find('.htmleditarea').editable
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

          
        
class HtmlFieldTool
  constructor: ->
    widgethtml = $('#htmlfieldtemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'htmlfieldcollector'
    data = 
      name: 'htmlfieldcollector'
    btn.data 'widget', data    
    $('#advobjlist').append widget 
    
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
        new HtmlFieldWidget($('.activewidget'), p, false)
    
    
$ ->
  $(document).bind 'sessionState', (user) ->    
    if window.loggedIn
      window.HtmlFieldTool = new HtmlFieldTool()
    $('.htmlfieldall').each ->
      if $(@)?      
        x = $(@).position().left
        y = $(@).position().top
        text = new HtmlFieldWidget($(this).parent(),$(this).position(), true, $(this)) 
      
      