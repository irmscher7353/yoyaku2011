# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	if $('table#menuitems').size()
		$('table thead tr th').each ->
			$(this).css('min-width', $(this).css('width'))
	$('#release_id').change()
