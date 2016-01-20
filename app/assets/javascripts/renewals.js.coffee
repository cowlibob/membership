# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('*[data-required="true"]').change (event) ->
		count = $('*[data-required=true] input:not(:valid)').length
		if(count == 0)
			$('input[type=submit].button.disabled').each (index, element) ->
				$(element).removeClass("disabled")

	$('input[type=submit].button.disabled').click (event) ->
		invalid = $('*[data-required=true] input:not(:valid)')[0]
		$('section.active').each (index, element) ->
			$(element).removeClass('active')

		$($(invalid).parents('section')[0]).addClass('active')

		# event.preventDefault() if $(this).hasClass('disabled')
		true

	$('.button.membership-select').click (event) ->
		event.preventDefault()
		$('.row#renewal-details, .row#renewal-button').each (index, element) ->
			$(element).removeClass('off')
		true

	# $('#add-family-member-field').click (event) ->
	# 	event.preventDefault()
	# 	orig = $('#new-member')
	# 	clone = orig.clone()
	# 	count = $("#member-fields .row").length + 1

	# 	clone.find('label').each (index, element) ->
	# 		element.htmlFor = element.htmlFor.replace(0, count)
	# 	clone.find('input, select').each (index, element) ->
	# 		element.id = element.id.replace(0, count)
	# 		element.name = element.name.replace(0, count)
	# 		$(element).attr('required', false)

	# 	clone.appendTo('#member-fields')

	$('#add-boat-field').click (event) ->
		event.preventDefault()
		orig = $('#new-boat')
		clone = orig.clone()
		count = $("#boat-fields .row").length + 1

		clone.find('label').each (index, element) ->
			element.htmlFor = element.htmlFor.replace(0, count)
		clone.find('input, select').each (index, element) ->
			element.id = element.id.replace(0, count)
			element.name = element.name.replace(0, count)
			$(element).attr('required', false)
		clone.find('select')[0].selectedIndex = orig.find('select')[0].selectedIndex


		orig.find('input').each (index, element) ->
			$(element).val('')
		orig.find('select').each (index, element) ->
			$(element).val('request')

		clone.appendTo('#boat-fields')
		true

	# $('#add-duty-field').click (event) ->
	# 	event.preventDefault()
	# 	orig = $('#new-duty')
	# 	clone = orig.clone()
	# 	count = $("#duty-fields input").length + 1
	#
	# 	# Date
	# 	input = clone.find('input')
	# 	input.attr("id", "renewal_duties_attributes_" + count + "_week_containing")
	# 	input.attr("name", "renewal[duties_attributes][" + count + "][week_containing]")
	#
	# 	# Preference
	# 	select = clone.find('select')
	# 	select.attr("id", "renewal_duties_attributes_" + count + "_preference")
	# 	select.attr("name", "renewal[duties_attributes][" + count + "][preference]")
	# 	select.val(orig.find('select').val())
	#
	# 	# Cleanup
	# 	orig.find('input').val('')
	# 	orig.find("select").val('request')
	#
	# 	# Insertion
	# 	clone.appendTo('#duty-fields')
	#
	# 	true

	$('form').submit (event) ->
		$('form #renewal_excluded_dates').val(window.excluded_duty_dates.join())
		$('form #renewal_preferred_dates').val(window.preferred_duty_dates.join())
