(function(){$(function(){return $("input#user_user_profile_attributes_selected_birthday").datepicker({altFormat:"yy-mm-dd",dateFormat:"mm/dd/yy",altField:"#user_user_profile_attributes_birthday"}),$(".alert").delay(1e4,function(){return $(this).fadeOut("slow",function(){return $(this).remove()})}),$(".chzn-select").chosen({allow_single_deselect:!0}),$("#user_user_profile_attributes_timezone").chosen(),$("#profile_upload").fileupload({dataType:"script",add:function(e,t){var r,n;return n=/(\.|\/)(gif|jpe?g|png)$/i,r=t.files[0],n.test(r.type)||n.test(r.name)?(t.context=$(tmpl("template-upload",r)),console.log(t.context),$("#photos").prepend(t.context),t.submit()):alert(""+r.name+" is not a gif, jpeg, or png image file")},progress:function(e,t){var r;return t.context?(r=parseInt(100*(t.loaded/t.total),10),t.context.find(".bar").css("width",r+"%")):void 0}})})}).call(this);