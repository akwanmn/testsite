(function(){$(function(){return $("a.view-transaction").click(function(t){var e,i;return t.preventDefault(),i=$(this).attr("href"),e=$(this).html(),"View"===e?($(this).removeClass("btn-primary"),$(this).html("Hide"),$(i).show()):($(this).html("View"),$(this).addClass("btn-primary"),$(i).hide())}),$(".process").click(function(t){return t.preventDefault(),$(this).val("Processing..."),$(this).attr("disabled","disabled"),$(this).closest("form").submit()}),$("#order_amount").change(function(){return $("h4.amount-charged").html("Customer will be charged the default of $"+$(this).val()).show()})})}).call(this);