// Function that adds a new possibility to the list of possibilties.
// The possibility will have a different ID, based on a counter on the page.
function addRCPossibility() {
	var newNum = parseInt($("#rc_numPos").val()) + 1;
	var type = $('input[name=question_type]:checked').val();
	$("#rc_posAnswers").append("<li><input type=\"text\" name=\"rc_pos_"+newNum+"\" id=\"rc_pos_"+newNum+"\" size=\"30\" class=\"radiofill\" />" +
		"<input type=\"checkbox\" name=\"rc_pos_"+newNum+"_custom\" id=\"rc_pos_"+newNum+"_custom\" title=\"Check this box if you want to add a text field to this choice.\" /></li>");
	$("#rc_numPos").val(newNum);
}

// Function that adds a new possibility to the list of possibilities of Matrix type.
// The possibility will have a different ID, based on a counter on the page.
function addMAPossibility() {
	var newNum = parseInt($("#ma_numPos").val()) + 1;
	$("#ma_posAnswers").append("<li><input type=\"text\" name=\"ma_pos_"+newNum+"\" id=\"ma_pos_"+newNum+"\" class=\"radiofill\" /></li>");
	$("#ma_numPos").val(newNum);
}

// Function that displays and hides sections based on the selected value for the question type.
function setSection() {
	var type = $('input[name=question_type]:checked').val();
	var secOpen = $('#section_open');
	var secRCH = $('#section_radio_check');
	var secMatrix = $("#section_matrix");
	// Display open question type
	if (type == "open" && !secOpen.is(":visible")) {
		secRCH.hide("blind", {}, 200);
		secMatrix.hide("blind", {}, 200);
		secOpen.show("blind", {}, 200);
	}
	// Display radio or checkbox type
	else if ((type == "radio" || type == "checkbox") && !secRCH.is(":visible")) {
		$(".rc_pos_button").prop("type", type);
		secOpen.hide("blind", {}, 200);
		secMatrix.hide("blind", {}, 200);
		secRCH.show("blind", {}, 200);
	}
	// Display radio of checkbox type, when coming from radio or checkbox.
	else if ((type == "radio" || type == "checkbox") && secRCH.is(":visible")) {
		$(".rc_pos_button").prop("type", type);
	}
	else if (type == "matrix" && !secMatrix.is(":visible")) {
		secOpen.hide("blind", {}, 200);
		secRCH.hide("blind", {}, 200);
		secMatrix.show("blind", {}, 200);
	}
}

$(function() {
	$(document).tooltip();
});
