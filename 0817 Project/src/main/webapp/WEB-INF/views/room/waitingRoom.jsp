<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
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
</style>
<script type="text/javascript" src="resources/js/jquery-1.12.0.min.js"></script>
<script type="text/javascript">
	$(function(){
	
		$(document).ready(function() {
			$("#textSend").click(function() {
				$('#chatting').scrollTop($('#chatting').prop('scrollHeight'));
				sendMessage();
			});//textSend
		});//ready
	
		var roomNum = '${roomNum}';
		var nickname = '${user.nickname}';
		var userId = '${user.id}';
		var userPw = '${user.pw}';
		
		function enterUser (resp){
			//초기화
			$('#user0').html('User');
			$('#user1').html('User');
			$('#user2').html('User');
			$('#user3').html('User');
			
			
			if(resp.length == 0){
				$('#user0').html('<img src="resources/images/${user.profile}.png"><br />${user.nickname}');
				return;
			}//if
	
			for(var i=0; i<resp.length; i++){
				var profile = resp[i].loginUser.profile;
				var otherPlayer = resp[i].loginUser.nickname;
					if(i == 0){
						$('#user0').html('<img src="resources/images/'+profile+'.png"><br />'+otherPlayer);
					}else if(i == 1){
						$('#user1').html('<img src="resources/images/'+profile+'.png"><br />'+otherPlayer);
					}else if(i == 2){
						$('#user2').html('<img src="resources/images/'+profile+'.png"><br />'+otherPlayer);
					}else if(i == 3){
						$('#user3').html('<img src="resources/images/'+profile+'.png"><br />'+otherPlayer);
					}//inner else if
			}//for
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
			$("#chattingScreen").append(data + "<br/>");
		}//onMessage
	
		function onClose(evt) {
			$("#chattingScreen").append("연결 끊김");
		}//onClose
	});//main
</script>
</head>
<body>
	<div id="wrapper">
	
		<div id="left">
			<div id="title">
				<p>제목</p>
			</div>
			<div id="users">
				<table id="userTable" border="1">
					<tr>
						<td id="user0">
						</td>
						<td id="user1">
							User
						</td>
					</tr>
					<tr>
						<td id="user2">
							User
						</td>
						<td id="user3">
							User
						</td>
					</tr>
				</table>
			</div>
			<br />
			<div id="chatting">
				<p id="chattingScreen"></p>
				<br />
			</div>
			<input type="text" id="text" class="chatting">
			<input type="button" id="textSend" value="send" class="chatting">
		</div>
		<div id="right">
			<input type="button" id="mapSelection" value="Map">
			<br />
			<textarea rows="10" cols="30" id="mapExplanation" readonly="readonly"></textarea>
			<br />
			<input type="button" id="startBtn" value="START">
		</div>
		
	</div>
</body>
</html>