<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>ID/Password 찾기</title>
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
	body{
		background : url("resources/images/main-img-bg3.jpg");
		text-align: center;
		overflow : hidden;
	}
	.wrapper-align{
		margin : 0 auto;
	}
</style>
<script>
$(function(){
	if('${message}'){
		alert('${message}');	
	}
	
	$("#findidBtn").on("click", function(){
		//이름, 이메일 받아오기
		console.log("아이디 찾기버튼");
		var name = $(this).siblings("input[name=name]").val();
		var email = $(this).siblings("input[name=email]").val();
		
		if((name.length || email.length) <= 2) {
			alert("정확한 정보를 입력해주세요.");
			return false;
		}
		
		console.log(name + ", " + email);
		sendEmail(name, email, "findID");
// 		$(this).parent().submit();
	});
	
	$("#findpwdBtn").on("click", function(){
		//닉네임, 이메일 받아오기
		var userid = $(this).siblings("input[name=id]").val();
		var email = $(this).siblings("input[name=email]").val();

		if((userid.length || email.length) <= 2) {
			alert("정확한 정보를 입력해주세요.");
			return false;
		}
		
		console.log(userid + ", " + email);
		sendEmail(userid, email, "findPW");
// 		$(this).parent().submit();
	});
	
	function sendEmail(nameorid, email, mapping){
		var dataname;
		if(mapping == "findID") dataname = "name";
		else dataname = "id"
		var data = dataname + "=" + nameorid;
		console.log(data);
		$.ajax({
			url : mapping
			, method : "POST"
			, data : data + "&email="+email
			, dataType : "text"
			, success : function(resp){
				if(resp && mapping == "findID") alert("귀하의 이메일 주소로 해당 이메일로 가입된 아이디를 전송하였으니 확인 바랍니다.");
				else if(!resp && mapping == "findID") alert("해당 이메일로 가입된 아이디가 존재하지 않습니다. 확인 후 다시 이용바랍니다.");
				else if(resp && mapping == "findPW") alert("귀하의 이메일 주소로 비밀번호 재설정에 필요한 인증코드를 발송하였으니 확인 바랍니다.");
				else alert("해당 이메일 주소로 가입된 아이디가 존재하지 않습니다. 확인 후 다시 이용바랍니다.");
			}
			, error : function(resp){
				console.log(JSON.stringify(resp));
			}
		});
	}
});
</script>
</head>
<body>
<div class="container-fluid da-margin-top-50">
	<div class="col-md-3 col-md-offset-3 col-sm-4 col-sm-offset-0 da-price-plan-block da-margin-bottom-30">
		<div id = "findID" class="da-price-container da-price-container-room">
			<p class="da-price-title da-price-title-room">Find ID</p>
			<p>Please input your Name and Email.</p>
			
		</div>
		<div class="da-text-container">
			<form action = "findID" method = "POST">
				<input type ="text" name = "name" class="da-form-booking-item" placeholder = "Name*">
				<input type ="email" name = "email" class="da-form-booking-item" placeholder = "Email*">
				<button id = "findidBtn" class="da-btn da-form-booking-button hvr-sweep-to-right">ID찾기</button>
			</form>
		</div>
	</div>
	<div  class="col-sm-3 da-text-align-center da-price-plan-block">
		<div id = "findPWD"  class="da-price-container da-price-container-room">
		<p class="da-price-title da-price-title-room">Find Password</p>
			<p>Please input your ID and Email.</p>
		</div>
		<div class="da-text-container">
			<form action = "findPW" method = "POST">
				<input type ="text" name = "id" class="da-form-booking-item" placeholder = "ID*">
				<input type ="email" name = "email" class="da-form-booking-item" placeholder = "Email*">
				<button id = "findidBtn" class="da-btn da-form-booking-button hvr-sweep-to-right">비밀번호 찾기</button>
			</form>
		</div>
	</div>
</div>
</body>
</html>