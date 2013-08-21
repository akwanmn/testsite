$('#myTab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')


hash = window.location.hash;
if (hash)
  $('#myTab a[href="' + hash + '"]').tab('show')
else
  $('#myTab a:first').tab('show');
