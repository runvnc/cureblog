everyone = process.everyone

everyone.now.loadwidget = (name, callback) ->
  data =
    name: name
    coffee: fs.readFileSync "components/#{name}/js/#{name}.coffee", 'utf8'
    html: fs.readFileSync "components/#{name}/#{name}.html", 'utf8'
    css: fs.readFileSync "components/#{name}/css/#{name}.css", 'utf8'
  
  callback data
