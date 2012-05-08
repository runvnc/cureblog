strings = []

complete = (search, strings) ->
  (str for str in strings when str.indexOf(search) is 0)    


$('#inp').keyup (e) ->
  if $('#inp').val()  ''
    matches = [];    
  else
    matches = complete $('#inp').val().toLowerCase(), strings
  
  list = '';
  for str in matches
    list += '<li>' + str + '</li>';  
  
  $('#matches').html list


$ ->    
  $('#objs').prepend '<button id="plugins" class="button white">Plugins..</button>'

  $('#plugins').click ->
    $('#pluginauto').dialog
      title: 'Add plugins' 
      position: 'top'
      height: $(window).height() * .93
      width: $(window).width() * .7

  now.ready ->
    now.getPluginIndex (list) ->
      str = ''
      for plugin in list
        str += '<li id="pl_"' + plugin.name + '>'
        str += plugin.name + '&nbsp;&nbsp;'
        str += plugin.description
        str += '</li>'
        