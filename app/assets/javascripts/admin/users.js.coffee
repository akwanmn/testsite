# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $( "input#user_user_profile_attributes_selected_birthday" ).datepicker
    altFormat: 'yy-mm-dd'
    dateFormat: 'mm/dd/yy'
    altField: '#user_user_profile_attributes_birthday'

  $('.alert').delay 10000,  ->
    $(this).fadeOut 'slow',  ->
      $(this).remove()

  $(".chzn-select").chosen
    allow_single_deselect: true

  $("#user_user_profile_attributes_timezone").chosen()

  $('#profile_upload').fileupload
    dataType: 'script'
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        console.log data.context
        $('#photos').prepend(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')