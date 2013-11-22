# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$('table thead tr th').each ->
		$(this).css('min-width', $(this).css('width'))
	$('#release_id').change ->
		$.ajax({
			url: '/menuitems/index_tbody',
			data: {release_id: this.value},
			cache: false,
			success: (html) ->
				$('#index_tbody').html(html)
				$('#index_tbody').css('visibility', 'visible')
		})
	$('#release_id').change()
