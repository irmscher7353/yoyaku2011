// vim:ts=4:sw=4
/*----------------------------------------------------------------------------
 */
current_line = 0
current_titlepage = 1
/*----------------------------------------------------------------------------
 */
function add_char(where, obj) {
	// name フィールドの値（文字列）に obj のラベルに表示されている文字を追加
	// する．
	var f = document.getElementById("order_"+where);
	c = obj.innerHTML;
	switch (c) {
	case "←":
		if (0 < f.value.length) {
			f.value = f.value.slice(0, -1);
		}
		break;
	case "スペース":
		f.value += "　";
		break
	default:
		f.value += c;
		break;
	}
	if (where == 'name') {
		name_modified();
	} else {
		update_button_state();
	}
	if (f) {
		f.focus();
	}
}
/*----------------------------------------------------------------------------
 */
function add_note(phrase) {
	var text_area = document.getElementById("order_note");
	var text_value = text_area.value;
	if (text_value.indexOf(phrase) < 0) {
		if (text_value != "" && text_value.slice(-1) != "\n") {
			text_value += "\n";
		}
		text_value += phrase + "\n";
		text_area.value = text_value;
		update_button_state();
	}
}
/*----------------------------------------------------------------------------
 */
function calc_subtotal(index, flag) {
	// cart_item 行の小計を計算し，合計を更新する．
	if (flag == null) {
		flag = true;
	}
	var price = parseInt(document.getElementById("price_"+index).value);
	var quantity = parseInt(document.getElementById("quantity_"+index).value);
	var subtotal = price*quantity;
	var input = document.getElementById("subtotal_"+index);
	var span = document.getElementById("subtotal_text_"+index);
	if (0 < subtotal) {
		input.value = subtotal;
		span.innerHTML = number_to_currency(subtotal);
	} else {
		input.value = 0;
		span.innerHTML = "";
	}
	if (flag) {
		calc_total();
	}
}
/*----------------------------------------------------------------------------
 */
function calc_subtotals() {
	// 各行の小計を再計算する．
	for (var i=1; i<=num_lines; ++i) {
		var remain = document.getElementById("remain_"+i).value;
		if (remain != "") {
			set_remain_text(i, remain);
		}
		calc_subtotal(i, false);
	}
}
/*----------------------------------------------------------------------------
 */
function calc_total() {
	// 合計を計算する．
	var total = 0;
	for (var i=1; i<=num_lines; ++i) {
		var input = document.getElementById("subtotal_"+i);
		var subtotal = parseInt(input.value);
		if (0 < subtotal) {
			total += subtotal;
		}
	}
	document.getElementById("total").value = total;
	document.getElementById("total_text").innerHTML = number_to_currency(total);
	update_button_state();
}
/*----------------------------------------------------------------------------
 */
function clear_line(index) {
	var prefix_list = ["title", "size", "productid", "price", "quantity", "subtotal" ];
	for (var i=0; i<prefix_list.length; ++i) {
		var prefix = prefix_list[i];
		document.getElementById(prefix+"_"+index).value = "";
	}
}
/*----------------------------------------------------------------------------
 */
function clear_lines() {
	for (var i=1; i<=num_lines; ++i) {
		clear_line(i);
	}
}
/*----------------------------------------------------------------------------
 */
function close_seimei(keep_focus) {
	var t = document.getElementById("seimei");
	t.innerHTML = "";
	t.style.display = "none";
	var f = document.getElementById(keep_focus ? "order_name" : "order_phone");
	f.focus();
}
/*----------------------------------------------------------------------------
 */
function close_reminder() {
	document.getElementById("reminder").style.display = "none";
}
/*----------------------------------------------------------------------------
 */
function due_date_modified() {
	update_weekday();
	update_button_state();
}
/*----------------------------------------------------------------------------
 */
function due_time_modified() {
	var date_string = "2000/01/01 ";
	var due_time_min_value = document.getElementById("due_time_min").value;
	var due_time_max_value = document.getElementById("due_time_max").value;
	var due_time_min = new Date(date_string+due_time_min_value);
	var due_time_max = new Date(date_string+due_time_max_value);
	var hour_field = document.getElementById("order_due_hour");
	var minute_field = document.getElementById("order_due_minute");
	var hour = parseInt(hour_field.value);
	var minute = parseInt(minute_field.value);
	var message = "";
	if (!isNaN(hour) && !isNaN(minute)) {
		var due_time = new Date(date_string+hour+":"+minute);
		if (due_time < due_time_min) {
			due_time = due_time_min;
			message = "invalid";
		}
		if (due_time_max < due_time) {
			due_time = due_time_max;
			message = "invalid";
		}
	}
	if (message != "") {
		message = "引渡し時間は " + due_time_min_value + " から "
			+ due_time_max_value + " までしか指定できません．";
		alert(message);
		hour = due_time.getHours();
		minute = due_time.getMinutes();
		hour_field.value = hour;
	}
	minute_field.value = (minute < 10 ? "0" : "")+minute;
	update_button_state();
}
/*----------------------------------------------------------------------------
 */
function incr_quantity(number) {
	if (current_line < 1 || num_lines < current_line) {
		return;
	}
	current_line -=
	(document.getElementById("title_"+current_line).value == "" ? 1 : 0);
	var input = document.getElementById("quantity_"+current_line);
	var quantity = parseInt(input.value);
	set_quantity(quantity+number);
}
/*----------------------------------------------------------------------------
 */
function move_titlepage(number) {
	set_titlepage(current_titlepage + number);
}
/*----------------------------------------------------------------------------
 */
function name_modified(obj) {
	var f = document.getElementById('order_name');
	document.getElementById('name').value = f.value;
	if (obj) {
		// called from order_name.onChange
	} else {
		// called from add_char() method
		document.getElementById('find_seimei').click();
	}
	var t = document.getElementById('seimei');
	t.style.display = "";
	update_button_state();
}
/*----------------------------------------------------------------------------
 */
function number_to_currency(value, prefix) {
	var result = "";
	if (prefix == undefined) {
		prefix = "";
	}
	while (0 < value) {
		var mod = value % 1000;
		if (result != "") result = "," + result;
		value = (value - mod)/1000;
		if (0 < value) {
			result = ("00"+mod).slice(-3) + result;
		} else {
			result = mod + result;
		}
	}
	if (result == "") result = "0";
	return prefix+result;
}
/*----------------------------------------------------------------------------
 */
function print_direct(printer_name) {
	// http://jsprintsetup.mozdev.org/reference.html
	// http://msdn.microsoft.com/en-us/library/dd319099%28v=vs.85%29.aspx
	if (window.hasOwnProperty('jsPrintSetup')) {
		if (printer_name != '') {
			jsPrintSetup.setPrinter(printer_name);
		}
		jsPrintSetup.setOption('paperData', 'DMPAPER_B5');
		jsPrintSetup.setOption('orientation', jsPrintSetup.kLandscapeOrientation);
		jsPrintSetup.setOption('marginTop', 10);
		jsPrintSetup.setOption('marginRight', 10);
		jsPrintSetup.setOption('marginBottom', 10);
		jsPrintSetup.setOption('marginLeft', 10);
		jsPrintSetup.setOption('headerStrLeft', '');
		jsPrintSetup.setOption('headerStrCenter', '');
		jsPrintSetup.setOption('headerStrRight', '');
		jsPrintSetup.setOption('footerStrLeft', '');
		jsPrintSetup.setOption('footerStrCenter', '');
		jsPrintSetup.setOption('footerStrRight', '');
		jsPrintSetup.setOption('printBGColors', 1);
		jsPrintSetup.setOption('printBGImages', 1);
		jsPrintSetup.setSilentPrint(true);
		jsPrintSetup.print();
		jsPrintSetup.clearSilentPrint();
	} else {
		window.print();
	}
}

/*----------------------------------------------------------------------------
 */
function set_current_line(index) {
	for (var i=1; i<=num_lines; ++i) {
		var line = document.getElementById("line_"+i);
		if (line.id == "line_"+index) {
			line.style.background = "wheat";
		} else {
			line.style.background = "transparent";
		}
	}
	if (1 <= index && index <= num_lines) {
		show_selector("item_selector");
	} else {
		show_selector("blank_selector");
	}
	current_line = index;
}
/*----------------------------------------------------------------------------
 */
function set_due(where, value) {
	var f = document.getElementById("order_due_"+where);
	f.value = value;
	if (where == "year" || where == "month" || where == "day") {
		due_date_modified();
	} else {
		due_time_modified();
	}
	f.focus();
}
/*----------------------------------------------------------------------------
 */
function set_order_id_to_edit(input) {
	var a = document.getElementById("link_to_edit");
	var i = parseInt(input.value);
	var f = 0 < i;
	if (f) {
		a.href = "/store/edit/"+i;
	} else {
		a.href = "";
	}
}
/*----------------------------------------------------------------------------
 */
function set_quantity(quantity) {
	if (current_line < 1 || num_lines < current_line) {
		return;
	}
	var input = document.getElementById("quantity_"+current_line);
	var old_value = input.value;
	var remain = parseInt(document.getElementById("remain_"+current_line).value);
	if (1 <= quantity && (remain < 0 || quantity <= remain)) {
		input.value = quantity;
		calc_subtotal(current_line);
		if (current_line < num_lines && old_value == "") {
			current_line += 1;
			input = document.getElementById("title_"+current_line);
		}
	}

	input.focus();
}
/*----------------------------------------------------------------------------
 */
function set_remain_text(index, remain) {
	var remain_text = remain < 0 ? "" : remain == 0 ? "完売" : remain;
	document.getElementById("remain_text_"+index).innerHTML = remain_text;
}
/*----------------------------------------------------------------------------
 */
function set_seimei(str) {
	if (str == "×") {
		close_seimei(true);
	} else {
		var f = document.getElementById('order_name');
		var s = f.value;
		if (s.match(/　/)) {
			f.value = s.split(/　/)[0] + '　' + str;
			close_seimei(false);
		} else {
			f.value = str + '　';
			name_modified();
		}
	}
}
/*----------------------------------------------------------------------------
 */
function set_size(size, productid, price, remain) {
	if (current_line < 1 || num_lines < current_line) {
		return;
	}
	var input = document.getElementById("size_"+current_line);
	input.value = size;
	document.getElementById("productid_"+current_line).value = productid;
	document.getElementById("price_"+current_line).value = price;
	document.getElementById("remain_"+current_line).value = remain;
	set_remain_text(current_line, remain);
	var input = document.getElementById("quantity_"+current_line);
	if (0 < remain && remain < input.value) {
		input.value = remain;
	}
	calc_subtotal(current_line);
	input.focus();
}
/*----------------------------------------------------------------------------
 */
function set_title(title, titleid) {
	if (current_line < 1 || num_lines < current_line) {
		return;
	}
	var input =document.getElementById("title_"+current_line);
	input.value = title;

	document.getElementById("size_"+current_line).value = "";

	var target_id = 'products_of_title_'+titleid;
	var div_list
	= document.getElementById("size_selector").getElementsByTagName("div");
	for (var i=0; i<div_list.length; ++i) {
		var div = div_list[i];
		if (div.id == target_id) {
			div.style.display = "block";
		} else {
			div.style.display = "none";
		}
	}

	var button_list
	= document.getElementById(target_id).getElementsByTagName("button");
	if (button_list.length <= 1) {
		button_list[0].click();
	} else {
		document.getElementById("size_"+current_line).focus();
	}
}
/*----------------------------------------------------------------------------
 */
function set_titlepage(index) {
	var n = num_titlepages;
	if (index < 1 || n < index) {
		return;
	}
	for (var i=1; i<=n; ++i) {
		document.getElementById("titlepage_"+i).style.display
		= i == index ? "" : "none";
	}
	document.getElementById("prev_titlepage").disabled
	= index <= 1 ? "disabled" : "";
	document.getElementById("next_titlepage").disabled
	= n <= index ? "disabled" : "";
	current_titlepage = index;
}
/*----------------------------------------------------------------------------
 */
function show_selector(which) {
	var id_list = {
		"blank_selector"  : ["blank_selector" ],
		"numbers"         : ["numbers" ],
		"address_selector": ["address_selector" ],
		"due_selector"    : ["due_selector" ],
		"item_selector"   : [
			"titlepage_selector",
			"title_selector", "size_selector", "quantity_selector"
			],
		"kanapad"         : ["kanapad" ]
	};
	for (id in id_list) {
		var display = id == which ? "" : "none";
		for (var i=0; i<id_list[id].length; ++i) {
			document.getElementById(id_list[id][i]).style.display = display;
		}
	}
	var display = which == "kanapad" ? "none" : "";
	var id_list = ["payment", "means", "checkout" ];
	for (var i=0; i<id_list.length; ++i) {
		document.getElementById(id_list[i]).style.display = display;
	}
}
/*----------------------------------------------------------------------------
 */
function start_edit(order_id, state) {
	document.getElementById("order_id_to_edit").value = order_id;
	calc_total();
	var input = document.getElementById("register");
	input.value = "予約修正";
	input.disabled = "disabled";
	var display, disabled;
	var input = document.getElementById("deliver");
	if (document.getElementById("order_id").value == "") {
		display = "none"
		disabled = "";
	} else {
		display = "block"
		disabled = state == "" ? "" : "disabled";
	}
	input.style.display = display;
	input.disabled = disabled;
	document.getElementById("cancelbutton").style.display
	= state == "" ? "block" : "none";
	document.getElementById("revertbutton").style.display
	= state == "キャンセル" ? "block" : "none";
}
/*----------------------------------------------------------------------------
 */
function start_show(order_id) {
	document.getElementById("order_id_to_edit").value = order_id;
	if (window.hasOwnProperty('jsPrintSetup')) {
		document.getElementById('print_direct').style.display = 'block';
	} else {
		document.getElementById('print_preview').style.display = 'block';
	}
}
/*----------------------------------------------------------------------------
 */
function update_button_state() {
	var invalid = "";
	if (document.getElementById("order_name").value == "") {
		invalid += " name";
	}
	if (document.getElementById("order_phone").value == "") {
		invalid += " phone";
	}
	if (document.getElementById("order_address").value == "") {
		//invalid += " address";
	}
	var month = parseInt(document.getElementById("order_due_month").value);
	if (isNaN(month) || month < 1 || 12 < month) {
		invalid += " month";
	}
	var day = parseInt(document.getElementById("order_due_day").value);
	if (isNaN(day) || day < 1 || 31 < day) { // realy?
		invalid += " day";
	}
	var hour = parseInt(document.getElementById("order_due_hour").value);
	if (isNaN(hour)) {
		invalid += " hour";
	}
	var minute = parseInt(document.getElementById("order_due_minute").value);
	if (isNaN(minute)) {
		invalid += " minute";
	}
	var total = parseInt(document.getElementById("total").value);
	if (isNaN(total) || total <= 0) {
		invalid += " total";
	}
	if (document.getElementById("payment_none").checked ==
		document.getElementById("payment_done").checked) {
		invalid += " payment";
	}
	if (document.getElementById("means_phone").checked ==
		document.getElementById("means_visit").checked) {
		invalid += " means";
	}
	var disabled = invalid == "" ? "" : "disabled";
	document.getElementById("register").disabled = disabled;
	var button = document.getElementById("deliver");
	button.style.display
	= document.getElementById("order_id").value == "" ? "none" : "block";
	button.disabled
	= document.getElementById("payment_done").checked ? "" : "disabled";
}
/*----------------------------------------------------------------------------
 */
function update_weekday() {
	// 曜日表示を更新する．
	var wdays = "日月火水木金土";
	var yyyy = document.getElementById("order_due_year").value;
	var mm = document.getElementById("order_due_month").value;
	var dd = document.getElementById("order_due_day").value;
	var wday = "－";
	if (yyyy != "" && mm != "" && dd != "") {
		var d = new Date(parseInt(yyyy), parseInt(mm)-1, parseInt(dd));
		wday = wdays.charAt(d.getDay());
	}
	document.getElementById("weekday").innerHTML = wday;
}

/*----------------------------------------------------------------------------
 */
var Summary = function() {
}

Summary.expandColumns = function(dkey) {
	this.toggleColumns(dkey, false);
	return false;
};

Summary.shrinkColumns = function(dkey) {
	this.toggleColumns(dkey, true);
	return false;
}

Summary.toggleColumns = function(dkey, flag) {
	var tags=document.getElementsByName(dkey);
	for (var i=0; i<tags.length; ++i) {
		var tag=tags[i];
		if (1 < tag.getAttribute('colspan')) {
			tag.style.display = flag ? "" : "none";
		} else {
			tag.style.display = flag ? "none" : "";
		}
	}
};

