allplugins = []
plugitem = -1
selectedplugin = ''

complete = (search, strings) ->
  (str for str in strings when str.indexOf(search) is 0)    

highlightSel = ->
  console.log 'highlighting ' + plugitem
  $('#matches li').css 'backgroundColor', '#fff'
  selectedplugin = $('#matches').eq(plugitem).text()
  $('#matches').eq(plugitem).css 'backgroundColor', '#EEDAF5'
  

$ ->    
  $('#objs').prepend '<button id="plugins" class="button white">Plugins..</button>'

  $('#plugins').click ->
    $('#pluginauto').dialog
      title: 'Add plugins' 
      position: 'top'
      height: $(window).height() * .93
      width: $(window).width() * .7

    $('#inp').keyup (e) ->
      if $('#inp').val() is ''
         matches = [];    
      else
        matches = complete $('#inp').val().toLowerCase(), allplugins
      console.log 'matches:'
      console.log matches
      list = '';
      for str in matches
        list += '<li>' + str + '</li>';  
  
      $('#matches').html list
      if matches.length is 1
        plugitem = 1
        setTimeout highlightSel, 100
        
  
    $('#inp').keydown (e) ->
      switch e.which
        when 40
          console.log 'hi there plugitem is ' + plugitem
          if plugitem < allplugins.length
            plugitem++
            highlightSel()
        when 38
          if plugitem > -1
            plugitem--
            highlightSel()
        when 13
          noty
            text: 'Installing plugin ' + selectedplugin
            type: 'information'
    
  now.ready ->
    now.getPluginIndex (list) ->      
      for key, val of list
        allplugins.push val.name + '  ' + val.description
        
        