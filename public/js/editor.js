(function() {
  var editWidget, editor, editorbrowser, editorcss, editorhtml, editornodejs, initeditortabs, initialized, loadwidgets, makeEditable, nowediting, publish, thing;

  editor = void 0;

  editorhtml = void 0;

  editorbrowser = void 0;

  editornodejs = void 0;

  editorcss = void 0;

  window.saveFilters = [];

  nowediting = '';

  initialized = false;

  thing = function() {};

  editWidget = function(widget) {
    $('#widgetname').data('mode', 'update');
    $('#widgetname').val(widget.name);
    nowediting = widget.name;
    window.createCookie('lastScreen', widget.name);
    $('.demo').dialog('option', 'title', widget.name);
    editorbrowser.setValue(widget.browser);
    editornodejs.setValue(widget.nodejs);
    editorhtml.setValue(widget.html);
    editorcss.setValue(widget.css);
    $('#stylelist').text(widget.styles);
    return $('#scriptlist').text(widget.scripts);
  };

  initeditortabs = function() {
    var lastScreen;
    if (initialized) return;
    initialized = true;
    editorhtml = CodeMirror.fromTextArea($("#html")[0], {
      mode: "text/html",
      lineNumbers: true
    });
    editorbrowser = CodeMirror.fromTextArea($("#browser")[0], {
      mode: "coffeescript",
      lineNumbers: true
    });
    editornodejs = CodeMirror.fromTextArea($("#nodejs")[0], {
      mode: "coffeescript",
      lineNumbers: true
    });
    editorcss = CodeMirror.fromTextArea($("#css")[0], {
      mode: "text/css",
      lineNumbers: true
    });
    lastScreen = window.readCookie('lastScreen');
    if (lastScreen != null) {
      return now.getWidgetData(lastScreen, function(widgetdata, err) {
        if (err != null) {
          return alert('Error loading widget data: ' + err.message);
        } else {
          return editWidget(widgetdata);
        }
      });
    }
  };

  makeEditable = function() {
    return $.contextMenu({
      selector: '.compmenu',
      trigger: 'hover',
      autoHide: false,
      callback: function(key, options, e) {
        var el, name;
        el = window.lastMenuEvent.currentTarget;
        name = $(el).parent().find('.compname').text();
        switch (key) {
          case 'delete':
            if (window.confirm("Delete " + name + "? (Can't be undone!)")) {
              now.deleteComponent(name, function(success, err) {
                if (err != null) {
                  return alert('Failed: ' + err.message);
                } else {
                  $('.demo').html('Component was deleted.  Reloading application..');
                  window.delay(2000, function() {
                    return window.location.reload();
                  });
                  return now.restartServer();
                }
              });
            } else {
              console.log("Not deleting");
            }
            break;
          case 'copy':
            now.copyComponent(name, function(success, err) {
              if (!(err != null)) {
                $('.demo').html("" + name + " copied successfully. Reloading application.");
                return window.delay(2000, function() {
                  return window.location.reload();
                });
              } else {
                return alert('Error copying component: ' + err.message);
              }
            });
            break;
          case 'edit':
            now.getWidgetData(name, function(widgetdata, err) {
              if (err != null) {
                return alert('Error loading widget data: ' + err.message);
              } else {
                return editWidget(widgetdata);
              }
            });
            break;
          case 'rename':
            $(el).parent().find('.compname').attr('contenteditable', true).focus().select().blur(function() {
              return now.renameComponent(name, $(el).parent().find('.compname').text());
            });
        }
        return true;
      },
      items: {
        "edit": {
          name: "Edit Code",
          icon: "edit"
        },
        "rename": {
          name: "Rename",
          icon: "edit"
        },
        "copy": {
          name: "Make a Copy",
          icon: "copy"
        },
        "delete": {
          name: "Delete",
          icon: "delete"
        }
      }
    });
  };

  window.savePage = function() {
    var filter, unfiltered, _i, _len, _ref;
    if (window.alreadyEditing) {
      noty({
        text: "Can't save while editing",
        type: 'alert'
      });
      return;
    }
    unfiltered = $('#page').html();
    $('body').append('<div id="tofilter"></div>');
    $('#tofilter').html(unfiltered).hide();
    _ref = window.saveFilters;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      filter = _ref[_i];
      filter('#tofilter');
    }
    return window.delay(500, function() {
      return now.savePage($('#tofilter').html(), function(success) {
        if (success) {
          return noty({
            text: 'Page saved.',
            type: 'success',
            timeout: 1000
          });
        }
      });
    });
  };

  loadwidgets = function() {
    $('#page').droppable({
      drop: function(ev, ui) {
        var name;
        name = ui.draggable.data('name');
        return $('#page').trigger('drop', [ev, ui, this]);
      }
    });
    now.listComponents(function(components) {
      var check, checked, component, str, _i, _len;
      str = '';
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        checked = '';
        if (component.active) checked = 'checked="checked"';
        check = '<input type="checkbox" ' + checked + '/>';
        str += "<li>" + check + "&nbsp;<span class=\"compname\">" + component.name + "</span><span class=\"compmenu\">▼</span></li>";
      }
      $('#components').html(str);
      return $('.compname').click(function() {
        $('#gitrepo').val('');
        return now.getWidgetData($(this).text(), function(widgetdata, err) {
          if (err != null) {
            return alert('Error loading widget data: ' + err.message);
          } else {
            return editWidget(widgetdata);
          }
        });
      });
    });
    return makeEditable();
  };

  publish = function() {
    var name, repo, user;
    $('.pubmsg').html('Publishing..');
    user = $('#gituser').val();
    repo = $('#gitrepo').val();
    name = nowediting;
    if (!((user != null) && (repo != null) && (name != null))) {
      return alert('Please fill in all of the publish fields');
    } else {
      return now.publishComponent(name, user, repo, function(res) {
        console.log(res);
        if (res != null) {
          if (res.message != null) {
            return $('.pubmsg').html(res.message);
          } else {
            return $('.pubmsg').html('Success!');
          }
        }
      });
    }
  };

  $(function() {
    $('#editorui').hide();
    $('body').prepend($('#editorui'));
    $('#objs').height($(window).height());
    $('#objs').prepend('<button id="editcode" class="button white"><img src="images/code.png"/>Code Editor</button>');
    $('#objs').prepend('<button id="savepage" class="button white"><img src="images/save.png"/>Save Page</button><br/>');
    $('#tabs').tabs({
      show: function(event, ui) {
        if (editorhtml != null) editorhtml.refresh();
        if (editorbrowser != null) editorbrowser.refresh();
        if (editorcss != null) editorcss.refresh();
        if (editornodejs != null) return editornodejs.refresh();
      }
    });
    $('#savewidget').click(function() {
      var active, data;
      data = {
        name: $('#widgetname').val(),
        browser: editorbrowser.getValue(),
        html: editorhtml.getValue(),
        css: editorcss.getValue(),
        nodejs: editornodejs.getValue(),
        styles: $('#stylelist').text(),
        scripts: $('#scriptlist').text()
      };
      now.saveWidgetData(data, function(compileout) {
        if ((compileout != null) && compileout.length > 4) {
          alert(compileout);
        } else {
          $('.demo').html('Your edits have been saved.  Reloading application..');
          now.restartServer();
          return setTimeout((function() {
            return window.location.reload();
          }), 2000);
        }
      });
      active = [];
      $('#components li').each(function() {
        if ($(this).find('input').is(':checked')) {
          return active.push($(this).find('.compname').text());
        }
      });
      return now.setActiveComponents(active);
    });
    $('#editcode').click(function() {
      $('.demo').dialog({
        title: name + ' component - Code Editor',
        position: 'top',
        height: $(window).height() * .93,
        width: $(window).width() * .9
      });
      window.delay(150, function() {
        $(".ui-tabs-panel").height($(window).height() * .7);
        $(".CodeMirror").height($(window).height() * .69);
        return window.delay(150, function() {
          $(".CodeMirror-scroll").height($(window).height() * .68);
          return $('.transparent').css('backgroundColor', '#f2f2f2');
        });
      });
      return initeditortabs();
    });
    $('#publish').click(publish);
    $('#savepage').click(function() {
      return window.savePage();
    });
    return now.ready(function() {
      var sessionid;
      sessionid = window.readCookie('myid');
      console.log('sessionid is ' + sessionid);
      if (!(sessionid != null)) {
        window.loggedIn = false;
        console.log("Logged in is " + window.loggedIn);
      } else {
        now.getAccountInfo(sessionid, function(user) {
          if (!(user != null)) {
            window.loggedIn = false;
            console.log("Logged in is " + window.loggedIn);
            return $(document).trigger('sessionState', void 0);
          } else {
            window.loggedIn = true;
            window.user = user;
            console.log("Logged in is " + window.loggedIn);
            console.log("user is " + window.user);
            $('#editorui').show();
            return $(document).trigger('sessionState', user);
          }
        });
      }
      return loadwidgets();
    });
  });

}).call(this);
