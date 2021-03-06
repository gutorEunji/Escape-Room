 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html> 
<html>
	<meta charset="UTF-8">
<head>
<link rel = "stylesheet" href = "resources/css/jquery-ui.min.css">
<style>
	body{
		margin : 0;
 		overflow: hidden;
	}
	#canvas, #Objects{
		float : left;
	}
</style>
<script src = "resources/js/jquery-1.12.0.min.js"></script>
<script src = "resources/js/jquery-3.2.1.js"></script>
<script src = "resources/js/jquery-ui.min.js"></script>
<script src = "resources/js/threejs/three.js"></script>
<script src = "resources/js/threejs/SceneExporter.js"></script>
<script src = "resources/js/threejs/SceneLoader.js"></script>
<script src = "resources/js/threejs/stats.js"></script>
<script src = "resources/js/threejs/Projector.js"></script>
<script src = "resources/js/threejs/OrbitControls.js"></script>
<script src = "resources/js/editor/mapEditor.js"></script>
<script src = "resources/js/editor/minimap.js"></script>
<script src = "resources/js/editor/editor01.js"></script>
<script src = "resources/js/editor/editor02.js"></script>
<title>Editor</title>
</head>
<body>
<div id = "stats"></div>
<div id = "canvas"></div>
<div id = "minimap"></div>
	<input type = "button" value = "firstEditor" id = "firstEditor">
	<input type = "button" value = "secondEditor" id = "secondEdit">
<div id = "objects">
	<div id = "slider"></div>
</div>
</body>
</html>