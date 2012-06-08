phantom = require 'phantom'
everyone = process.everyone


everyone.now.cachePage = (path) ->
  phantom.create '--load-images=no', '--local-to-remote-url-access=yes', (ph) ->
    ph.createPage (page) ->
      page.open "http://localhost:3000" + path, (status) ->
        delayit = (ms, func) -> setTimeout func, ms
        getHTML = ->
          document.getElementsByTagName('html')[0].innerHTML
        delayit 700, ->
          page.evaluate getHTML, (result) ->
            process.saveStaticPage 'index.html', result, ->
            ph.exit()