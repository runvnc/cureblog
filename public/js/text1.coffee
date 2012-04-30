   
class Recycler
  constructor: ->
    $( $('#recycler').html() ).insertAfter $('#editcode')
    
    
    
$ ->
  window.recycler = new Recycler()

                                        
