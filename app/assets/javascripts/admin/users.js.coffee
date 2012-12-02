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