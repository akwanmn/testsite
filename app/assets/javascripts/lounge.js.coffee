$ ->
  $('a#join-button').click (e) ->
    e.preventDefault()
    $(this).html('..processing..').attr('disabled', 'disabled')
    $('form#new_user').submit()

  $('#new_user div.errors').each (k,v) ->
    if $(v).html() != ''
      $(v).parent().parent().find('input:first').addClass('omgerror')


  $('input, textarea').placeholder()