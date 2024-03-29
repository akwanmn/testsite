# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->

  $( "input#user_user_profile_attributes_selected_birthday" ).datepicker
    altFormat: 'yy-mm-dd'
    dateFormat: 'mm/dd/yy'
    altField: '#user_user_profile_attributes_birthday'

  $(".chzn-select").chosen
    allow_single_deselect: true

  $('#profile_upload').fileupload
    dataType: 'script'
    add: (e, data) ->
      $('.upload .progress .bar').parent().fadeOut()
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#photos').prepend(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')

  $('.profile-image').live 'click', (e) ->
    e.preventDefault()
    $(this).colorbox
      open: true,
      scalePhotos: true,
      maxHeight: 640,
      maxWidth: 640,
      title: ->
        $(this).attr('data-profile')

  $('a.new-message').click (e) ->
    e.preventDefault()
    if $('form').length > 1
      $('form').last().parent().parent().hide().remove()
    $(this).closest('.profile-data').after($('div.reply').html())
  $('a.cancel-reply').live 'click', (e) ->
    e.preventDefault()
    $(this).parent().parent().parent().remove()

  $('a.show-password').click (e) ->
    e.preventDefault()
    $('.passwords').toggle()