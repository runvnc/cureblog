  $ ->
    $('#objs').prepend '<button id="plugins" class="button white groove"><img src="images/music.png"/>Groove</button>'  
  
    $('.groove').on 'click', ->      
      window.open "http://somafm.com/popup/?groovesalad", 'SomaPlayer','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=410,height=220,left = 200,top = 140'
      window.open 'http://somafm.com/support/', '_blank'
      