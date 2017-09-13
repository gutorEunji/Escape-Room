<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link rel="stylesheet" href="resources/css/loading.min.css"> <!-- CSS reset -->

<script src="resources/js/modernizr.js"></script>
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script src="resources/js/map.js"></script>
<script src="resources/js/slick.min.js"></script>
<script src="resources/js/script.js"></script>
<script src="resources/js/counter.js"></script>
<script src="resources/js/jquery.lightbox_me.js"></script>
<script src="resources/js/jquery.loading.min.js"></script>

<style type="text/css">
	#wrapper{
		width: 800px;
		height: 800px;
	}
	#left{
		width: 60%;
		float: left;
	}
	#right{
		width: 40%;
		float: left;
	}
	#userTable{
		width: 300px;
		height: 300px;
		text-align: center;
		margin: 0 auto;
	}
	#title{
		text-align: center;
	}
	#chatting{
		margin-left: 100px;
	}
	#text{
		width: 230px;
	}
	#mapExplanation{
		width: 200px;
	}
	#mapSelection{
		width: 200px;
		height: 200px;
	}
	#startBtn{
		width: 200px;
		height: 150px;
	}
	h2{
		margin-top: 35px;
	}
</style>
<script type="text/javascript">
	$(function(){
	
		$(document).ready(function() {
			$("#textSend").click(function() {
				$('#chatting').scrollTop($('#chatting').prop('scrollHeight'));
				sendMessage();
			});//textSend
		});//ready
	
		var roomNum = '${room_no}';
		var nickname = '${user.nickname}';
		var userId = '${user.id}';
		var userPw = '${user.pw}';
		
		function enterUser (resp){
			//초기화
			$('#user0').html('User');
			$('#user1').html('User');
			$('#user2').html('User');
			$('#user3').html('User');
			
			$.each(resp, function(i, elt) {
				if(i == 0){
					$('#user0').html('<img src="resources/images/'+elt.profile+'.png"><br />'+elt.nickname);
				}else if(i == 1){
					$('#user1').html('<img src="resources/images/'+elt.profile+'.png"><br />'+elt.nickname);
				}else if(i == 2){
					$('#user2').html('<img src="resources/images/'+elt.profile+'.png"><br />'+elt.nickname);
				}else if(i == 3){
					$('#user3').html('<img src="resources/images/'+elt.profile+'.png"><br />'+elt.nickname);
				}//inner else if
			});//each
			
		}//enterUser
		
		var ws = new WebSocket("ws://" + window.location.host + "/escape/echo");
		ws.onmessage = onMessage;
		ws.onopen = function() {
			ws.send(roomNum + "|roomNum|" + userId + "|userId|" + userPw + "|userPw|");
			$.ajax({
				url : "renew"
				, method : "GET"
				, data : "id=" + userId + "&pw=" + userPw + "&roomNum=" + roomNum
				, dataType : "json"
				, success : enterUser
				, error : function(){
					alert('ERROR');
				}//error
			});//ajax
			
		}//onopen
		ws.onclose = onClose;
	
		function sendMessage() {
			ws.send(roomNum + "*" + $("#text").val());
		}//sendMessage

		function onMessage(evt) {
			var data = evt.data;
			
			// USER 입장 시
			if(data === '|Enter|'){
				$(function(){
					$.ajax({
						url : "renew"
						, method : "GET"
						, data : "id=" + userId + "&pw=" + userPw + "&roomNum=" + roomNum
						, dataType : "json"
						, success : enterUser
						, error : function(){
							alert('ERROR');
						}//error
					});//ajax
				});//main
				return;
			}//if
			
			// ROOM 삭제 시
			if(data === '|room_deleted|'){
				alert('방장이 퇴장했습니다.');
				history.back();
			}//if
			
			
			$("#chattingScreen").append(data + "<br/>");
		}//onMessage
	
		function onClose(evt) {
			$("#chattingScreen").append("연결 끊김");
		}//onClose
	});//main
</script>
</head>
<body>
<div class="da-bg-white">
		<div class="container">
			<div id="title"><h2 class="da-underline-title da-margin-bottom-0">Title</h2></div>
			<div class="row da-game-in-real">
				<div class="col-sm-8" id="users">
					<div class="row da-margin-top-75">
						<div class="col-sm-6 col-xs-12">
							<div class="da-game-container visible animated fadeInUp" id="user0">
							</div>
						</div>
						<div class="col-sm-6 col-xs-12">
							<div class="da-game-container visible animated fadeInUp">
								<p class="da-before-step-block pe-7s-clock"></p>
								<p class="da-game-step-title da-font-montserrat">time</p>
								<p>Exactly 1 hour to find a way out and get out of the quest of the room , thinking all the fun and interesting puzzles on your heroic journey.</p>
							</div>
						</div>
					</div>
					<div class="row da-margin-top-30">
						<div class="col-sm-6 col-xs-12">
							<div class="da-game-container visible animated fadeInUp">
								<p class="da-before-step-block pe-7s-users"></p>
								<p class="da-game-step-title da-font-montserrat">Command</p>
								<p>For the whole family and for your friends ! Your team - the key to a successful passing game . Trust and partner nayditie output.</p>
							</div>
						</div>
						<div class="col-sm-6 col-xs-12">
							<div class="da-game-container visible animated fadeInUp">
								<p class="da-before-step-block pe-7s-smile"></p>
								<p class="da-game-step-title da-font-montserrat">Impression</p>
								<p>This is an unforgettable adventure in the exciting world of mystery. Only positive emotions and vivid feeling for the entire company.</p>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-4">
					<div class="da-game-img visible animated fadeIn">
						<img src="resources/images/game-in-reality-person.png" alt="alt">
					</div>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>