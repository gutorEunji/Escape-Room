<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" href="resources/css/slick-theme.css">
	<link rel="stylesheet" href="resources/css/slick.css">
	<link rel="stylesheet" href="resources/css/animate.css">
	<link rel="stylesheet" href="resources/css/main.css">
	<script src="resources/js/jquery-1.12.0.min.js"></script>
	<script src="resources/js/map.js"></script>
	<script src="resources/js/slick.min.js"></script>
	<script src="resources/js/script.js"></script>
<style type="text/css">
	#updateTable{
		vertical-align: text-top;
		text-align: left;
	}
	a.pw_resetBtn{
		float: right;
	}
	.da-booking-btn{
		font-size: 15px;
	}
</style>
<script>
function cancel() {
	this.close();
}
function certifiedCheck(){
	var certifiedNum = $('#certifiedNum').val();
	$.ajax({
		url : "certifiedCheck"
		, data : "certifiedNum=" + certifiedNum
		, method : "get"
		, success : function(resp) {
			if(resp == true) {	// 중복 체크 통과
				alert("이메일 인증 완료");
				opener.document.getElementById("email").value = $("#email").val();
				window.close();
			}				
			else {
				alert("인증 번호를 다시 확인해주세요");
				$("#certifiedNum").val("");
			}
		}
	});
}//pw_resetBtn

function email() {
	var email = $("#email").val();
	$.ajax({
		url : "checkEmail"
		, data : "email=" + email
		, method : "get"
		, success : function(resp) {
			if(resp == true) {	// 중복 체크 통과
				alert("해당 이메일로 인증 번호가 전송 되었습니다. 인증번호를 정확하게 입력해주세요.");
				$("#emailCheck").attr("disabled", "disabled");
				$("#email").attr("readonly", "readonly");
				
			}				
			else {
				alert("중복된 이메일 이거나, 이메일 전송에 문제가 생겼습니다. 다시 시도해주세요.");
				$("#email").val("");
			}
		}
	});
}
</script>
</head>
<body>
<div id="da-bg-white da-padding-bottom-90 clearfix">
	<div class="container da-contact-container">
	<h4>Email Check</h4>
	<table id="checkEmail">
		<tr>
			<td class="inputColumn"><input class="da-contact-form-item" type="email" id="email" name="email" placeholder="Email"></td>
			<td><button type="button" class="da-btn hvr-sweep-to-right" onclick="email()">인증번호 전송</button></td>
		</tr>
		<tr>
			<td><input class="da-contact-form-item" type="text" name="certifiedNum" class="form-control"id="certifiedNum" placeholder="인증 번호"></td>
		</tr>
		<tr>
			<td><a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse" onclick="certifiedCheck()"> 확인 </a>
			<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse" onclick="cancel()">취소</a></td>
		</tr>
	</table>
	</div>
</div>
</body>
</html>