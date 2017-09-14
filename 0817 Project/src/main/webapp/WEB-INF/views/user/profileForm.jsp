<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
img {
 	-webkit-filter: grayscale(100%);
}
img:hover {
	-webkit-filter: grayscale(0%);
}
</style>
<link href="resources/css/bootstrap.min.css" rel="stylesheet">
<link href="resources/css/animate.min.css" rel="stylesheet">
<link href="resources/css/ionicons.min.css" rel="stylesheet">
<link href="resources/css/styles.css" rel="stylesheet">

<script src="resources/js/jquery.min.js"></script>
<script src="resources/js/wow.js"></script>
<script src="resources/js/jquery.easing.min.js"></script>
<script src="resources/js/bootstrap.min.js"></script>
<script src="resources/js/scripts.js"></script>
<script>
var selectedImg = "profile_defalut";

$(function() {
	$("#" + opener.document.getElementById("profile").alt).css("-webkit-filter", "grayscale(0%)");
	
	$("img").on('click', function() {
		$("img").css("-webkit-filter", "grayscale(100%)");
		$(this).css("-webkit-filter", "grayscale(0%)");
		selectedImg = $(this).attr("id");
	});
});

function selectImg() {
	opener.document.getElementById("profile").src = "resources/images/" + selectedImg + ".png";
	opener.document.getElementById("profile").alt = selectedImg;
	window.close();
}
</script>
</head>
<body>
<header>
<div id="feature" align="center">

<img src="resources/images/profile_default.png" id="profile_default" name="profile_default" />
<img src="resources/images/profile_01.png" id="profile_01" name="profile_01" />
<img src="resources/images/profile_02.png" id="profile_02" name="profile_02" />
<img src="resources/images/profile_03.png" id="profile_03" name="profile_03" />
<img src="resources/images/profile_04.png" id="profile_04" name="profile_04" />
<img src="resources/images/profile_05.png" id="profile_05" name="profile_05" />

<a href="#" class="btn btn-primary btn-xl" onclick="selectImg()">확인</a>
</div>
</header>
</body>
</html>