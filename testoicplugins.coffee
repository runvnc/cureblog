gistcomments = require './gistcomments'

gistcomments.config 'ithkuil', 'x85a3h9w'

gistcomments.listcomments '2583031', (err, res, body) ->
  comments = JSON.parse body
  for comment in comments
    console.log comment.user.login + ":\t" + comment.body
   
data =
  name: 'blankplugin'
  repo: 'oicplugins'
  description: 'This is a blank to copy as a template'

data =
  body: 'hello world'

###
gistcomments.addcomment '2583031', data, (err, res, body) ->
  console.log err
  console.log res
  console.log body
###

