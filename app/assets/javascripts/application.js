// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function link_to_edit() {
	var order_id = parseInt(document.getElementById("order_id_to_edit").value);
	if (0 < order_id) {
		window.open("/store/edit/"+order_id, "_top");
	}
}

function link_to_show() {
	var order_id = parseInt(document.getElementById("order_id_to_edit").value);
	if (0 < order_id) {
		window.open("/store/show/"+order_id, "_top");
	}
}
