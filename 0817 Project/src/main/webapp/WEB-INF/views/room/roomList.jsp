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
					$('.da-booking-date-container').html('');
					$.each(resp, function(i, elt) {
						var room = '<div class="da-booking-date" data-roomNum="'+elt.no+'", data-roomPw="'+ elt.room_pw +'">';
						room += '<p class="da-booking-date-number"><img src="resources/images/profile_01.png"></p>';
						room += '<div class="da-availabe-date">title: '+ elt.title + '<br />'
						room += 'Availabe: '+ elt.numberOfUsers +'</div>';
						room += '<a href="#" class="da-btn da-booking-btn hvr-sweep-to-right-inverse">Enter Room</a>';
						room += '</div>';
						
						$('.da-booking-date-container').append(room);
						
						$('.da-booking-date').on('click', function(){
							
							// 방에 비밀번호 여부 확인 후 비밀번호 요청
							var room_pw = $(this).attr('data-roomPw');
							if(room_pw != null){
								var password = prompt('Password here!');
								if(room_pw != password){
									alert('Wrong password!!');
									return;
								}//inner if
							}//outer if
							
							// 방 인원 4명초과 시 입장 제한
							if(elt.numberOfUsers == 4){
								alert('방 인원 제한 초과!');
								return;
							}//if
							
							// 방에 입장
							var room_no = $(this).attr('data-roomNum');
							location.href = "/escape/waitingRoom?room_no="+room_no+"&nickname=${nickname}";
							
						});//da-booking-date
					});//each
				}//success
			});//ajax
		}, 500);
		
	});//main
</script>
</head>
<body>

	<div id="search">
		검색 <input type="text" id="searchWord"> <input type="button" value="검색" id="searchBtn">
	</div>
	
	<div class="da-calendar-block da-margin-top-30">
		<div class="da-booking-date-container" />
	</div>
</body>
</html>