<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Home</title>
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
	
</head>
<style>
.col-sm-3{
	width: 50%;
}
.container{
	background-color: rgba(255,0,0,0.3);
	width: 600px;
	height: 800px;
}
body{
	background-image: url("resources/images/main-img-bg3.jpg");
}
.pt-page-moveToTop {
	-webkit-animation: moveToTop .6s ease both;
	animation: moveToTop .6s ease both;
}
.pt-page-scaleUp {
	-webkit-animation: scaleUp .7s ease both;
	animation: scaleUp .7s ease both;
}
.pt-page-ontop {
	z-index: 999;
}
</style>
<script>
function login() {
	$("#loginForm").submit();
}

function join() {
	location.href = "joinForm";
}
</script>
<body>
<div class="container">
	<div class="col-sm-3">
		<form class="da-form-container da-margin-top-15" action="login" method="post" id="loginForm">
			<input class="da-padding-left-15" type="text" name="id" id="id" placeholder="ID">
			<input class="da-padding-left-15" type="password" name="pw" id="pw" placeholder="PW">
		</form>
		<button type="button" class="da-btn hvr-sweep-to-right" onclick="login()">Login</button>
		<button type="button" class="da-btn hvr-sweep-to-right" onclick="join()">Join</button>
	</div>
</div>
</body>
</html>
