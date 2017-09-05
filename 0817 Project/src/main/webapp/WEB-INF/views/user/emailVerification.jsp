<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<style type="text/css">
		#updateTable{
			vertical-align: text-top;
			text-align: left;
		}
		a.pw_resetBtn{
			float: right;
		}
	</style>
	<script src="resources/js/jquery.min.js"></script>
	<script type="text/javascript">
		function pw_resetBtn(){
			var pw = $('#pw').val();
			var pwCheck = $('#pwCheck').val();
			
			if(pw != pwCheck){
				alert('비밀번호를 다시 한번 확인해주세요');
				return false;
			}//if
			
			var form = $('pw_reset_fm');
			form.submit();
		}//pw_resetBtn
	</script>
</head>
<body>
	<div id="wrapper">
		<form action="#" method="POST" id="pw_reset_fm">
		<table id="updateTable">
			<tr>
				<th>
					Password
				</th>
				<td>
					<input type="password" name="pw" id="pw" placeholder="PassWord">
				</td>
			</tr>
			<tr>
				<th>
					Password Check
				</th>
				<td>
					<input type="password" name="pwCheck" id="pwCheck" placeholder="PassWord Check">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<a href="#" class="pw_resetBtn" onclick="pw_resetBtn()">확인</a>
				</td>
			</tr>
		</table>		
		</form>
	</div>
</body>
</html>