# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('a.reply-message').click (e) ->
    e.preventDefault()
    $('.all-messages form').each ->
      $(this).parent().parent().remove()
    $(this).closest('.communication').after($('div.reply').html())

  $('a.cancel-reply').live 'click', (e) ->
    e.preventDefault()
    $('.all-messages form').each ->
      $(this).parent().parent().remove()

  # archive
  # $('.communications td a.btn.btn-warning').live 'click', (e) ->
  #   e.preventDefault()
  #   this_id = $(this).parent().parent().attr('id')