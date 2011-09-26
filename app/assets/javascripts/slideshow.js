window.addEvent('domready', function() {
	// settings
	var showDuration = 8000;
	var fadeDuration = 2500;
	var container = $('slideshow-container');
	var images = container.getElements('img');
	var currentIndex = 0;
	var interval;
	// opacity and fade
	images.each(function(img, i){
		if (i > 0) {
			img.set('opacity',0);
		}
	});
	// worker
	var show = function() {
		new Fx.Tween(images[currentIndex], { 'duration': fadeDuration}).start('opacity', 0);
		new Fx.Tween(images[currentIndex = currentIndex < images.length - 1 ? currentIndex+1 : 0], {'duration': fadeDuration}).start('opacity', 1);
	};
	window.addEvent('load', function() {
		interval = show.periodical(showDuration);
	});
});