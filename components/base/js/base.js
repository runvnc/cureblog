(function() {
  var S4;

  S4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  };

  window.delay = function(ms, func) {
    console.log(ms);
    console.log(func);
    return setTimeout(func, ms);
  };

  window.guid = function() {
    return S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4();
  };

  window.createCookie = function(name, value, days) {
    var date, expires;
    if (days) {
      date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toGMTString();
    } else {
      expires = "";
    }
    return document.cookie = name + "=" + value + expires + "; path=/";
  };

  window.readCookie = function(name) {
    var c, ca, i, nameEQ;
    nameEQ = name + "=";
    ca = document.cookie.split(";");
    i = 0;
    while (i < ca.length) {
      c = ca[i];
      while (c.charAt(0) === " ") {
        c = c.substring(1, c.length);
      }
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
      i++;
    }
    return null;
  };

  window.eraseCookie = function(name) {
    return createCookie(name, "", -1);
  };

}).call(this);
