class EmailCollectorWidget extends Widget
  constructor: (opts) ->
    super opts
    try
      if window.loggedIn then @jqobj.draggable()
      $('.saveemail').off 'blur'
      $('.saveemail').on 'blur', ->
        now.saveEmail $(this).val(), (success, msg) =>
          $(this).val ''
    catch e
      console.log e


class EmailCollectorTool extends WidgetTool
    
    
$ ->
  console.log 'emailcollector startup'

  $(document).bind 'sessionState', (user) ->
    if window.loggedIn
      window.emailCollectorTool = new EmailCollectorTool('EmailCollector')

      
window.EmailCollectorTool = EmailCollectorTool
window.EmailCollectorWidget = EmailCollectorWidget
    