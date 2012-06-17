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
      if window.loggedIn
        @pageddata.draggable
          handle: '.movehandle'
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
          @pageddata.find('.widgetcontent').toggle 100
        @pageddata.find('.savepaged').off 'click'
        @pageddata.find('.savepaged').on 'click', =>
          @save()
        @listrecords()
        @pageddata.find('.widgetcontent').hide()
        @pageddata.find('.pagedtop').show()
      else
        @displaymode()
        if not window.location.hash? or window.location.hash.length < 3
          if window.location.href.lastIndexOf('/') is window.location.href.length - 1
            @loadrecent()        
      
      $(window).bind 'hashchange', =>
        @checkHash()  

      @checkHash()      
      
    catch e
      console.log e

  checkHash: ->
    if window.location.hash?
      path = window.location.hash.substr 1
      if path.indexOf 'content/' >= 0
        tokens = path.split '/'
        collection = tokens[1]
        if collection is @pageddata.attr('data-collection')
          title = tokens[2]
          title = title.replace(/\-/g, ' ')
          criteria = { title: title }
          now.dbquery collection, criteria, (record) =>
            alert 'got the record'
            console.log record
            if record?
              record = record[0]
              if not record?
                @designmode()
              else
                @displaymode()
                @record = record
                @display()
              
        
  loadrecent: (callback) -> 
    now.dbfind @pageddata.attr('data-collection'), (records) =>
      @records = records
      @record = records[records.length-1]      
      setTimeout (=> @display()), 50
  
  displaymode: ->
    @pageddata.find('.pagedtop,.toggletop,.movehandle').hide()    
    @pageddata.css 'border', 'none'
    
  
  display: ->
    rec = @record
    @pageddata.find('.field').each ->
      widget = this.widget
      widget.display.call widget, rec
      
    
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
    
  designmode: ->
    @pageddata.find('.editcontrols').hide()
    @pageddata.find('.field').each ->
      widget = $(this).data 'widget'
      widget.designmode @record
    
    
  save: ->
    @col = @pageddata.attr 'data-collection'
    criteria = { "id": @record["_id"] }
    now.dbupdate @col, criteria, @record, =>      
      @listrecords()
      @designmode()
      @pageddata.find('.widgetcontent').hide()
      @pageddata.find('.pagedtop').show()
      now.cachePage '/'
      title = @record['title']
      if title?
        title = title.replace(/\ /g, '-')
        now.cachePage title, @col
    
    
  edit: (record) ->
    @record = record
    pageddata = @pageddata
    @pageddata.find('.editcontrols').show()
    @pageddata.find('.pagedtop').hide 100
    @pageddata.find('.widgetcontent').show 100
    @pageddata.find('.field').each ->
      widget = $(this).data 'widget'
      widget.edit record

  fieldlist: (records) ->   
    keys = {}
    for record in records
      for key, val of record        
        if key.indexOf('_') isnt 0 and not keys[key]?
          keys[key] = true
    keys    
      
      
  listrecords: ->
    col = @pageddata.attr('data-collection')
    if not col?
      return

    now.dbfind @pageddata.attr('data-collection'), (records) =>
      str = ''
      @records = records
      fields = @fieldlist @records
      str += '<table><tr>'
      for fieldname, val of fields
        str += '<th class=\"recordhead\">'+fieldname+'</th>'
      str += '</tr>'
      for record in records
        id = record['_id']        
        str += '<tr class=\"pagedrecord\" id=\"' + id + '\">'
        for fieldname, val of fields
          if fieldname.indexOf('_') isnt 0 and fieldname is 'title'
            str += '<td class=\"recorditem\">' + record[fieldname] + '</td>'
        str += '</tr>'
      str += '</table>'
      @pageddata.find('.pagedlist').html str
      @pageddata.find('.pagedrecord').off 'click'
      pageddata = this
      @pageddata.find('.pagedrecord').on 'click', ->   
        col = pageddata.pageddata.attr('data-collection')
        obj = { "_id": $(this).attr('id') }
        now.dbquery col, obj, (record) ->
          record = record[0]
          pageddata.edit.call pageddata, record
      
        
class PagedDataTool
  constructor: ->
    widgethtml = $('#pageddatatemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'pageddatacollector'
    data = 
      name: 'pageddatacollector'
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
        new PagedDataWidget($('.activewidget'), p, false)
    
     
    
$ ->
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.PagedDataTool = new PagedDataTool()
      window.saveFilters.push (sel) ->      
        $(sel).find('.pagedlist li').remove()  
        
    $('.pageddataall').each ->    
      if $(@)?      
        x = $(@).position().left
        y = $(@).position().top
        text = new PagedDataWidget($(this).parent(),$(this).position(), true, $(this))  

if not window.saveFilters?
  window.saveFilters = []
  
window.saveFilters.push (sel) ->      
  $(sel).find('.pagedlist table').remove()
  
  