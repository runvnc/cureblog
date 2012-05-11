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
  $('#installmsg').append msg
  $('#installmsg')[0].scrollTop = $('#installmsg')[0].scrollHeight
  
  
installdone = (msg) ->
  noty
    text: currentlyinstalling ' finished installing.'
    type: 'information'
    layout: 'topRight'
  

install = (plugin) ->
  currentlyinstalling = plugin
  noty
    text: 'Installing plugin ' + plugin
    type: 'information'
    layout: 'topRight'

  $('#installmsg').show()  
  now.installPlugin plugin, installmsg, installdone
  
  
$ ->    
  $('#objs').prepend '<button id="plugins" class="button white"><img src="images/plugins.png"/>Plugins..</button>'  
  
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
        
    
  now.ready ->
    now.getPluginIndex (list) ->      
      for key, val of list
        allplugins.push val.name + '  ' + val.description
        
        