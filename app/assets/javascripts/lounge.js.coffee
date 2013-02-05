$ ->
  $('a#join-button').click (e) ->
    e.preventDefault()
    $(this).html('..processing..').attr('disabled', 'disabled')
    $('form#new_user').submit()