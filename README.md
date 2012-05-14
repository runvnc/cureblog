webchat <iframe src="http://webchat.freenode.net?randomnick=1&channels=oic&uio=d4" width="647" height="400"></iframe>

This is (or will be) a front-end- friendly Node.js-based CMS and component platform.

It is a framework and tool for building web sites and web applications of all types.

Node.js
=======
Node.js is trendy (at the moment this framework is started) and has a number of advantages over other platforms, which at this point are so well hyped that I don't need to get into them.

Front-End- Friendly
===================
Node.js is powerful and fun for writing network applications, but many developers are like me and want to take advantage of Node for writing all types of web applications.

One of the great things about Node and related tools is that since the modules and tools are so well designed and convenient, the backend code doesn't have to be complex in order to be very powerful.  The trick to that is that you need to know about the right modules, like NowJS for realtime messaging between client or Mongolian Deadbeef for easy MongoDB access.

CureBlog is designed to come with those types of powerful backend features built-in.  In fact, the goal is for the front-end developer to be able to build complex database and other types of applications without even writing back-end or front-end code.  This is accomplished by configuring pre-built components developed by the community.

Another advantage of Cureblog is that it comes with a WYSIWYG designer to allow the design to be easily modified without hand-coding CSS.  Editing the design involves dragging components onto a page or onto eachother and then configuring them.  The philosophy is that most of the action should happen in the front-end code and the client, data should be pushed and live, and there should be minimal back-end code.

Editing or creating components does not require access to the server.  Developers can use a built-in CodeMirror editor.

Components
==========
Components are probably the most important and useful architectural feature of Cureblog.  "Components" can mean a lot of different things to different people, but in this case components are a way of packaging back-end Node.js code (JavaScript or CoffeeScript) along with the HTML, CSS and JavaScript or CoffeeScript for the front-end.  

On the front-end a component is a drag-and-drop widget with properties that can be modified in the property editor.  The back-end code for each component is there to support the front-end: saving data, security checks, sending emails, etc.

Components can require other components and also come with default data so they can effectively install themselves and work like plugins.

Component Structure
-------------------
    loadorder        #a list of components to load in a specific order
    public/
      css/           #files are copied on build from same dirs in each component
      js/            #files are copied on build from same dirs in each component
    components/
      example/
        requires      # a list of other components this one depends on
        styles        # a list of stylesheet filenames
        scripts       # a list of script filenames                 
        html          # html inserted into index.html containing template for component
        css/          # css file for each line in styles
                      # and any other files that might be required by scripts
                      # everything here copied into /public/css
        scripts/      # javascript file for each line in scripts
                      # and any other scripts that may be loaded by those scripts

Build Process
=============
Each time the application or a component is modified the application rebuilds:

* For each component, in the order specified by loadorder:
  - copy the contents of the css directory into public/css
  - create a list of css and js links to go in the `<head>`
  - copy the contents of the js directory into public/js
  - append the contents of the html file to the index body  

* Construct a `<head>` element for the site with the links in the previous step
* Place the index body text into index.html along with the `<head>` and other tags

Server Start-up
===============
Each time the application is modified, after the build step, the server will be restarted.  When the server starts, the following happens for each component, in the order specified by the file loadorder

* Require the file `./components/[name].coffee` 
* Call the startup() function exported by that module
* 

Application Editor/Admin
========================
Logging in displays the site in Edit mode.  There are two types of screens in edit mode: the default page with editing enabled for all components so you can drag components around and edit their properties, and the brain screen where you configure your site and its components.  The brain screen is the equivalent of the Admin section in WordPress.  You will not usually need to visit the brain screen though since most of the site editing is done WYWIWYG style in inline edit mode.

While in edit mode a toolbar appears at the top of the screen.  The built-in components are Text, Image and Block. 

If you know HTML, CSS and/or CoffeeScript you can easily create your own components.  See Creating New Components.


