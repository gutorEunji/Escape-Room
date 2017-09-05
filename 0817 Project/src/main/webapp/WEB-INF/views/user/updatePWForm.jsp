<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
	<title>Creative Room Escape : 비밀번호 변경</title>
	<script>
		$(function(){
			$("#passwordupdatebtn").on("click", pwdCheck);
		});
		
		function pwdCheck(){
			var pwd = $("#pw").val();
			var pwd2 = $("#pwCheck").val();
			if(pwd.length <= 5){
				alert("5자 이상의 비밀번호를 입력해주시길 바랍니다.");
				return false; 
			}
			if(pwd != pwd2){
				alert("입력하신 두 개의 비밀번호가 일치하지 않습니다.");
			}else{
				$(this).parent().submit();
			}
		}
	</script>
	<style>
		body{
			overflow : hidden;
			background-image : url('resources/images/main-img-bg3.jpg');
		}
	</style>
</head>
<body>
<div class="container-fluid da-margin-top-50">
	<div class="col-md-4 col-md-offset-4 col-sm-4 col-sm-offset-0 da-price-plan-block da-margin-bottom-30">
		<div class="da-price-container da-price-container-room">
			<p class="da-price-title da-price-title-room">비밀번호 변경</>
			<p>새로 사용할 비밀번호 입력</p>
		</div>
		<div class="da-text-container">
		<form action = "updatePWD" method = "POST" class="da-contact-form">
			<input type="hidden" value="${id}" name="id" />
			<input type = "password" name = "pw" id = "pw" placeholder = "새 비밀번호" class="da-contact-form-item">
			<input type = "password" id = "pwCheck"  placeholder = "새 비밀번호 확인" class="da-contact-form-item">
			<button id = "passwordupdatebtn" class="da-btn da-margin-top-30 hvr-sweep-to-right">비밀번호 변경</button>
		</form>
		</div>
	</div>
</div>
</body>
</html>