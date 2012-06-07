everyone = process.everyone
fs = require 'fs'
path = require 'path'

path.exists 'emaillist', (exists) ->
  if not exists
    fs.writeFile 'emaillist', '', 'utf8', (err) ->
      

everyone.now.saveEmail = (emailaddress, callback) ->  
  fs.readFile 'emaillist', 'utf8', (err, list) ->
    if err?
      callback?(false, 'Error reading email list file.')
    else
      check = "\n" + emailaddress
      if list.indexOf(check) >= 0
        callback?(false, 'Email address already added.')
      else
        list += "\n" + emailaddress
        fs.writeFile 'emaillist', list, 'utf8', (err) ->
          if err?
            callback?(false, 'Error saving email list.')
          else
            callback?(true, 'Email saved.')