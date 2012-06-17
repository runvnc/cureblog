everyone = process.everyone
fs = require 'fs'
path = require 'path'

path.exists 'emaillist', (exists) ->
  if not exists
    fs.writeFile 'emaillist', '', 'utf8', (err) ->
      

everyone.now.saveEmail = (emailaddress, callback) -> 
  console.log 'inside of saveemail and emailaddress is ' + emailaddress
  fs.readFile 'emaillist', 'utf8', (err, list) ->
    if err?
      console.log 'There was an error reading file dude'
      callback?(false, 'Error reading email list file.')
    else
      console.log 'about to try to save email'
      check = "\n" + emailaddress
      console.log 'check is ' + check
      console.log 'list is ' + list
      if list.indexOf(check) >= 0
        console.log 'email address already added'
        callback?(false, 'Email address already added.')
      else
        list += "\n" + emailaddress
        fs.writeFile 'emaillist', list, 'utf8', (err) ->
          if err?
            callback?(false, 'Error saving email list.')
          else
            callback?(true, 'Email saved.')