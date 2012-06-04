class PagedDataWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      pageddatahtml = $('#pageddatawidgettemplate').html()
      @pageddata = $(pageddatahtml)    
      @pageddata.css 'position', 'absolute'
      @pageddata.css 'top', position.top + 'px'
      @pageddata.css 'left', position.left + 'px'
      parent.append @pageddata
    else
      @pageddata = widget

    try
      pageddata = @pageddata
      @pageddata.draggable()
      @pageddata.resizable()
      @pageddata.find('.widgetcontent').off 'click'
      @pageddata.find('.widgetcontent').on 'click', ->
        $('.activewidget').removeClass 'activewidget'
        $(this).addClass 'activewidget'
      @pageddata.find('.pagedtype').off 'change'
      @pageddata.find('.pagedtype').on 'change', ->        
        pageddata.attr 'data-collection', $(this).val()
      if @pageddata.attr('data-collection')?
        @pageddata.find('.pagedtype').val @pageddata.attr('data-collection')
      @pageddata.find('.addpaged').off 'click'
      @pageddata.find('.addpaged').on 'click', =>
        record = @newblank()
        now.dbinsert @pageddata.attr('data-collection'), record, =>
          @listrecords()
      @pageddata.find('.toggletop').off 'click'
      @pageddata.find('.toggletop').on 'click', =>
        @pageddata.find('.pagedtop').toggle 100
      
    catch e
      console.log e
    
  getfields: ->
    fields = []
    s = this
    @pageddata.find('.field').each ->
      field =
        name: $(this).attr 'data-fieldname'
      field.value = s.blank field
      fields.push field
    fields  
      
  blank: (field) ->
    'New'
    
  newblank: ->
    fields = @getfields()
    obj = {}
    for field in fields
      obj[field.name] = field.value
    obj
    
  edit: (record) ->
    pageddata = @pageddata
    @pageddata.find('.field').each ->
      alert 'trying to edit something'
      $(this).data('widget').edit record

      
  listrecords: ->
    now.dbfind @pageddata.attr('data-collection'), (records) =>
      str = ''
      for record in records
        fieldstr = ''
        id = record['_id']
        for fieldname, val of record        
          if fieldname.indexOf('_') isnt 0
            fieldstr += fieldname + ':' + val
        str += '<li class=\"pagedrecord\" id=\"' + id + '\">' + fieldstr + '</li>'
      @pageddata.find('.pagedlist').html str
      @pageddata.find('.pagedrecord').off 'click'
      pageddata = @pageddata
      @pageddata.find('.pagedrecord').on 'click', ->  
        alert 'you clicked'        
        col = pageddata.attr('data-collection')        
        now.dbquery col, { id: $(this).attr('id') }, (record) ->
          alert 'returned'
          console.log record
          pageddata.edit.call pageddata record
      
    
class PagedDataTool
  constructor: ->
    widgethtml = $('#pageddatatemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'pageddatacollector'
    data = 
      name: 'pageddatacollector'
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
        new PagedDataWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.pageddataall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new PagedDataWidget($(this).parent(),$(this).position(), true, $(this))  
  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.PagedDataTool = new PagedDataTool()