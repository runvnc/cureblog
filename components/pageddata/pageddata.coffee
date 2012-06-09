phantom = require 'phantom'
everyone = process.everyone


everyone.now.cachePage = (path, collection) ->
  phantom.create '--load-images=no', '--local-to-remote-url-access=yes', (ph) ->
    ph.createPage (page) ->      
      if path is '/'
        url = '/'
      else
        url = '/#content/' + collection + '/' + path
      page.open "http://localhost:3000" + url, (status) ->
        delayit = (ms, func) -> setTimeout func, ms
        getHTML = ->
          document.getElementsByTagName('html')[0].innerHTML
        delayit 700, ->
          page.evaluate getHTML, (result) ->
            if path is '/'
              filename = 'index.html'
            else
              filename = path
            process.saveStaticPage filename, result, ->
            ph.exit()