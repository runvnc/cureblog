
  window.login = function() {
    console.log('you clicked login');
    return now.login('admin', '', function(guid) {
      console.log('guid is ' + guid);
      return window.createCookie('myid', guid, 1);
    });
  };
