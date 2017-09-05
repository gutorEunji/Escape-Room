<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width:device-width,initial-scale=1.0">
	<title>Join</title>
	<script src="resources/js/jquery-1.12.0.min.js"></script>
	<link rel="stylesheet" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" href="resources/css/slick-theme.css">
	<link rel="stylesheet" href="resources/css/slick.css">
	<link rel="stylesheet" href="resources/css/animate.css">
	<link rel="stylesheet" href="resources/css/main.css">
	<script src="resources/js/map.js"></script>
	<script src="resources/js/slick.min.js"></script>
	<script src="resources/js/script.js"></script>
<style>
#da-bg-white da-padding-bottom-90 clearfix{
	width: 1200px;
}

#joinTable {
	width: 1000px;
}
.profileTD {
	text-align: center;
	vertical-align: top;
	width: 350px;
}
.inputColumn {
	width: 250px;
}
.da-btn {
	margin: 5px;
}
.selected_Profile {
	max-width: 150px;
	height: 100%;
	text-align: center;
}
div #profileDiv {
	margin: 0 auto;
	border-width: 20px 20px 20px 20px;
	border-style: solid;
	border-color: #E4E4E4;
	background-color: black;
	padding: 5px;
	width: 200px;
}
#profileH5{
	font-size: 20px;
	color: rgb(31, 34, 37);
	font-weight: 400;
	font-family: 'Montserrat', Arial, Helvetica, sans-serif;
	text-transform: uppercase;
}
.col-xs-4 {
	width: 120px;
}
.col-sm-3 {
	margin: 30px;
	padding: 30px;
	width: 100%;
}
.btnColumn{
	width: 150px;
}

</style>
<script>
var checkedNN = "";
var checkedId = "";
var checkedEmail = "";

$(function() {
	$(".da-photo-hover").on('click', profileSelectH);
	$(".img-responsive").on('click', profileSelectI);
});
	
function join() {
	var nickname = $("#nickname").val();
	var id = $("#id").val();
	var pw = $("#pw").val();
	var pwCheck = $("#pwCheck").val();
	
	if(checkedNN != nickname) {
		alert("닉네임 중복검사를 해주세요.");
		return false;
	}

	if(checkedId != id) {
		alert("아이디 중복검사를 해주세요.");
		return false;
	}
	
	if(pw != pwCheck) {
		alert("비밀번호를 다시 한번 확인해주세요.");
		$("#pwCheck").val("");
		return false;
	}
	
	$("#inputProfile").val($("#profile").attr("alt"));
	
	var form = $("#joinForm");
	form.submit();
}

function checkNickName() {
	var nickname = $("#nickname").val();
	$.ajax({
		url : "checkNickName"
		, data : "nickname=" + nickname
		, method : "get"
		, success : function(resp) {
			if(resp == true) {	// 중복 체크 통과
				alert("사용 가능한 닉네임 입니다.");
				checkedNN = nickname;
			}				
			else {
				alert("중복된 닉네임입니다. 다른 닉네임을 사용해주세요");
				 $("#nickname").val("");
			}
		}
	});
}

function checkId() {
	var id = $("#id").val();
	$.ajax({
		url : "checkId"
		, data : "id=" + id
		, method : "get"
		, success : function(resp) {
			if(resp == true) {	// 중복 체크 통과
				alert("사용 가능한 아이디 입니다.");
				checkedId = id;
			}				
			else {
				alert("중복된 아이디입니다. 다른 아이디을 사용해주세요");
				$("#id").val("");
			}
		}
	});
}

function checkEmail() {
	 window.open("checkEmailForm", "이메일 인증", 'width=400, height=250');
}

function profileSelectH() {
	var selectedImg = $(this).siblings(".img-responsive").attr("alt");
	$(".selected_Profile").attr("src", "resources/images/" + selectedImg + ".png");
	$(".selected_Profile").attr("alt", selectedImg);
	$("#inputProfile").val(selectedImg);
}

function profileSelectI() {
	var selectedImg = $(this).attr("alt");
	$(".selected_Profile").attr("src", "resources/images/" + selectedImg + ".png");
	$(".selected_Profile").attr("alt", selectedImg);
	$("#inputProfile").val(selectedImg);
}
</script>
</head>
<body>
<header>
<div id="da-bg-white da-padding-bottom-90 clearfix">
	<div class="container da-contact-container">
	<form class="row da-margin-top-50" id="joinForm" action="join" method="POST">
	<input type="hidden" id="inputProfile" name="profile" value="">
	<input type="hidden" id="checkedEmail" value="" />
		<h4 class="da-margin-top-30">JOIN with US</h4>
		<div class="row da-margin-top-50">
			<div class="col-sm-6">
				<table id="joinTable">
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="text" id="id" name="id" class="form-control" placeholder="ID"></td>
						<td class="btnColumn"><button type="button" class="da-btn hvr-sweep-to-right" onclick="checkId()">ID Check</button></td>
						<td rowspan="7" class="profileTD">
							<h5 id="profileH5">Select Profile</h5>
							<div id="profileDiv">
								<img id="selected_Profile" class="selected_Profile" src="resources/images/profile_default.png" alt="profile_default">
							</div>
							<div class="da-contact-container">
								<div class="col-sm-3">
									<div class="col-xs-4 da-footer-photo">
										<img class="img-responsive" src="resources/images/profile_default.png" alt="profile_default">
										<div class="da-photo-hover"></div>
									</div>S
									<div class="col-xs-4 da-footer-photo">
									    <img class="img-responsive" src="resources/images/profile_01.png" alt="profile_01">
										<div class="da-photo-hover"></div>
									</div>
									<div class="col-xs-4 da-footer-photo">
										<img class="img-responsive" src="resources/images/profile_02.png" alt="profile_02">
										<div class="da-photo-hover"></div>
									</div>
									<div class="col-xs-4 da-footer-photo">
										<img class="img-responsive" src="resources/images/profile_03.png" alt="profile_03">
										<div class="da-photo-hover"></div>
									</div>
									<div class="col-xs-4 da-footer-photo">
									    <img class="img-responsive" src="resources/images/profile_04.png" alt="profile_04">
										<div class="da-photo-hover"></div>
									</div>
									<div class="col-xs-4 da-footer-photo">
										<img class="img-responsive" src="resources/images/profile_05.png" alt="profile_05">
										<div class="da-photo-hover"></div>
									</div>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="password" id="pw" name="pw" class="form-control" placeholder="PassWord"></td>
						<td></td>
					</tr>
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="password" id="pwCheck" name="pwCheck" class="form-control" placeholder="PassWord Check"></td>
						<td></td>
					</tr>
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="email" id="email" name="email" readonly="readonly" placeholder="Email" onclick="checkEmail()"></td>
						<td><button type="button" class="da-btn hvr-sweep-to-right" onclick="checkEmail()">Email Check</button></td>
					</tr>
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="text" id="name" name="name" class="form-control" placeholder="Name"></td>
						<td></td>
					</tr>
					<tr>
						<td class="inputColumn"><input class="da-contact-form-item" type="text" id="nickname" name="nickname" class="form-control" placeholder="NickName"></td>
						<td><button type="button" class="da-btn hvr-sweep-to-right" onclick="checkNickName()">NickName Check</button></td>
					</tr>
					<tr>
						<td></td>
						<td class="joinBtn"><button class="da-btn da-margin-top-30 hvr-sweep-to-right" onclick="join()">JOIN</button></td>
					</tr>
				</table>
			</div>
			</div>
		</form>
	</div>
	</div>
</header>
</body>
</html>