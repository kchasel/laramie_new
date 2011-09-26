function tb_update(element, key) {
	if(oldkey==key){
		key='home'
	}

	var tween = new Fx.Tween(body_content_div, {link: 'cancel', duration: 150, mode: 'horizontal'}).start('opacity', 0).chain(
		function() { new Request.HTML({data:rails.csrf.param + '=' + rails.csrf.token, 
		method: 'get', async: false, evalScripts:true, update:body_content_div, url:'/main/info_link?sec='+key, onComplete: this.callChain()}).send()},
		function() { this.start('opacity', 1); },
		function() {
			height = body_content_div.getSize().y;
			if(height.toInt()<default_height_tabbox.toInt()) 
				height = default_height_tabbox;
			new Fx.Tween(body_div, {duration: 400, link: 'cancel', transition: Fx.Transitions.Quad.easeInOut}).start('height', height);
		}
	);

	oldkey = key;
	
	tabs.each(function(item, index) {
		if(key=='home')
			item.getElement('a').removeClass('selected');
		else if(item.getElement('a')==element) {
			item.getElement('a').addClass('selected');
		}
		else
			item.getElement('a').removeClass('selected');
	});
}



function tabbox_setup() {
	tabbed_box_div = $(document.body).getElement('div.tabbed-box');
	tabs_div = tabbed_box_div.getElement('div.tabs');
	body_div = tabbed_box_div.getElement('div.body');
	body_content_div = body_div.getElement('div');
	tabs = get_all_tabs(tabbed_box_div);
	default_height_tabbox = body_div.getStyle('height');
	var fun = [];
	oldkey = 'home';
	tabs.each(function(item, index) {
		var slide = new Fx.Slide(item, {duration: 450, chain: 'chain', mode: 'horizontal', transition: Fx.Transitions.Cubic.easeOut});
		slide.hide(); 
		fun[index] = function() { slide.slideIn() }.delay(100*index);
	})
	/*fun.each(function(item, index) { item() })*/
}

function get_all_tabs(box_element) {
	return box_element.getElements('li');
}