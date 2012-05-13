express = require 'express'
connect = require 'connect'

app = express.createServer express.logger()
app.use express.static __dirname + '/public'
app.use connect.compress()
app.listen 3030
