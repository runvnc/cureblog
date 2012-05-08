(function($){
/*
 * Editable 1.3.3
 *
 * Copyright (c) 2009 Arash Karimzadeh (arashkarimzadeh.com)
 * Licensed under the MIT (MIT-LICENSE.txt)
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Date: Mar 02 2009
 */
$.fn.editable = function(options){
	var defaults = {
		onEdit: null,
		onSubmit: null,
		onCancel: null,
		editClass: null,
		submit: null,
		cancel: null,
		type: 'text', //text, textarea or select
		submitBy: 'blur', //blur,change,dblclick,click
		editBy: 'click',
        editor: 'non',
		options: null
	}
	if(options=='disable')
		return this.unbind(this.data('editable.options').editBy,this.data('editable.options').toEditable);
	if(options=='enable')
		return this.bind(this.data('editable.options').editBy,this.data('editable.options').toEditable);
	if(options=='destroy')
		return  this.unbind(this.data('editable.options').editBy,this.data('editable.options').toEditable)
					.data('editable.previous',null)
					.data('editable.current',null)
					.data('editable.options',null);

	var options = $.extend(defaults, options);

	options.toEditable = function(){
		$this = $(this);
		$this.data('editable.current',this.innerHTML);
		opts = $this.data('editable.options');
		$.editableFactory[opts.type].toEditable($this.empty(),opts);
		// Configure events,styles for changed content
		$this.data('editable.previous',$this.data('editable.current'))
			 .children()
				 .focus()
				 .addClass(opts.editClass);
		// Submit Event
		if(opts.submit){
			$('<button style="position:relative; z-index:5000;"/>').appendTo($this)
						.html(opts.submit)
						.one('mouseup',function(){opts.toNonEditable($(this).parent(),true)});
		}else
			$this.one(opts.submitBy,function(){opts.toNonEditable($(this),true)})
				 .children()
				 	.one(opts.submitBy,function(){opts.toNonEditable($(this).parent(),true)});
		// Cancel Event
		if(opts.cancel)
			$('<button style="position: relative; z-index: 5000;"/>').appendTo($this)
						.html(opts.cancel)
						.one('mouseup',function(){opts.toNonEditable($(this).parent(),false)});
		// Call User Function
		if($.isFunction(opts.onEdit))
			opts.onEdit.apply(	$this,
									[{
										current:$this.data('editable.current'),
										previous:$this.data('editable.previous')
									}]
								);
	}
	options.toNonEditable = function($this,change){
		opts = $this.data('editable.options');
		// Configure events,styles for changed content

		$this.one(opts.editBy,opts.toEditable)
			 .data( 'editable.current',
				    change
						?$.editableFactory[opts.type].getValue($this,opts)
						:$this.data('editable.current')
					).sethtml(this,
				    opts.type=='password'
				   		?'*****'
						:$this.data('editable.current')
                    );
		// Call User Function
		var func = null;
		if($.isFunction(opts.onSubmit)&&change==true)
			func = opts.onSubmit;
		else if($.isFunction(opts.onCancel)&&change==false)
			func = opts.onCancel;
		if(func!=null)
			func.apply($this,
						[{
							current:$this.data('editable.current'),
							previous:$this.data('editable.previous')
						}]
					);
	}
	this.data('editable.options',options);
	return  this.one(options.editBy,options.toEditable);
}
$.editableFactory = {
	'text': {
		toEditable: function($this,options){
      if (window.alreadyEditing) return;
			$('<input/>').appendTo($this)
						 .val($this.data('editable.current'));
		},
		getValue: function($this,options){
			return $this.children().val();
		}
	},
	'password': {
		toEditable: function($this,options){
			$this.data('editable.current',$this.data('editable.password'));
			$this.data('editable.previous',$this.data('editable.password'));
			$('<input type="password"/>').appendTo($this)
										 .val($this.data('editable.current'));
		},
		getValue: function($this,options){
			$this.data('editable.password',$this.children().val());
			return $this.children().val();
		}
	},
	'textarea': {
		toEditable: function($this,options){
			$('<textarea/>').appendTo($this)
							.val($this.data('editable.current'));
		},
		getValue: function($this,options){
			return $this.children().val();
		}
	},
    'wysiwyg': {
		toEditable: function($this,options){
                           
                           
                           // var results = typeof(options.editor);

                          // alert(results);

            if(typeof(FCKeditor) != "undefined" && options.editor instanceof FCKeditor){
                    // FCKEditor
                    $('<textarea name="'+options.editor.InstanceName+'" id="'+options.editor.InstanceName+'"  />').appendTo($this)
                                    .val($this.data('editable.current'));

                    options.editor.ReplaceTextarea() ;

            }else{
                //tinyMCE
                //alert("so tiny!!!");
                $('<textarea name="'+options.editor.id+'" id="'+options.editor.id+'" style="width:100%" />').appendTo($this)
                                    .val($this.data('editable.current'));
                                  
                // ugly but unavoidable becuse the way tiny works.
                var ed = new tinymce.Editor(options.editor.id, {});
                ed.settings = options.editor.settings;
                options.editor = ed;
                options.editor.render();
                //alert("rendered");
                
            }

        },
		getValue: function($this,options){
            if(typeof(FCKeditor) != "undefined" && options.editor instanceof FCKeditor){
                return FCKeditorAPI.GetInstance(options.editor.InstanceName).GetHTML();
            }else{
                                //alert("so tiny!!!");
                                var r =options.editor.getContent({format : 'text'});
                                options.editor.remove();
                                return r;
             }
		}
	},
	'select': {
		toEditable: function($this,options){
			$select = $('<select/>').appendTo($this);
			$.each( options.options,
					function(key,value){
						$('<option/>').appendTo($select)
									.html(value)
									.attr('value',key);
					}
				   )
			$select.children().each(
				function(){
					var opt = $(this);
					if(opt.text()==$this.data('editable.current'))
						return opt.attr('selected', 'selected').text();
				}
			)
		},
		getValue: function($this,options){
			var item = null;
			$('select', $this).children().each(
				function(){
					if($(this).attr('selected'))
						return item = $(this).text();
				}
			)
			return item;
		}
	}
}

$.fn.sethtml =function(d, value){
    this[0].innerHTML = value

}

})(jQuery);
