loadwidget = (data) ->
  try
    $('#widgets').append data.html
    $('head').append "<script>#{data.code}</script>"
  catch e
    console.log e

loadwidgets = ->
  now.dbfind 'widgets', (widgets) ->
    console.log widgets
    loadwidget widget for widget in widgets

$ ->
  now.ready ->
    loadwidgets()

