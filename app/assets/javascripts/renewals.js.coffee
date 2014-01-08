# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#add-duty-field').click (event) ->
		event.preventDefault()
		orig = $('#duty-field-a input')
		clone = orig.clone()
		count = $("#duty-fields input").length + 1
		clone.attr("id", "renewal_duties_attributes_" + count + "_week_containing")
		clone.attr("name", "renewal[duties_attributes][" + count + "][week_containing]")
		clone.appendTo('#duty-fields')
		orig.val("")

