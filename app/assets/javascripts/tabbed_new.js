/* Tabber tabbed box construction

Author:
	kchasel, kchasel25 [at] gmail.com
	
License:
	MIT License
	
Class:
	Tabber (rev.26/8/11)
	
Arguments:
	Parameters: see below
	Options: see below
	
Parameters:

*/

String.implement({
	tabbify : function() {
		return this.toLowerCase().replace(/ /gi, "_").replace(/&/gi, "and")
	}
});

var Tabber = new Class({
	Implements: [Options, Events],
	
	options: {
		durationtabsslide: 450,
		durationchange: 400,
		tabtransition: Fx.Transitions.Cubic.easeOut
	},
	
	initialize: function(params, options) {
		this.setOptions(options);
		this.box = params.box;
		//this.tabholderclass = this.box.getElements('div.'+)
		this.bodyclass = params.bodyclass;
		this.body_div = this.box.getElement('div.'+this.bodyclass);
		this.default_height = this.body_div.getStyle('height');
		this.tabs = this.getTabs();
		this.url = params.url;
		this.urlparam = params.urlparam;
		this.cssclass = params.selectedclass;
		this.hometab = params.hometab;
		
		this.addEvent('tabChanged', function(){ 
			this.update_box();
			//window.location.hash = '#' + this.activetab.get('text').tabbify();
		});
		
		this.key = window.location.hash.split('#')[1] || 'home';
		
		this.tweener = new Fx.Tween(this.body_div, {link: 'cancel', duration: 150, mode: 'horizontal'});
		
		this.activetab = this.find_associated_tab(this.key);
		
		this.change_tab(this.activetab);
		
		this.slideInTabs();
		
		this.tabs.each( function(item, index) {
			item.addEvent('click', this.change_tab.pass(item, this));
			item.set('href', "#" + item.getProperty('text').tabbify());
		}, this);
		
	},
	
	getTabs : function() {
		return this.box.getElements('li');
	},
	
	find_associated_tab : function(key_to_find) {
		var thistab = this.tabs.filter( function(item) { 
			return item.getElement('a').getProperty('text').tabbify() == key_to_find;
		});
		return thistab;
	},
	
	change_tab : function(tab) {
		if(this.activetab) this.activetab.removeClass('selected');
		this.activetab = tab;
		this.activetab.addClass('selected');
		this.fireEvent('tabChanged');
		//TODO : update URL hash
	},
	
	slideInTabs : function() {
		this.tabs.each(function(item, index) {
			var slide = new Fx.Slide(item, {duration: this.options.durationtabsslide, chain: 'chain', mode: 'horizontal', transition: Fx.Transitions.Cubic.easeOut});
			slide.hide();
			slide.slideIn.delay(100*index, slide); //bind the delay to the current slide function
		}, this);
	},
	
	update_box : function() {
		var this_class = this;
		var div = this.body_div.getElement('div');
		this.tweener.start('opacity', 0).chain(function() {
			new Request.HTML({data:rails.csrf.param + "=" + rails.csrf.token, method: 'get', async: false, evalScripts: true, update: div,
			url: this_class.url+'?'+this_class.urlparam+'='+this_class.activetab.get('text').tabbify(), onComplete: this.callChain()}).send()},
			function() { this.start('opacity', 1); },
			function() { var height = div.getSize().y;
						if(height.toInt() < this_class.default_height.toInt()) {
							height = this_class.default_height;
						}
						new Fx.Tween(this_class.body_div, { duration: this_class.options.durationchange, link: 'cancel',
						transition: Fx.Transitions.Quad.easeInOut}).start('height', height);
			}
		);
	}
});