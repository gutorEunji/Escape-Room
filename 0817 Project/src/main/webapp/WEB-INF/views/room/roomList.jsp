<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>RoomList</title>
<style>
div#wrapper {
	width: 500px;
	text-align: center;
	height: 150px;
	position: relative;
	margin: 0 auto;
}

#findID, #findPWD {
	float: left;
	border: 1px solid #666;
	border-radius: 10px;
	width: 49%;
	height: 100%;
	margin: 0 auto;
}

#findIDpop, #findPWDpop {
	position: absolute;
	top: 20%;
	left: 25%;
	display: none;
	width: 300px;
	height: 100px;
	background: white;
	border: 1px solid #ccc;
}
#search{
	margin-right: 50px;
	margin-top: 50px;
	text-align: right;
}

#searchWord{
	color: black;
}

#searchBtn{
	color: black;
}

</style>

<link rel="stylesheet" href="resources/css/bootstrap.min.css">
<link rel="stylesheet" href="resources/css/slick-theme.css">
<link rel="stylesheet" href="resources/css/slick.css">
<link rel="stylesheet" href="resources/css/animate.css">
<link rel="stylesheet" href="resources/css/main.css">
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script src="resources/js/map.js"></script>
<script src="resources/js/slick.min.js"></script>
<script src="resources/js/script.js"></script>
<script type="text/javascript">
	$(function(){
		
		$('.da-booking-date').on('click', function(){
			var roomNum = $(this).attr('data-roomNum');
			location.href = "/escape/waitingRoom?num="+roomNum+"&nickname=${nickname}";
		});//da-btn da-booking-btn hvr-sweep-to-right-inverse
	});//main
</script>
</head>
<body>

	<div id="search">
		검색 <input type="text" id="searchWord"> <input type="button" value="검색" id="searchBtn">
	</div>
	
	<div class="da-calendar-block da-margin-top-30">
		<div class="da-booking-date-container">
		
		<!--   <div class="da-booking-date da-not-availabe-day"> 방 꽉 찼을 때 더이상 못들어오게 막음  -->
		
			<div class="da-booking-date" data-roomNum="1">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="2">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="3">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="4">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="5">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="6">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
			<div class="da-booking-date" data-roomNum="7">
				<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>
				<div class="da-availabe-date">Availabe: 3</div>
				<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>
			</div>
		</div>
	</div>
</body>
</html>