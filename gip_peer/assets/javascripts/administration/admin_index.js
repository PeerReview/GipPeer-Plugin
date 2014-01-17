$(function() {
  // Creates DatePickers in the form and sets alternative fields for them.
  // Alternative fields are required, due to date-format differences.
  $("#startdate, #enddate").datepicker({
    dateFormat: "yy-mm-dd",
    altFormat: "dd-mm-yy"
  });
  $("#startdate").datepicker("option", "altField", "#altStartDate");
  $("#enddate").datepicker("option", "altField", "#altEndDate");
  // set default values
  $("#startdate").val("yyyy/mm/dd");
  $("#enddate").val("yyyy/mm/dd");
  // function to delete default value on click and put it back when the field is still empty
  $.fn.ToggleInputValue = function(){
    return $(this).each(function(){
        var Input = $(this);
        var default_value = Input.val();
        Input.focus(function() {
           if(Input.val() == default_value) Input.val("");
        }).blur(function(){
            if(Input.val().length == 0) Input.val(default_value);
        });
    });
  }
});
// function to put action listeners to text fields.
$(document).ready(function(){
	$('#startdate').ToggleInputValue();
	$('#enddate').ToggleInputValue();
  $('.text_field').keydown(function() {
    // if enter is pressed inside text field submit
    if (event.keyCode == 13) {
        this.form.submit();
        return false;
     }
  });
});
