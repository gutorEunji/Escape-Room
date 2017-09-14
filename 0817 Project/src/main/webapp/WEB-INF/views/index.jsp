<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="resources/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/css/slick-theme.css">
<link rel="stylesheet" href="resources/css/slick.css">
<link rel="stylesheet" href="resources/css/animate.css">
<link rel="stylesheet" href="resources/css/main.css">
<link rel="stylesheet" href="resources/css/loading.min.css"> <!-- CSS reset -->

<script src="resources/js/modernizr.js"></script>
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script src="resources/js/map.js"></script>
<script src="resources/js/slick.min.js"></script>
<script src="resources/js/script.js"></script>
<script src="resources/js/counter.js"></script>
<script src="resources/js/jquery.lightbox_me.js"></script>
<script src="resources/js/jquery.loading.min.js"></script>

<!-- animsition.css -->
<link rel="stylesheet" href="resources/css/animsition.min.css">
<!-- animsition.js -->
<script src="resources/js/animsition.min.js"></script>

<style>
body{
	background : url("resources/images/main-img-bg3.jpg");
	text-align: center;
	overflow : hidden;
}
#mainImage {
	av
}
#login {
color: black;
background: #eef2f7;
   -webkit-border-radius: 6px;
   border: 1px solid #536376;
   -webkit-box-shadow: rgba(0,0,0,.6) 0px 2px 12px;
   -moz-box-shadow: rgba(0,0,0,.6) 0px 2px 12px;
   padding: 14px 22px;
   width: 400px;
   position: relative;
   display: none;
}
#login #loginForm {
    margin-top: 13px;
}
#login label {
    display: block;
    margin-bottom: 10px; 
    color: #536376;
    font-size: .9em;
}

#login label input {
    display: block;
    width: 393px;
    height: 31px;
    background-position: -201px 0;
    padding: 2px 8px;
    font-size: 1.2em;
    line-height: 31px;
}
.mainImage {
	background-image: url("resources/images/main-img-bg3.jpg");
	background-repeat: no-repeat;
	background-position: center center;
}
#loginH2 {
	margin-top: 10px;
	margin-bottom: 10px;
}
#login label input {
	width: 360px;
}
#findLink {
	color: black;
}

</style>

<script>
$(document).ready(function() {
	$(".animsition").animsition({
		inClass: 'fade-in-down-sm',
		outClass: 'fade-out-down-sm',
		inDuration: 1500,
		outDuration: 800,
		linkElement: '.animsition-link',
		// e.g. linkElement: 'a:not([target="_blank"]):not([href^="#"])'
		loading: true,
		loadingParentElement: 'body', //animsition wrapper element
		loadingClass: 'animsition-loading',
		loadingInner: '', // e.g '<img src="loading.svg" />'
		timeout: false,
		timeoutCountdown: 5000,
		onLoadEvent: true,
		browser: [ 'animation-duration', '-webkit-animation-duration'],
		// "browser" option allows you to disable the "animsition" in case the css property in the array is not supported by your browser.
		// The default setting is to disable the "animsition" in a browser that does not support "animation-duration".
		overlay : false,
		overlayClass : 'animsition-overlay-slide',
		overlayParentElement : 'body',
		transition: function(url){ window.location.href = url; }
	});

	loginPop();
	
});

//var sw = true;
function login() {
	$.showLoading(); 
	$("#loginForm").submit();
}

function join() {  
	location.href = "joinForm";
}

function loginPop() {
	$.showLoading(); 
	$("#login").lightbox_me({centered: true, preventScroll: true, onLoad: function() {
		$("#login").find("input:first").focus();
	}});
	$.hideLoading();
}
</script>
</head>
<body>
<div class="mainImage">
	<div>
		<div id="login">
    	<h2 id="loginH2">Login</h2>
    	<form id="loginForm" class="da-form-container da-margin-top-15" action="login" method="post">
	        <label><strong>ID:</strong> <input class="da-padding-left-15" type="text" name="id" id="id" placeholder="ID"/></label>
	        <label><strong>PW:</strong> <input class="da-padding-left-15" type="password" name="pw" id="pw" placeholder="PW"/></label>
	    </form>
		    <button type="button" id="loginBtn" class="da-btn hvr-sweep-to-right" onclick="login()">Login</button>
			<button type="button" class="da-btn hvr-sweep-to-right" onclick="join()">Join</button>
			<br><hr>
			<div>
				<a href="findForm" id="findLink">Forget your account? click here</a>
			</div>
		</div>
	</div>
</div>
  <div
  class="animsition"
  data-animsition-in-duration="1000"
  data-animsition-out-duration="800"
  >
  <h2><a href="#" onclick="loginPop()">Escape Room</a></h2>
</div>
</body>
</html>