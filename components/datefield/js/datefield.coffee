
class DateFieldWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      datefieldhtml = $('#datefieldwidgettemplate').html()
      @datefield = $(datefieldhtml)    
      @datefield.css 'position', 'absolute'
      @datefield.css 'top', position.top + 'px'
      @datefield.css 'left', position.left + 'px'
      parent.append @datefield
    else
      @datefield = widget
      
    try
      @datefield.resizable()
      @datefield.draggable()
    catch e
    
    @obj = @datefield
    @datefield.data 'widget', this
    @datefield[0].widget = this
    @datefield.widget = this
    @datefield.find('.rename').off 'click'
    @datefield.find('.rename').on 'click', =>
      name = prompt 'Enter field name'
      @datefield.attr 'data-fieldname', name
      @showname()
      
    @showname()
    if window.loggedIn
      @designmode()
    
  showname: ->
    name = @obj.attr 'data-fieldname'
    @obj.find('.fieldname').html name
    template = @datefield.find('.datetimeeditarea').html()
    newhtml = template.replace /\{\{[a-z0-9]*\}\}/i, '{{'+name+'}}'
    @datefield.find('.datetimeeditarea').html newhtml
    
  
  blank: =>
    new Date()
  
  edit: (record) ->
    name = @obj.attr 'data-fieldname'
    @datefield.find('.dateinput').show()
    @datefield.find('.datetimeeditarea').hide()
    record[name] = new Date()
    @datefield.find('.dateinput').val record[name]
    @datefield.find('.datetimeeditarea').hide()
    @datefield.find('.dateinput').off 'blur'
    @datefield.find('.dateinput').on 'blur', ->
      record[name] = $(this).val()

  display: (record) ->  
    name = @obj.attr 'data-fieldname'
    template = @datefield.find('.datetimeeditarea').html()
    txt = dateFormat record[name], "dddd, mmmm dS, yyyy, h:MM:ss TT"
    newhtml = template.replace '{{'+name+'}}', txt
    @datefield.find('.datetimedisplay').html newhtml
    @datefield.find('.datetimeeditarea').hide()
    @datefield.find('.rename,.fieldname').hide()
    @datefield.css 'border', 'none'
    
      
  designmode: ->    
    name = @obj.attr 'data-fieldname'
    @datefield.find('.dateinput').hide()
    currhtml = @datefield.find('.datetimeeditarea').html()
    if currhtml.indexOf('{{') < 0 or currhtml.indexOf('{{undefined}}') > 0
      @datefield.find('.datetimeeditarea').html '{{' + name + '}}'
    @datefield.find('.datetimeeditarea').show()
    oFCKeditor = new FCKeditor('editor1')
    oFCKeditor.ToolbarSet = 'Simple'
    oFCKeditor.BasePath = "/js/"       

    @datefield.find('.datetimeeditarea').editable
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
  
class DateFieldTool
  constructor: ->
    widgethtml = $('#datefieldtemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'datefieldcollector'
    data = 
      name: 'datefieldcollector'
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
        new DateFieldWidget($('.activewidget'), p, false)
    
    
$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.DateFieldTool = new DateFieldTool()
    $('.datefieldall').each ->    
      if $(@)?      
        x = $(@).position().left
        y = $(@).position().top
        text = new DateFieldWidget($(this).parent(),$(this).position(), true, $(this))  
        
      