class EtherCalcWidget
  constructor: (parent, position, exists, widget) ->
    if not exists
      ethercalchtml = $('#ethercalcwidgettemplate').html()
      ethercalc = $(ethercalchtml)    
      ethercalc.css 'position', 'absolute'
      ethercalc.css 'top', position.top + 'px'
      ethercalc.css 'left', position.left + 'px'
      parent.append ethercalc
    else
      ethercalc = widget

    try
      ethercalc.draggable()
      ethercalc.resizable()
      $('.saveemail').off 'blur'
      $('.saveemail').on 'blur', ->
        now.saveEmail $(this).val()
        $(this).val ''
    catch e
      

class EtherCalcTool
  constructor: ->
    widgethtml = $('#ethercalctemplate').html()
    widget = $(widgethtml)
    btn = widget.find '.designwidget'
    btn.data 'name', 'ethercalc'
    data = 
      name: 'ethercalc'
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
        new EtherCalcWidget($('.activewidget'), p, false)
    
    
$ ->
  $('.ethercalcall').each ->    
    if $(@)?      
      x = $(@).position().left
      y = $(@).position().top
      text = new EtherCalcWidget($(this).parent(),$(this).position(), true, $(this))  
  
  
  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.EtherCalcTool = new EtherCalcTool()
      
    