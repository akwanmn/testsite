$('#myTab a').click (e) ->
    e.preventDefault()
    window.location.hash = $(this).attr('href')
    $(this).tab('show')

$('a.profile-next').click (e) ->
  e.preventDefault()
  tab = $(this).attr('href')
  $('#myTab a[href="' + tab + '"]').tab('show')
  window.location.hash = tab
  $("html, body").animate({ scrollTop: 0 }, "fast"); # make it scroll to the top.

hash = window.location.hash;
if (hash)
  $('#myTab a[href="' + hash + '"]').tab('show')
  $("html, body").animate({ scrollTop: 0 }, "fast"); # make it scroll to the top.
else
  $('#myTab a:first').tab('show');

