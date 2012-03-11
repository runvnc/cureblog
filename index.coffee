$ ->
  now.ready ->
    now.dbfind 'backups', (backups) ->
      console.log 'I found the backups'
      outp = '';
      $('#backups').html '<ul id="bulist"></ul>'    
      for b in backups
        li = $("<li class=\"restore\">#{b.col} #{b.modified} #{b.status}</li>")
        li.data 'criteria', b.criteria
        li.click ->
          now.dbrestore li.data('criteria')
        $('#bulist').append li
