<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Message</title>
<script src="resources/js/jquery-1.12.0.min.js"></script>
<script>
$(function() {
	alert("${message}");
	location.href = "${pageContext.request.contextPath}/${mapping}";
});
</script>
<script></script>
</head>
<body>

</body>
</html>