
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
    name = @obj.attr 'data-fieldname'
    @obj.find('.texthtmldisplay').html '{{' + name + '}}'

    
  blank: =>
    'New'
    
  edit: (record) ->
    name = @obj.attr 'data-fieldname'
    @textfield.find('.textinput').show()
    @textfield.find('.textinput').val record[name]
    @textfield.find('.textinput').off 'blur'
    @textfield.find('.textinput').on 'blur', ->
      record[name] = $(this).val()

  display: (record) ->  
    name = @obj.attr 'data-fieldname'        
    @textfield.find('.texthtmldisplay').html '{{'+name+'}}'
    @textfield.find('.rename,.fieldname').hide()
    @textfield.css 'border', 'none'
    
      
  designmode: ->    
    name = @obj.attr 'data-fieldname'
    @textfield.find('.textinput').hide()
    @textfield.find('.fieldnameinp').change =>
      @textfield.attr 'data-fieldname', @textfield.find('.fieldnameinp').val() 
      @showname()
    @textfield.find('.menudrop').click =>
      @textfield.find('.menudrop').toggleClass 'open'
      @textfield.find('.options').toggle()
      
    currhtml = "currhtml"
    if currhtml.indexOf('{{') < 0 or currhtml.indexOf('{{undefined}}') > 0
      @textfield.find('.texthtmldisplay').html '{{' + name + '}}'

  
class TextFieldTool
  constructor: ->
    widgethtml = $('#textfieldtemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'textfieldcollector'
    data = 
      name: 'textfieldcollector'
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
        
      