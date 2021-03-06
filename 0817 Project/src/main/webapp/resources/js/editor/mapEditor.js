/**
 * mapEditor_Main
 * author LSH 2017.9.3
 */

$(function() {
	init();
//	initMinimap();
});

function init() {
	var width = window.innerWidth * 0.7;
	var height = window.innerHeight;

	var stats = initStats();
	var scene = MapEdit01.setBasicOption(scene);
	
	// 랜더러 설정
	var renderer = new THREE.WebGLRenderer();
	renderer.setClearColor(new THREE.Color(0x333333, 1));
	renderer.setSize(width, height);
	renderer.shadowMapEnabled = true;

	$('#canvas').append(renderer.domElement);
	
	//Editor button Event
	$("#firstEditor").on("click", firstEditorSetting);
	$("#secondEdit").on("click", function(){
		$("#objects").empty();
		console.log(scene);
		MapEdit02.setScene(scene);
		$("#firstEditor").on("click");
		$("#secondEdit").off("click");
		$("#canvas").off("click");
		$("#canvas").off("mousedown");
		$("#canvas").off("mousemove");
		$("#canvas").on("mousemove", function(e){
			scene = MapEdit02.moveMousePointer(e, scene);
		});
		$("#canvas").on("mousedown", function(e){
			switch(e.which){
			case 1 : 
				scene = MapEdit02.clickGroupFunction(e, scene);
				break;
			case 3 : 
				//오른쪽버튼 원래 contextmenu 비활성화
				e.preventDefault();
				scene = MapEdit02.mouseRightClick(e, scene);
				break;
			}
		});
		$("#canvas").on("contextmenu",function(e){
			e.preventDefault();
		});
		

		var secBtn = '<input type = "button" value = "올리는용 큐브 더하기" id = "addCubeobj">';
        secBtn += '<input type = "button" value = "취소!" id = "cancel2">';
        
		$("#objects").append(secBtn);
		$("#addCubeobj").on("click", function(){
			scene = MapEdit02.addCube(scene);
		});
        $("#cancel2").on("click", function(){
            scene = MapEdit02.cancel(scene);
        });

	});
	
	render();
	
	function firstEditorSetting(){
		// 1차 에디터 세팅
		firstEdit();

		// canvas내부 마우스 모션에 대한 이벤트
		$("#canvas").on("contextmenu",function(e){
			e.preventDefault();
		});
		$("#canvas").on("mousedown", function(e) {
			switch (e.which) {
			case 1:
				console.log("왼쪽");
				scene = MapEdit01.mouseClickFunction(e, scene);
				break;
			case 3:
				e.preventDefault();
				console.log("오른쪽");
				scene = MapEdit01.downMouseButtonRight(e, scene);
				break;
			}
		});
		$("#canvas").on("mousemove", function(e) {
			scene = MapEdit01.groupMove(e, scene);
		});

		// 버튼에 대한 이벤트
		$("#cube").on("click", function() {
			wallsize = $("#slider").slider("value");
			console.log(wallsize);
			scene = MapEdit01.addCube(scene, wallsize);
		});
		$(".object").on("click", function() {
			btnname = $(this).attr("name");
			scene = MapEdit01.addObject(scene, btnname);
		});
		$("#cancel").on("click", function() {
			scene = MapEdit01.cancel(scene);
		});
		$("#clear").on("click", function() {
			scene = MapEdit01.clearScene(scene);
		});
		$("#rotationR").on("click", function() {
			console.log(scene);
			var buttonName = $(this).val();
			scene = MapEdit01.rotateObj(scene, buttonName);
		});
		$("#rotationL").on("click", function() {
			var buttonName = $(this).val();
			scene = MapEdit01.rotateObj(scene, buttonName);
		});
		$("#saveScene").on("click", function() {
			MapEdit01.saveScene(scene);
			console.log(scene);
		});
		$("#loadScene").on("click", function() {
			scene = MapEdit01.loadScene(scene);
			console.log(scene);
		});
		
		$("#firstEditor").off("click");
	}

	function firstEdit() {
		var buttons = '';
		buttons += '<input type = "button" value = "Cube" id = "cube"><br>';
		buttons += '<input type = "button" value = "object" class = "object" name = "chair01.json"><br>';
		buttons += '<input type = "button" value = "cancel" id = "cancel"><br>';
		buttons += '<input type = "button" value = "clear" id = "clear"><br>';
		buttons += '<input type = "button" value = "rotationR" id = "rotationR"><br>';
		buttons += '<input type = "button" value = "rotationL" id = "rotationL"><br>';
		buttons += '<input type = "button" value = "Save" id = "saveScene"><br>';
		buttons += '<input type = "button" value = "Load" id = "loadScene"><br>';
		
		//큐브 사이즈 조절용 슬라이더바
		console.log("슬라이더 만들기");
		$('#slider').slider({
			value : 5,
			min : 10,
			max : 50,
			step : 10,
			slide : function(e, ui){
				$("#cube").val("size " + ui.value + " wall");
				console.log($("#cube").val());
			}
		});
		$('#objects').append(buttons);
	}
	
	// 랜더러
	function render() {
		stats.update();
		// scene에 들어있는 카메라 찾기
		camera = scene.children.find(function(item) {
			return item instanceof THREE.Camera ? item : null;
		});
		renderer.render(scene, camera);
		requestAnimationFrame(render);
	}

	// Status
	function initStats() {

		var stats = new Stats();
		stats.setMode(0);
		stats.domElement.style.position = "absolute";
		stats.domElement.style.top = "0px";
		stats.domElement.style.top = "0px";

		$("#stats").append(stats.domElement);
		return stats;
	}
}