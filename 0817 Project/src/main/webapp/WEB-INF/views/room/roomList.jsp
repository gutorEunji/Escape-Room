<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			var room_no = $(this).attr('data-roomNum');
			location.href = "/escape/waitingRoom?room_no="+room_no+"&nickname=${nickname}";
		});//da-btn da-booking-btn hvr-sweep-to-right-inverse
		
		setInterval(function() {
			$.ajax({
				url : "roomListRenew"
				, method : "GET"
				, dataType : 'json'
				, success : function(resp){
					$('.da-booking-date-container').html("");
					$.each(resp, function(i, elt) {
						var tag = '<div class="da-booking-date" data-roomNum="'+elt.no+'">';
						tag += '<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>';
						tag += '<div class="da-availabe-date">Availabe: 3</div>';
						tag += '<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>';
						tag += '</div>';
						
						$('.da-booking-date-container').append(tag);
					});//each
				}//success
			});//ajax
		}, 1000);
		
	});//main
</script>
</head>
<body>

	<div id="search">
		검색 <input type="text" id="searchWord"> <input type="button" value="검색" id="searchBtn">
	</div>
	
	<div class="da-calendar-block da-margin-top-30">
		<div class="da-booking-date-container" />
		<!--   <div class="da-booking-date da-not-availabe-day"> 방 꽉 찼을 때 더이상 못들어오게 막음  -->
	</div>
</body>
</html>