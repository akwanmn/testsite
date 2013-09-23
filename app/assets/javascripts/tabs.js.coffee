$('#myTab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')


hash = window.location.hash;
if (hash)
  $('#myTab a[href="' + hash + '"]').tab('show')
  $("html, body").animate({ scrollTop: 0 }, "fast"); # make it scroll to the top.
else
  $('#myTab a:first').tab('show');

