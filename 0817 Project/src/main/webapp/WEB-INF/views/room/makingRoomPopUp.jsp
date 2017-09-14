<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Making Room Pop Up</title>

<link rel = "stylesheet" href = "resources/css/bootstrap.min.css">
<link rel = "stylesheet" href = "resources/css/main.css">
<link rel = "stylesheet" href = "resources/css/animate.css">
<link rel = "stylesheet" href = "resources/css/font-awesome.min.css">
<link rel = "stylesheet" href = "resources/css/pe-icon-7-stroke.css">
<link rel = "stylesheet" href = "resources/css/responsive.css">
<link rel = "stylesheet" href = "resources/css/slick-theme.css">
<link rel = "stylesheet" href = "resources/css/slick.css">
<link rel = "stylesheet" href = "resources/css/style.css">
<script src="resources/js/jquery-1.12.0.min.js"></script>

<style>
#pw {
	disabled : true;
}
</style>

<script>
$(function() {
	$("#checkPW").on('click', clickPW);
	$("#makingRoomBtn").on('click', gotoWatingRoom);
});

function clickPW() {
	if($("#checkPW").is(":checked") == true) {
		$("#room_pw").removeAttr("disabled");
	}
	else {
		$("#room_pw").attr("disabled", true);
		$("#room_pw").val("");
	}
}

function gotoWatingRoom() {
	var title = $("#title").val();
	var room_pw = $("#room_pw").val();
	var sendData = {"title" : title, "room_pw" : room_pw, "id" : "${user_id}"};
	$.ajax({
		url: "makingRoom",
		method: "post",
		data: sendData,
		success: function(resp) {
			if(resp != -1) {
				$(opener.location).attr("href","waitingRoom?room_no=" + resp + "&id=${user_id}&roomTitle="+title);
				window.close();
			}
			else {
				alert("room create error");
			}
		}//success
	});//ajax
};//gotoWatingRoom
</script>

</head>
<body>
<div class="container-fluid da-margin-top-50">
	<div class="col-md-3 col-md-offset-3 col-sm-4 col-sm-offset-0 da-price-plan-block da-margin-bottom-30">
		<div id = "roomSetting" class="da-price-container da-price-container-room">
			<p class="da-price-title da-price-title-room">Room Setting</p>
			
		</div>
		<div class="da-text-container">
			<input type ="text" id="title" name="title" class="da-form-booking-item" placeholder = "Title*">
			<input type ="checkbox" id="checkPW" name = "pwCheck"><input type ="password" name="room_pw" id="room_pw" class="da-form-booking-item" placeholder = "Password*" disabled="disabled">
			<button id = "makingRoomBtn" class="da-btn da-form-booking-button hvr-sweep-to-right">Make Room</button>
		</div>
	</div>
</div>
</body>
</html>