This is (or will be) a front-end- friendly Node.js-based blog, CMS and component platform.

It is a framework and tool for building web sites and web applications of all types.

Node.js
=======
Node.js is trendy (at the moment this framework is started) and has a number of advantages over other platforms, which at this point are so well hyped that I don't need to get into them.

Blog
====
Blogging is probably the most ubiquitous type of web application, and we want a general purpose system with lots of users, so we will target blogging-type applications first.

Front-End- Friendly
===================
Node.js is powerful and fun for writing network applications, but many developers are like me and want to take advantage of Node for writing all types of web applications.

One of the great things about Node and related tools is that since the modules and tools are so well designed and convenient, the backend code doesn't have to be complex in order to be very powerful.  The trick to that is that you need to know about the right modules, like NowJS for realtime messaging between client or Mongolian Deadbeef for easy MongoDB access.

CureBlog is designed to come with those types of powerful backend features built-in.  In fact, the goal is for the front-end developer to be able to build complex database and other types of applications without even writing back-end or front-end code.  This is accomplished by configuring pre-built components developed by the community.

Another advantage of Cureblog is that it comes with a WYSIWYG designer to allow the design to be easily modified without hand-coding CSS.  Editing the design involves dragging components onto a page or onto eachother and then configuring them.  The philosophy is that most of the action should happen in the front-end code and the client, data should be pushed and live, and there should be minimal back-end code.

Editing or creating components does not require access to the server.  Developers can use a built-in CodeMirror editor.

Components
==========
Components are probably the most important and useful architectural feature of Cureblog.  "Components" can mean a lot of different things to different people, but in this case components are a way of packaging back-end Node.js code (JavaScript or CoffeeScript) along with the HTML, CSS and JavaScript or CoffeeScript for the front-end.  On the front-end a component is a drag-and-drop widget with properties that can be modified in the property editor.  The back-end code for each component is there to support the front-end: saving data, security checks, sending emails, etc.

Example Component
-----------------

    components/
      example/
        requires      #a (newline separated) list of other components this one depends on
        styles        #a (newline separated) list of stylesheet filenames, e.g. 
                 





