window.addEvent('domready', function() {
	forms = $$('form');
	forms.each(function(form){
		form.addEvent('submit', function() {
			form.getElement("input[type=submit]").disabled=true;
		})
	})
})

function new_attachment_field() {
	var rand = Number.random(1,10000);
	return new_field = new Elements([new Element('br'), new Element('input', {type: "file", name: "message[attachments][]"})]);
}