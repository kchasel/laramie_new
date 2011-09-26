// Scrolls the window to a given element
function scroller(element) {
	new Fx.SmoothScroll(window).toElement(element);
}

function stickyBox(box, track) {
	window.date_finder_pos = $('date_finder').getPosition().y - 10;
	window.addEvent('scroll', function() {
		if (window.getScroll().y >= window.date_finder_pos) {
			box.setStyles({'position': 'absolute', 'top': window.getScroll().y - window.date_finder_pos, 'left': 0});
		}
		else {
			box.setStyles({'position': 'absolute', 'top': 0, 'left': 0});
		}
	});
}

// Function to replace submit image with spinner and disable as long as the request is underway. Only added to ajax forms.
function forms_setup() {
	var forms = $$('form');
	var light_spinner = new Asset.image('/assets/support/spinner-light.gif');
	var dark_spinner = new Asset.image('/assets/support/spinner-dark.gif');
	forms.each(function(form) {
		if (form.match(['form[data-remote="true"]'])) {
			form.addEvent('submit', function() {
				submit_tag = form.getElement('input[type=image]');
				form.getElement('input[type=text]').disabled=true;
				cur_url = submit_tag.src;
				submit_tag.disabled=true;
				// If the form is in the rightbar, use the dark spinner, otherwise use the light one
				if(form.match('.rightbox form')) {
					submit_tag.src = dark_spinner.src;
				}
				else {
					submit_tag.src = light_spinner.src;
				}
			});
			form.addEvent('ajax:complete', function() {
				form.getElement('input[type=image]').src = cur_url;
				form.getElement('input[type=text]').disabled=false;
				submit_tag.disabled=false;
			});
		}
		if(!form.match('.rightbox form')) {
			var text_boxes = form.getElements('input[type=text]');
			text_boxes.each(function(tb) {
					tb.addEvent('focus', function() {
						tb.addClass('focused');
					});
					tb.addEvent('blur', function() {
						tb.removeClass('focused');
					});
			});
		}
		else {
			var text_boxes = form.getElements('input[type=text]');
			text_boxes.each(function(tb) {
					tb.addEvent('focus', function() {
						tb.addClass('focused_rb');
					});
					tb.addEvent('blur', function() {
						tb.removeClass('focused_rb');
					});
			});
		}
	});
}

function complete_donation() {
	if($('prefab').value!='other'){
		$('amount').value=$('prefab').value;
		this.commit.disabled=true;
		return true;
	}
	else {
		if($('custom').value=='' || isNaN($('custom').value)==true || $('custom').value <= 0){
			new Fx.Shake($('donate_status'), {duration: 80, mode: 'horizontal', times: 8}).start();
			(function(){ $('custom').value='' }).delay(500);
			if($('donate_label')) {
				$('donate_label').getElement('h2').set({html: "<h2>Donate | <span class='alert'>Please try again</span></h2>"});
				//$('donate_label')
			}
			return false;
		}
		else {
			$('amount').value=$('custom').value;
			return true;
		}
	}
}

function slide_other() {
	new Fx.Reveal($('custom'), { mode: 'horizontal'}).toggle();
}

function clearForm(form) {
	var frm_elements = form.elements;
	for (i=0; i<frm_elements.length; i++) {
		field_type = frm_elements[i].type.toLowerCase();
		switch(field_type) {
			case "text":
			case "password":
			case "textarea":
			
			frm_elements[i].value = "";
			break;
			
			case "radio":
			case "checkbox":
			
			if (frm_elements[i].checked) {
				frm_elements[i].checked = false;
			}
			break;
			
			case "select-one":
			case "select-multi":
			
			frm_elements[i].value = "Wyoming";
			break;
			
			default:
			break;
		}
	}
}


function reveal_boxes(el) {
	
	boxes = el.getChildren();
	
	boxes.each(function(box, index, array){
		
		var size = box.getSize();
		var pos_y = box.getStyle('left');
		
		var open = new Fx.Morph(box, {link: 'cancel'});
		
		box.addEvents({
			'mouseenter': function(){
				box.setStyle('z-index', '5');
				open.start({
					'width': '100%',
					'left': '0'
				});
			},
			'mouseleave': function() {
				open.start({
					'left': pos_y,
					'width': size.x
			}).chain(function(){box.setStyle('z-index', '1');});
			}
		});
	});
}