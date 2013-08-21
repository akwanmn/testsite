$('#myTab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')

$('#myTab a:first').tab('show');

hash = window.location.hash;
$('#myTab a[href="' + hash + '"]').tab('show')
