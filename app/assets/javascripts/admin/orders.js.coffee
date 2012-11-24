# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('a.view-transaction').click (e) ->
    e.preventDefault()
    show = $(this).attr('href')
    label = $(this).html()
    if label == 'View'
      $(this).removeClass('btn-primary')
      $(this).html('Hide')
      $(show).show()
    else
      $(this).html('View')
      $(this).addClass('btn-primary')
      $(show).hide()

  $('.process').click (e) ->
    e.preventDefault()
    $(this).val('Processing...')
    $(this).attr('disabled', 'disabled')
    $('#new_order').submit()