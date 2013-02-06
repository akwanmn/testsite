$ ->
  $('a#join-button').click (e) ->
    e.preventDefault()
    $(this).html('..processing..').attr('disabled', 'disabled')
    $('form#new_user').submit()

  $('.errors').each (k, v) ->
    test = $(v).parent().find('input').attr('id')
    input = $('#' + test)
    console.log test
    if ($(input).html().is(':empty'))
      console.log 'here'
      $(input).addClass('validation-error')