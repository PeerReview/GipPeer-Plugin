$(function() {
  // Creates DatePickers in the form and sets alternative fields for them.
  // Alternative fields are required, due to date-format differences.
  $("#survey_end_date, #survey_start_date").datepicker({
    altFormat: "yy-mm-dd",
    dateFormat: "dd-mm-yy"
  });
  $("#survey_end_date").datepicker("option", "altField", "#altEndDate");
  $("#survey_start_date").datepicker("option", "altField", "#altStartDate");
});

// Function that selects all checkboxes of a given class.
function selectAll(p, v) {
	$(""+p).prop('checked', v);
}

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