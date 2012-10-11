// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function get_order_id() {
	return (
	document.getElementById('order_id_to_edit').value.replace(/^0+/, ''));
}

function key_up(e) {
	var c = (e.keyCode != 0 ? e.keyCode : e.charCode);
	switch (c) {
	case 13: // Enter
		var elem = e.srcElement || e.target;
		if (elem.id == 'order_id_to_edit') {
			link_to_edit();
		}
		break;
	case 27: // Esc
		set_focus('order_id_to_edit');
		break;
	default:
		//alert(c);
		break;
	}
}

function link_to_edit() {
	var order_id = parseInt(get_order_id());
	if (0 < order_id) {
		window.open("/store/edit/"+order_id, "_top");
	}
}

function link_to_show() {
	var order_id = parseInt(get_order_id());
	if (0 < order_id) {
		window.open("/store/show/"+order_id, "_top");
	}
}

function set_focus(element_id) {
	var elem = document.getElementById(element_id);
	if (elem) {
		elem.focus();
	}
}
