(function() {

  window.login = function() {
    console.log('you clicked login');
    return now.login('admin', '', function(guid) {
      console.log('guid is ' + guid);
      window.createCookie('myid', guid, 1);
      return window.location.assign('/?dev');
    });
  };

  window.logout = function() {
    var myid;
    myid = window.readCookie('myid');
    window.eraseCookie('myid');
    now.logout(myid, function() {
      return window.location.assign('/');
    });
    return window.delay(500, function() {
      return window.location.assign('/');
    });
  };

  $(document).bind('sessionState', function(user) {
    console.log('Inside of login window.loggedIn is ' + window.loggedIn);
    if ((window.loggedIn != null) && window.loggedIn) {
      $('#loginout').text('Logout');
      return $('#loginout').click(function() {
        return window.logout();
      });
    } else {
      $('#loginout').text('Login');
      return $('#loginout').click(function() {
        return window.login();
      });
    }
  });

}).call(this);
