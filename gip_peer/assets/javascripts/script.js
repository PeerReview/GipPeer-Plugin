$(function(){
	$("input.radiotext, input.checkboxtext").click(function(){
		if($(this).attr("type") == "radio" || $(this).attr("type") == "checkbox")
		{
			$(this).next().next().focus();
		}
		else
		{
			$(this).prev().click();
		}
	});
});
