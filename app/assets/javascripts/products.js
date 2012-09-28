/*----------------------------------------------------------------------------
 * vim:ts=4:sw=4
 */
var Products = function () {
	this.on_submit = false;
}

Products.showWarning = function (old_value, new_value) {
	var limitation_field = document.getElementById("product_limitation");
	var submit_button = document.getElementById("commit");
	alert("予約済みの数に足りなくなるので，限定数を " + old_value + " から " + new_value + " に変更できません！");
	limitation_field.focus();
	submit_button.disabled = false;
};

Products.limitationModified = function () {
	// views/products/_form.html.erb で，limitation の数が変更された時に，
	// remain の値を連動させる．
	var limitation_field = document.getElementById("product_limitation");
	var old_limitation_field = document.getElementById("old_limitation");
	var product_remain_field = document.getElementById("product_remain");
	var submit_button = document.getElementById("commit");
	var old_value = parseInt(old_limitation_field.value);
	var new_value = parseInt(limitation_field.value);
	var old_remain = parseInt(product_remain_field.value);
	if (old_value < 0 || new_value < 0) {
		// 限定なしから限定あり，または，ありからなしに変更された．
		product_remain_field.value = new_value;
	} else {
		// 限定数が変更された．
		var delta = new_value - old_value;
		var new_remain = old_remain + delta;
		if (new_remain < 0) {
			submit_button.disabled = true;
			limitation_field.value = old_value;
			setTimeout(this.showWarning(old_value, new_value), 100);
		} else {
			old_limitation_field.value = new_value;
			product_remain_field.value = new_remain;
		}
	}
};

Products.titleSelected = function (who) {
	// views/products/_form.html.erb で，品名選択用の <select> の値が変更
	// された時に，title_id フィールドの値を連動させる．
	document.getElementById("product_title_id_field").value = who.value;
	document.getElementById("product_title_id").value = who.value;
};
