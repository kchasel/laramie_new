window.addEvent('domready', function() {
	window.expanded = false;
})

function expand_column() {
	left = $('col1');
	right = $('col2');
	expand_amount = 100;
	
	var leftfx = new Fx.Morph(left);
	var rightfx = new Fx.Morph(right);
	
	
	rightreturn = right.getStyle('width', {link: 'cancel'});
	leftreturn = left.getStyle('width', {link: 'cancel'});
	
	
	if (window.expanded==false) {
		rightfx.start({
			'width': rightreturn.toInt()+expand_amount
		});
		leftfx.start({
			'width': leftreturn.toInt()-expand_amount,
			'opacity': 0.5
		});
		window.expanded = true;
	}
	else {
		rightfx.start({
			'width': rightreturn.toInt()-expand_amount
		});
		leftfx.start({
			'width': leftreturn.toInt()+expand_amount,
			'opacity': 1
		});
		window.expanded = false;
	}
}
