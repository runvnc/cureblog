widget = function() {
  this.class = 'widget';

  this.init = function(options) {
    this.data = options.data;
    this.children = [];
    if (!('parent' in options)) {
      this.parent = $('body');
    } else {
      this.parent = options.parent; 
    }
    this.templateHtml = $('.' + this.class + '-template').html();
    this.template = Handlebars.compile(this.templateHtml);
  }

  this.render = function() {
    this.renderedHtml = this.template(this.data);
    this.renderedEl = $(this.renderedHtml);
    $(this.el).data('data', this.data);
    $(this.el).data('widget', this);
    if ('el' in this) {
      this.el = this.renderedEl;
    } else {
      this.el = this.parent.append(this.renderedEl); 
    }
    for (var i=0; i<this.children.length; i++) {
      this.children[i].render();      
    }
  }  

}
