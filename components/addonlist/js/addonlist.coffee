allplugins = []
plugitem = 0
selectedplugin = ''

complete = (search, strings) ->
  (str for str in strings when str.indexOf(search) >= 0)    

highlightSel = ->
  $('#matches li').css 'backgroundColor', '#fff'
  selectedplugin = $('#matches li').eq(plugitem).text()
  $('#matches li').eq(plugitem).css 'backgroundColor', '#EEDAF5'
  
matches = []
 
currentlyinstalling = ''

installmsg = (msg) ->
  if msg.indexOf('__SUCCESS__') >= 0
    installdone true
  else
    $('#installmsg').append msg
    $('#installmsg')[0].scrollTop = $('#installmsg')[0].scrollHeight

    
listplugins = ->
  now.listComponents (components) ->
    str = ''
    for component in components
      checked = ''
      if component.active then checked = 'checked="checked"'
      check = '<input type="checkbox" ' + checked + '/>'
      str += "<li>#{check}&nbsp;<span class=\"compname\">#{component.name}</span></li>"
    $('#pluginlist').html str
    
updateActive = ->    
  active = []
  $('#pluginlist li').each ->
    if $(@).find('input').is(':checked')
      active.push $(@).find('.compname').text()
  now.setActiveComponents active    
  $('#plugindonemsg').html 'Your edits have been saved.  Reloading application..'
  now.restartServer()
  setTimeout ( -> window.location.reload() ), 2000

  
installdone = (success) ->
  if success
    type = 'success'
    msg = currentlyinstalling + ' finished installing.'    
    noty
      text: msg
      type: type
      layout: 'topRight'
    $('#installmsg').hide()
    
    $('#pluginlist').show()
    $('#plugindonemsg').html 'Installation successful.  Click Save Changes to restart.'
    $('#plugindonemsg').css 'backgroundColor', 'white'
    listplugins()
    
  else
    type = 'error'
    msg = 'Installation of plugin ' + currentlyinstalling + ' failed.  See log'
    
    noty
      text: msg
      type: type
      layout: 'topRight'
  

install = (plugin) ->
  currentlyinstalling = plugin
  noty
    text: 'Installing plugin ' + plugin
    type: 'information'
    layout: 'topRight'

  $('#installmsg').show()
  $('#pluginlist').hide()
  now.installPlugin plugin, installmsg, installdone
  
  
$ ->    
  $('#advobjs').prepend '<button id="plugins" class="button white"><img src="images/plugins.png"/>Plugins..</button>'  

  $('#updateactive').click updateActive
  
  $('#plugins').click ->
    $('#pluginauto').dialog
      title: 'Add plugins' 
      position: 'top'
      height: $(window).height() * .93
      width: $(window).width() * .7

    $('#installmsg').hide()  
    $('#inp').keyup (e) ->
      switch e.which
        when 40
          if plugitem < matches.length-1
            plugitem++
            console.log 'plugitem is now ' + plugitem
            highlightSel()
          else
            console.log '40 no plugitem is ' + plugitem + ' matches is ' + matches.length
        when 38
          if plugitem > 0
            plugitem--
            highlightSel()
          else
            console.log '38 no plugitem is ' + plugitem + ' matches is ' + matches.length

        when 13          
          toks = selectedplugin.split ' '
          selectedplugin = toks[0]
          install selectedplugin
          
        else
          if $('#inp').val() is ''
             matches = [];    
          else
            matches = complete $('#inp').val().toLowerCase(), allplugins
          list = '';
          for str in matches
            list += '<li>' + str + '</li>';  
      
          plugitem = -1
        
          $('#matches').html list
          if matches.length is 1
            plugitem = 0
            setTimeout highlightSel, 100  
            
          $('#matches li').click ->
            toks = $(@).text().split ' '
            selectedplugin = toks[0]
            install selectedplugin
        
    
  now.ready ->
    listplugins()
    now.getPluginIndex (list) ->      
      for key, val of list
        allplugins.push val.name + '  ' + val.description
    
        