function getWindowHeight() {
    var windowHeight = 0;
    if (typeof(window.innerHeight) == 'number') {
        windowHeight = window.innerHeight;
    }
    else {
        if (document.documentElement && document.documentElement.clientHeight) {
            windowHeight = document.documentElement.clientHeight;
        }
        else {
            if (document.body && document.body.clientHeight) {
                windowHeight = document.body.clientHeight;
            }
        }
    }
    return windowHeight;
}

function stickToBottom() {
	if (document.getElementById) {
		var windowHeight=getWindowHeight();
		if (windowHeight > 0) {
			var mainbox = document.getElementById("main");
			mainbox.style.height="auto";
			var mainHeight = mainbox.offsetHeight;
			var footer=document.getElementById('footer');
			var footerHeight = footer.offsetHeight;
			if ((mainHeight + footerHeight) < windowHeight) {
				mainbox.style.height=(windowHeight - 100 - footerHeight + 'px');
			}
		}
	}
}