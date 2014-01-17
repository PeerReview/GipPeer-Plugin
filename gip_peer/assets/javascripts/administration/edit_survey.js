$(function() {
  // Creates DatePickers in the form and sets alternative fields for them.
  // Alternative fields are required, due to date-format differences.
  $("#startdate").datepicker("option", "altField", "#altStartDate");
  $("#enddate").datepicker("option", "altField", "#altEndDate");
  $("#startdate, #enddate").datepicker({
    altFormat: "yy-mm-dd",
    dateFormat: "dd-mm-yy"
  });
});

// Function that selects all checkboxes of a given class.
function selectAll(p, v) {
	$("."+p).prop('checked', v);
}