/*
	Filename: moo.rd - A lightweight Mootools extension
	
	Author: Riccardo Degni, <http://www.riccardodegni.it/> and the moo.rd Team
	
	License: GNU GPL License
	
	Copyright: copyright 2007 Riccardo Degni
	
	[Credits]
		[li] moo.rd is based on the MooTools framework <http://mootools.net/>, and uses the MooTools syntax
		[li] moo.rd constructors extends some of the MooTools Classes
		[li] moo.rd Documentation is written by Riccardo Degni
	[/Credits]
*/

var Moo = {};

Moo.Rd = {
	version: '1.3.2',
	author: 'Riccardo Degni',
	members: [
		'Cristiano Fino',
		'Moocha'
	]
};

/*
	Filename: constructors.js
	
	[Description] 
		Contains some of the moo.rd native Constructors based on the MooTools Class. It permits a major modularity.
	[/Description]
	
	Contains: Class Table, Class Make
*/
/*
	Class: Table
	Description: Allows you to customize tables, tables rows, cells and columns 
*/
var Table = new Class({	
	initialize: function(element) {
		this.element = $(element);
		this.rows = this.element.getElements('tr');
		this.cells = this.element.getElements('tr').getElements('td');
	}
});

/*
	Class: Make
	Description: Wrapper to create Classes that make dinamically Elements.  
*/
var Make = new Class({
	Implements: [Options],
	options: {
		content: 'text'
	}
});

/*
	Filename: effects_base.js
	
	[Description] 
		Contains a collection of methods and utilities to work with effects based on Fx Classes.
	[/Description]
	
	[Credits]
		[li] some Fx Classes of the moo.rd Fx Repository are slightly inspired on those found in the Script.aculo.us library
	[/Credits]
	
	Contains: Class Fx, Class Element, Function fxToHash
	
	Requires: string.js
	
	[Summary]
		Fx ::: Extends the Fx Class for creating the moo.rd Effects Repository and fully-customizable effects
		Element ::: Adds Fx utility methods to the Element prototypes
		fxToHash --- Extends the Element.Properties Hash for using all the Fx effects as Element's dynamic shortcuts
	[/Summary]
*/
/*
	Class: Fx
	
	Description: Extends the Fx Class for creating the moo.rd Effects Repository and fully-customizable effects. 
	
	Extends: Class Fx
	
	[Methods]
		initStyles -- initializes all the styles you want for later usages
		removeAuto -- removes the 'auto' value from all the styles you want, to obtain a cross-browser feeling
		setPosition -- sets position's value to 'relative' if the element isn't positioned
	[/Methods]
*/
Fx.implement({
	
	/*
	Method: initStyles
	Description:  initializes all the styles you want for later usages
	*/
	initStyles: function() {
		this.init = {};
		$A(arguments).each(function(a) {
			if(a == 'opacity') this.init['opacity'] = this.element.get('opacity');
			else (this.element.getStyle(a).test('px')) ? this.init[a] = this.element.getStyle(a).toInt() : this.init[a] = this.element.getStyle(a);
		}, this);
		return this;
	},
	
	/*
	Method: removeAuto
	Description:  removes the 'auto' value from all the styles you want, to obtain a cross-browser feeling
	*/
	removeAuto: function() {
		if(!this.init) this.init = {};
		$A(arguments).each(function(a) {
			if(this.element.getStyle(a) == 'auto') { 
				this.element.setStyle(a, '0px');
				this.init[a] = 0;
			}
		}, this);
		return this;
	},
	
	/*
	Method: setPosition
	Description:  sets position's value to 'relative' if the element isn't positioned
	*/
	setPosition: function() {
		if(this.element.getStyle('position') == 'static') this.element.setStyle('position', 'relative');	
		return this;
	}
});

/*
	Class: Element
	
	[Description] 
		Adds Fx utility methods to the Element prototypes
	[/Description]
	
	Extends: Class Element
	
	[Methods]
		fx -- returns a determinate Fx instance you can pick out from the moo.rd Effects Repository
		effect -- sets a determinate Fx instance and start the effect immediately. Returns the element instead of fx method which returns an instance
		removeAuto -- removes the 'auto' value from all the styles you want of this element
	[/Methods]
*/	
Element.implement({
	
	/*
	Method: fx
	Description:  returns a determinate Fx instance you can pick out from the moo.rd Effects Repository
	[Arguments]
		eff :: the fx effect
		options :: optional. the effect options. Either if you use this argument or not, the instance will be the same
	[/Arguments]
	[Example]  
		> // use Fx.Fade
		> var fade = element.fx('fade');
		> fade.start('toggle');
		>  
		> // use Fx.Move
		> var move = element.fx('move', {duration:2000});
		> move.start(120, 58);
	[/Example]
	*/
	fx: function(eff, options) {
		if(!this.retrieve(eff)) this.store(eff, new Fx[eff.upperFirst()](this, options));
		return this.retrieve(eff);
	},
	
	/*
	Method: effect
	Description:  sets a determinate Fx instance and start the effect immediately. Returns the element instead of fx method which returns an instance
	[Arguments]
		eff :: the fx effect
		arguments :: the arguments to apply to the start method
	[/Arguments]
	[Example]  
		> // call an effect immediately
		> el.effect('fade');
		>
		> // set the instance options first
		> el.set('fade', {duration: 2000});
		> // call the effect later
		> el.effect('fade');
		> el.effect('fade', 'toggle');
		>
		> // move an element immediately
		> el.effect('move', 40, 440);
	[/Example]
	*/
	effect: function(fx) {
		this.get(fx).start.pass(Array.slice(arguments, 1), this.get(fx))();
		return this;
	},
	
	/*
	Method: removeAuto
	Description:  removes the 'auto' value from all the styles you want of this element.
	*/
	removeAuto: function() {
		$A(arguments).each(function(a) {
			if(this.element.getStyle(a) == 'auto') this.element.setStyle(a, '0px');
		}, this);
		return this;
	}
});

/*
	Function: fxToHash
	Description: Extends the Element.Properties Hash for using all the Fx effects as Element's dynamic shortcuts
	[Example]  
		> var el = $('element');
		>
		> // sets a Fx.Pulsate instance for later usage
		> el.set('pulsate', {times: 24});
		> // pulsate an element 24 times
		> el.effect('pulsate');
		>
		> // sets a Fx.SwitchOff instance an use it immediately
		> el.get('switchOff', {duration: 2000}).start();
	[/Example]
*/
var fxToHash = function(hash, effects) {
	Array.each(effects, function(fx, i) {
		var fx = fx.toString();
		var props = {
			set: function(options) {
				var tween = this.retrieve(fx);
				if (tween) tween.cancel();
				return this.eliminate(fx).store(fx + ':options', options);
			},
			
			get: function(options){
				if (options || !this.retrieve(fx)){
					if (options || !this.retrieve(fx + ':options')) this.set(fx, options);
					this.store(fx, new Fx[fx.upperFirst()](this, this.retrieve(fx + ':options')));
				}
				return this.retrieve(fx);
			}
		};
		hash.set(fx, props);
	});
};

/*
	Filename: effects_move.js
	
	[Description] 
		Contains a collection of effects based on the elements movement.
	[/Description]
	
	Contains: Class Fx.Shake, Class Fx.Move, Class Fx.Rumble, Class Fx.ScrollOut, Class Element
	
	Requires: effects_base.js
	
	[Summary]
		Fx.Shake ::: Shakes the element for a determinate number of times horizontally or vertically
		Fx.Move ::: Moves the element wherever you want
		Fx.Rumble ::: Enables a particular drag mode on the element
		Fx.ScrollOut ::: Scrolls an element out of his viewport
		Element ::: Extends the Element Class with Fx shortcuts
		Element.Properties ::: Extends the Element.Properties Hash with effects_move.js Fx effects
	[/Summary]
*/
/*
	Class: Fx.Shake
	
	[Description] 
		Shakes the element for a determinate number of times horizontally or vertically
	[/Description]
	
	Extends: Fx.Tween
	
	Constructor: new Fx.Shake (element, options)
	
	[Properties] 
		element - the element
		options - the Fx Options plus the following
	[/Properties]
	
	[Options]
		mode : the effect mode. Can be 'vertical' (height/top transition, default) or 'horizontal' (width/left transition)
		size : how far the element will be shaken in each direction. Default is 10
		times : how many tmes the element will be shaken. Default is 14  
	[/Options]
	
	[Methods]
		start -- starts the Fx.Shake effect
	[/Methods]

	Method: start
	Description: starts the Fx.Shake effect
	[Arguments]
		mode :: optional. the effect mode
	[/Arguments]
	[Example]  
		> var fx = new Fx.Shake('box');
		> fx.start();
	[/Example]
*/
Fx.Shake = new Class({
					 
	Extends: Fx.Tween,
	
	options: {
		mode: 'vertical',
		size: 10,
		link: 'chain',
		times: 14
	},
	
	initialize: function(element, options) {
		this.parent(element, options);
		switch(this.options.mode) {
			case 'horizontal': this.prop = 'left';
					  break;
			case 'vertical': this.prop = 'top';
					  break;
		};
		this.setPosition();
		this.element.setStyles({'overflow': 'hidden'});
		this.initStyles('top', 'left').removeAuto('top', 'left');
	},
	
	start: function(mode) {
		if(!mode) (this.options.mode == 'horizontal') ? this.prop = 'left' : this.prop = 'top';
		if(mode == 'vertical') this.prop = 'top';
		if(mode == 'horizontal') this.prop = 'left';
		for(var i=0; i<this.options.times; i++) {
			this.parent(this.prop, (i%2 == 0) ? this.options.size : -this.options.size);
		}
		this.parent(this.prop, 0);
	}
});

/*
	Class: Fx.Move
	
	[Description] 
		Moves the element wherever you want
	[/Description]
	
	Extends: Fx.Morph
	
	Constructor: new Fx.Move (element, options)
	
	[Properties] 
		options - the Fx Options
	[/Properties]
	
	[Methods]
		start -- starts the Fx.Move effect
	[/Methods]

	Method: start
	Description: starts the Fx.Move effect
	[Arguments]
		top :: the value of the top direction
		left :: the value of the left direction
	[/Arguments]
	[Example]  
		> var fx = new Fx.Move('box');
		> fx.start(20, 400);
	[/Example]
*/
Fx.Move = new Class({
					
	Extends: Fx.Morph,				
	
	initialize: function(element, options) {
		this.parent(element, options);
		this.setPosition().initStyles('top', 'left').removeAuto('top', 'left');
	},
	
	start: function(top, left) {
		if(!this.check(arguments.callee, top, left)) return this;
		return this.parent({
			'top': top,
			'left': left
		});
	}
});

/*
	Class: Fx.Rumble
	
	[Description] 
		Enables a particular drag mode on the element. When it will be released, an elastic transition will be fired
	[/Description]
	
	Extends: Fx.Morph
	
	Constructor: new Fx.Rumble (element, options)
	
	[Properties] 
		element - the element
		options - the Fx Options
	[/Properties]
	
	[Methods]
		start -- starts the Fx.Rumble effect
	[/Methods]

	Method: start
	Description: starts the Fx.Rumble effect
	[Example]  
		>  var fx = new Fx.Rumble('box');
		>  fx.start();
	[/Example]
	
	Method: detach
	Description: detaches the drag instance
	[Example]  
		>  fx.detach();
	[/Example]
*/
Fx.Rumble = new Class({
					  
	Extends: Fx.Morph,
	
	options: {
		duration: 800,
		transition: 'elastic:out'
	},
	
	initialize: function(element, options) {
		this.parent(element, options);
		this.setPosition();
		this.initStyles('top', 'left', 'cursor').removeAuto('top', 'left');
		this.obj = {'top': this.init.top, 
					'left': this.init.left
		};
	},

	start: function() {
		this.element.setStyle('cursor', 'move');
		var top = this.init.top; var left = this.init.left;
		var superMethod = arguments.callee;
		
		(!this.drag) ?
		this.drag = new Drag.Move(this.element, {
				onComplete: function() { 
					this.parentOf(superMethod, this.obj); 
				}.bind(this)
		}) : this.drag.attach();	
	},
	
	detach: function() {
		if(this.drag) this.drag.detach();	
		this.element.setStyle('cursor', this.init.cursor);
	}	
});

/*
	Class: Fx.ScollOut
	
	[Description] 
		Scrolls an element out of his viewport
	[/Description]
	
	Extends: Fx.Tween
	
	Constructor: new Fx.ScrollOut (element, options)
	
	[Properties] 
		options - the Fx Options
	[/Properties]
	
	[Methods]
		start -- starts the Fx.ScrollOut effect
	[/Methods]

	Method: start
	Description: starts the Fx.ScrollOut effect
	[Arguments]
		where :: The direction. Can be 'up' (default), 'down', 'left' or 'right'. If you pass 'reset' the position will be resetted
	[/Arguments]
	[Example]  
		> var fx = new Fx.ScrollOut('box');
		> // scroll up
		> fx.start('up');
		> // scroll left
		> fx.start('left');
	[/Example]
*/
Fx.ScrollOut = new Class({
					
	Extends: Fx.Tween,		
	
	initialize: function(element, options) {
		this.parent(element, options);
		this.setPosition();
		this.initStyles('top', 'left').removeAuto('top', 'left');
		this.wrapper = new Element('div', {
		'styles': {'overflow': 'hidden', 'width': this.element.getWidth(), 'position': 'relative'}}).wraps(this.element);
	},
	
	start: function(where) {
		if (!this.check(arguments.callee, where)) return this;
		if(where == 'up' || !where) return this.parent('top', -this.element.getHeight());
		if(where == 'down') return this.parent('top', this.element.getHeight());
		if(where == 'left') return this.parent('left', -this.element.getWidth());
		if(where == 'right') return this.parent('left', this.element.getWidth());
		if(where == 'reset') {
			if(this.element.getStyle('top').toInt() != this.init.top) return this.parent('top', this.init.top);
			if(this.element.getStyle('left').toInt() != this.init.left) return this.parent('left', this.init.left);	
		}
	}
});

/*
	Class: Element
	
	[Description] 
		Extends the Element Class with Fx shortcuts. 
		All these methods accept the same arguments of the relative Fx effect (obviously without the element)
	[/Description]
	
	Extends: Class Element
	
	[Methods]
		shake -- returns an Fx.Shake instance
		move -- returns an Fx.Move instance
		rumble -- returns an Fx.Rumble instance
		scrollOut -- returns an Fx.ScrollOut instance
	[/Methods]
*/	
Element.implement({
	
	/*
	Method: shake
	Description:  returns an Fx.Shake instance
	*/
	shake: function(options) {
		return new Fx.Shake(this, options);	
	},
	
	/*
	Method: move
	Description:  returns an Fx.Move instance
	*/
	move: function(options) {
		return new Fx.Move(this, options);	
	},
	
	/*
	Method: rumble
	Description:  returns an Fx.Rumble instance
	*/
	rumble: function(options) {
		return new Fx.Rumble(this, options);	
	},
	
	/*
	Method: scrollOut
	Description:  returns an Fx.ScrollOut instance
	*/
	scrollOut: function(options) {
		return new Fx.ScrollOut(this, options);	
	}
});

/*
	Hash: Element.Properties
	Description: Extends the Element.Properties Hash for using the effects_move.js Fx Classes as Element's dynamic shortcuts with the Element.effect method
*/
fxToHash(Element.Properties, ['shake', 'move', 'rumble', 'scrollOut']);