loadwidget = (data) ->
  $('#widgets').append data.html
  $('head').append "<script>#{data.code}</script>"

loadwidgets = ->
  now.dbfind 'widgets', (widgets) ->
    loadwidget widget for widget in widgets

$ ->
  now.ready ->
    loadwidgets()

