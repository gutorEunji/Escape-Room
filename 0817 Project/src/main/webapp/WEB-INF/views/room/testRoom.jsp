<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" href="resources/css/slick-theme.css">
	<link rel="stylesheet" href="resources/css/slick.css">
	<link rel="stylesheet" href="resources/css/animate.css">
	<link rel="stylesheet" href="resources/css/main.css">
	<link rel="stylesheet" href="resources/css/loading.min.css"> <!-- CSS reset -->
	
	<script type="text/javascript" src="resources/js/three.min.js"></script>
	<script type="text/javascript" src="resources/js/physi.js"></script>
	<script type="text/javascript" src="resources/js/PointerLockControls.js"></script>
	
	<style type="text/css">
		body {
			margin: 0;
			overflow: hidden;
			background: #efefef;
		  font: 30px sans-serif;
		}
		
		* {
	  margin: 0;
	  padding: 0;
	  border: 0;
		}
		
		#instructions {
			width: 100%;
			height: 100%;
		
			display: -webkit-box;
			display: -moz-box;
			display: box;
		
			-webkit-box-orient: horizontal;
			-moz-box-orient: horizontal;
			box-orient: horizontal;
		
			-webkit-box-pack: center;
			-moz-box-pack: center;
			box-pack: center;
		
			-webkit-box-align: center;
			-moz-box-align: center;
			box-align: center;
		
			color: #ffffff;
			text-align: center;
		
			cursor: pointer;
		}
	</style>
</head>
<body>

	<div id="block">
		<div id="instructions">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-9 col-md-7 col-sm-7 col-xs-2 da-text-align-right">
				<div class="da-menu-button">
					<img src="resources/images/menu-icon.png" alt="Menu">
				</div>
				<nav>
					<ul class="da-menu">
						<li><span class="da-hover-menu-line">Inventory</span>
							<!-- <a href="#" onclick="updateForm()"></a> -->
						</li>
						<li class="da-active-menu-link"><span class="da-hover-menu-line">Play</span>
							<!-- <a href="#" onclick="logout()"></a> -->
						</li>
						<li class="da-active-menu-link"><span class="da-hover-menu-line">Escape</span>
							<!-- <a href="#"></a> -->
						</li>
					</ul>
				</nav>
			</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
	'use strict';
	
	Physijs.scripts.worker = 'resources/js/physijs_worker.js';
	Physijs.scripts.ammo = 'ammo.js';
	
	// Global
	var scene, camera, renderer, subLight, mainLight, bulbGeometry, bulbMat,
			lightHelper, shadowCameraHelper, ground, ceiling, analyser;
	var nWall, wWall, sWall, eWall;
	var controls,
			time = performance.now();
	var objects = [],
			raycaster_right,
			raycaster_left,
			raycaster_forward,
			raycaster_backward,
			raycasterFromCamera;
	var block = document.getElementById( 'block' ),
			instructions = document.getElementById( 'instructions' );
	var outlinePass, // 아웃라인 변수
	    composer,
	    effectFXAA;
	
	var mesh1, meshes, mesh_door;
	var move_hand = 0.01;
	
	//screen loader
	var loadingScreen = {
			scene : new THREE.Scene(),
			camera : new THREE.PerspectiveCamera(90, window.innerWidth/window.innerHeight, 0.1, 1000),
			box : new THREE.Mesh(
				new THREE.BoxGeometry(0.5,0.5,0.5),
				new THREE.MeshBasicMaterial({color : 0x444ff})
			)
	};// 로딩스크린객체를 잡기위한 객체를 생성 
	
	var RESOURCES_LOADED = false;
	// boolean 변수를 추가하여 언제 소스가 준비 되었는지 추적할 수 있다.
	var LOADING_MANAGER = null;
	var json_object = [
		'wall'
	];
	var json_object_context = {
			wall:{
				name:'resources/json/wall_door.json',
				position:'1,-5,255',
				scale:'28,25,50'
			}				
	};
	
	// 포인터락컨트롤
	var pointerLockControls = function() {
		console.log( "포인터락 시작" );
		
		var havePointerLock = "pointerLockElement" in document ||
													"mozPointerLockElement" in document ||
													"webkitPointerLockElement" in document;
		if ( havePointerLock ) {
			var element = document.body;
			var pointerLockChange = function( e ) {
				if ( document.pointerLockElement === element ||
						document.mozPointerLockElement === element ||
						document.webkitPointerLockElement === element ) {
					controls.enabled = true;
					block.style.display = "none";
				} else {
					controls.enabled = false;
					block.style.display = "-webkit-box";
					block.style.display = "-moz-box";
					block.style.display = "box";
					instructions.style.display = "";
				} //end if-else
			} //end pointerLockChange
			
			var pointerLockError = function( event ) {
				instructions.style.display = "";
			} //end pointerLockError
				
			document.addEventListener( "pointerlockchange", pointerLockChange, false );
			document.addEventListener( "mozpointerlockchange", pointerLockChange, false );
			document.addEventListener( "webkitpointerlockchange", pointerLockChange, false );
			
			document.addEventListener( "pointerlockerror", pointerLockError, false );
			document.addEventListener( "mozPointerlockerror", pointerLockError, false );
			document.addEventListener( "webkitPointerlockerror", pointerLockError, false );
			
			instructions.addEventListener( "click", function( event ) {
				instructions.style.display = "none";
				element.requestPointerLock = element.requestPointerLock ||
												element.mozRequestPointerLock ||
												element.webkitRequestPointerLock;
				element.requestPointerLock();
			}, false );
		} else {
			console.log( "띠용" );
		} // end if 
	}; // 포인터락컨트롤
	
	// 이니셜라이즈 - 씬 생성
	var init = function() {
		
		var fftSize = 2048;
		
		console.log( "초기화시작" );
		
		// 렌더러 생성
		renderer = new THREE.WebGLRenderer( );
		renderer.physicallyCorrectLights = true;
		renderer.gammaInput = true;
		renderer.gammaOutput = true;
		renderer.shadowMap.enabled = true;
		renderer.toneMapping = THREE.ReinhardToneMapping;
		renderer.setPixelRatio( window.devicePixelRatio );
		renderer.setSize( window.innerWidth, window.innerHeight );
		renderer.shadowMap.enabled = true;
		document.body.appendChild( renderer.domElement );
		
		// 씬 생성
		scene = new Physijs.Scene;
		scene.setGravity( new THREE.Vector3 ( 0, -30, 0 ) );
		
		// 카메라 생성
		camera = new THREE.PerspectiveCamera(
						45,
						window.innerWidth / window.innerHeight,
						0.1,
						2000
		);
		camera.position.y = 30;
		camera.lookAt( scene.position );
		scene.add( camera );
		
		controls = new THREE.PointerLockControls( camera );
		scene.add( controls.getObject() );
		
		// 레이캐스터
		raycaster_forward = new THREE.Raycaster();
		raycaster_forward.ray.direction.set( 0, 0, -1 );
		
		raycaster_backward = new THREE.Raycaster();
		raycaster_backward.ray.direction.set( 0, 0, 1 );
		
		raycaster_left = new THREE.Raycaster();
		raycaster_left.ray.direction.set( -1, 0, 0 );
		
		raycaster_right = new THREE.Raycaster();
		raycaster_right.ray.direction.set( 1, 0, 0 );
		
		raycasterFromCamera = new THREE.Raycaster();
		raycasterFromCamera.far = 30;
		
		// 로딩 스크린을 set up 시켜 놓는다.
		loadingScreen.box.position.set(0,0,5);
		loadingScreen.camera.lookAt(loadingScreen.box.position);
		loadingScreen.scene.add(loadingScreen.box);
		
		LOADING_MANAGER = new THREE.LoadingManager();
		LOADING_MANAGER.onProgress = function (item, loaded, total) {//onProgress는  매번 리소스가 로딩되는 트리거이다  onload는 모든 소스가 로딩된 것
			console.log(item, loaded, total);
		};
		LOADING_MANAGER.onLoad = function () {
			console.log("loaded all resources");
			RESOURCES_LOADED = true;
			onResourcesLoaded(); // 리소스가 로드 되었을때의 트리거 함수를 생성
		}
		//사운드
		var audioLoader = new THREE.AudioLoader(LOADING_MANAGER);
		var listener = new THREE.AudioListener(LOADING_MANAGER);
		camera.add( listener );
		var audio = new THREE.Audio( listener );
		audioLoader.load( 'resources/music/bell.mp3', function( buffer ) {
			audio.setBuffer( buffer );
			audio.setLoop( true );
			audio.play();
		});
		analyser = new THREE.AudioAnalyser( audio, fftSize );
		
		
		// 조명 생성
		bulbGeometry = new THREE.SphereGeometry( 5, 16, 8 );
		bulbMat = new THREE.MeshStandardMaterial( {
			emissive: 0xffffee,
			emissiveIntensity: 1,
			color: 0x000000
		});
		mainLight = new THREE.SpotLight ( 0x222222, 25, 2500 ); // 붉은 조명 입힘
		mainLight.add( new THREE.Mesh( bulbGeometry, bulbMat ) );
		mainLight.position.set( 0, 150, 0 );
		mainLight.castShadow = true;
		mainLight.shadow.mapSize.width = 1024;
		mainLight.shadow.mapSize.height= 1024;
		mainLight.angle = Math.PI/2.2;
		scene.add( mainLight );
		
		subLight = new THREE.HemisphereLight(0x660033, 0x660033, 0.04);
		scene.add( subLight );
		
		// 손 생성
		var loader = new THREE.JSONLoader(LOADING_MANAGER);
			loader.load('resources/json/hand/handd.json', function(geomerty, mat){
			mesh1 = new THREE.Mesh(geomerty,mat[0]);
			mesh1.scale.set(0.7,0.7,0.7);
			mesh1.position.set(controls.getObject().position.x + 3, controls.getObject().position.y - 14, controls.getObject().position.z-7);
			mesh1.rotation.y -= 0.5;
			mesh1.rotation.x += 0.5;
			camera.add(mesh1);
		});
			
		objectLoad(LOADING_MANAGER);
		/* for (var i = 0; i < json_object.length; i++) {
			alert(json_object_context[json_object[i]].name); 
			 loader.load(json_object_context[json_object[i]].name, function(geomerty, mat){
		           meshes = new THREE.Mesh(geomerty, mat[0]);
		           alert(json_object_context[json_object[i]]); 
		           meshes.position.set(json_object_context[json_object[i]].position);
		           meshes.scale.set(json_object_context[json_object[i]].scale);
		           scene.add(meshes);
			});
		} */
		var loader = new THREE.TextureLoader(LOADING_MANAGER);	
		
		ground = new Physijs.BoxMesh(
				new THREE.BoxGeometry( 500, 1, 500 ),
				new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
				0
		);
		ground.receiveShadow = true;
		scene.add( ground );
		
		//바닥 texture
		var texture1 = loader.load("resources/T_Sandstone.png");
		ground.material.map = texture1;
		texture1.repeat.set(4, 4);
		texture1.wrapS = THREE.RepeatWrapping;
		texture1.wrapT = THREE.RepeatWrapping;
		
		 
		// 천장 생성
		ceiling = new Physijs.BoxMesh (
		          new THREE.BoxGeometry( 500, 1, 500 ),
	              new THREE.MeshLambertMaterial( { color: 0xFF0000 } ),
				  0
		);
		ceiling.receiveShadow = true;
		ceiling.position.y = 101;
		scene.add( ceiling );
		
		 var texture2 = loader.load("resources/blood.png");
		 ceiling.material.map = texture2;
		 texture2.repeat.set(8, 8);
		 texture2.wrapS = THREE.RepeatWrapping;
		 texture2.wrapT = THREE.RepeatWrapping;
		
		// 벽생성
		// North
		nWall = new Physijs.BoxMesh( 
			new THREE.BoxGeometry( 500, 100, 1 ),
			new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
			0
		);
		nWall.receiveShadow = true;
		nWall.position.y = 50;
		nWall.position.z = -249.5;
		nWall.name = "북쪽 벽";
		scene.add( nWall );
		objects.push( nWall );
		
		// South
		sWall = new Physijs.BoxMesh(
				new THREE.BoxGeometry( 500, 100, 1 ),
				new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
				0
		);
		sWall.castShadow = true;
		sWall.position.y = 50;
		sWall.position.z = 249.5;
		sWall.name = "남쪽 벽";
		scene.add( sWall );
		objects.push( sWall );
		
		// East
		eWall = new Physijs.BoxMesh( 
				new THREE.BoxGeometry( 1, 100, 500 ),
				new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
				0
		);
		eWall.castShadow = true;
		eWall.position.y = 50;
		eWall.position.x = 249.5;
		eWall.name = "동쪽 벽";
		scene.add( eWall );
		objects.push( eWall );
		
		// West
		wWall = new Physijs.BoxMesh(
				new THREE.BoxGeometry( 1, 100, 500 ),
				new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
				0
		);
		wWall.castShadow = true;
		wWall.position.y = 50;
		wWall.position.x = -249.5;
		wWall.name = "서쪽 벽";
		scene.add( wWall );
		objects.push( wWall );
		
		// 벽 texture
		var texture = loader.load("resources/pietrac.png");
		nWall.material.map = texture;
		wWall.material.map = texture;
		eWall.material.map = texture;
		sWall.material.map = texture;
		//ceiling.material.map = texture;
		texture.repeat.set(4, 4); 
		texture.wrapS = THREE.RepeatWrapping;
		texture.wrapT = THREE.RepeatWrapping;
		
		// 임시 큐브
        var cubecube = new Physijs.BoxMesh(
                       new THREE.BoxGeometry( 30, 30, 30 ),
                       new THREE.MeshLambertMaterial ( {color: 0xFF0000} )
        );
        cubecube.castShadow = true;
        cubecube.position.set( 20, 20, 20 );
        scene.add( cubecube );
        objects.push( cubecube );
        
        // 외곽선 추가
        composer = new THREE.EffectComposer( renderer );
        var renderPass = new THREE.RenderPass( scene, camera );
        composer.addPass( renderPass );
        outlinePass = new THREE.OutlinePass( new THREE.Vector2 ( window.innerWidth, window.innerHeight ), scene, camera );
        outlinePass.pulsePeriod = 2;
        composer.addPass( outlinePass );
        
        effectFXAA = new THREE.ShaderPass(THREE.FXAAShader);
        effectFXAA.uniforms['resolution'].value.set( 1 / window.innerWidth,
        		                                     1 / window.innerHeight );
        effectFXAA.renderToScreen = true;
        composer.addPass( effectFXAA );
        
		window.addEventListener( 'keypress', function(e) {
            var keycode = event.keyCode;
            if ( keycode == 92 ) {
                controls.getObject().position.x = 0; // 카메라 포지션 원위치
                controls.getObject().position.z = 0;
                console.log ( raycasterFromCamera );
            }
        }, false );
        
        
		window.addEventListener( 'resize', onResize, false );
	}; // end init
	
	// ??
	function objectLoad() {
		//문
		var loader = new THREE.JSONLoader( LOADING_MANAGER );
			loader.load('resources/json/mainDoor/only_door.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty, mat[0]);
			mesh_door.scale.set(35,35,35);
			mesh_door.position.set(1,0,255);
			mesh_door.rotation.y += Math.PI;
			scene.add(mesh_door);
		}); 
		//책
		loader.load('resources/json/book/books.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(20,20,20);
			mesh_door.position.set(150,0,150);
			mesh_door.rotation.y += Math.PI+0.2;
			scene.add(mesh_door); 
		});
		//책장
		loader.load('resources/json/bookcase/bookcase.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(12,10,12);
			mesh_door.position.set(200,0,200);
			mesh_door.rotation.y += 2*Math.PI/2.3;
			scene.add(mesh_door);
		});
		
		//책장
		loader.load('resources/json/bookcase2/BSwap_FurniturePack.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(0.7,0.7,0.7);
			mesh_door.position.set(50,0,-220);
			scene.add(mesh_door);
		});
		//종이 박스
		loader.load('resources/json/boxes/Box1_TotallyClosed.json', function(geomerty, mat){
				var height = 0;
				var left = 0;
			for (var i = 0; i < 6; i++) {
				mesh_door = new THREE.Mesh(geomerty,mat[0]);
				mesh_door.scale.set(10,10,10);
				mesh_door.position.set(200-left,0+height,-220);
				scene.add(mesh_door);
				if (left != 40) {
					left += 40;
				}else if(height != 60 && left == 40){
					height += 20;
				}
			}
		});
		
		
		//boat
		loader.load('resources/json/car/uigaw0gc9w-Barco.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(22,22,22);
			mesh_door.position.set(150,2,-70);
			mesh_door.rotation.y -= Math.PI/6;
			scene.add(mesh_door);
		});
		
		
		//도끼
		loader.load('resources/json/axe/axe.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(30,30,30);
			mesh_door.position.set(170,3,-135);
			//mesh_door.rotation.z -= Math.PI/2;
			mesh_door.rotation.z += Math.PI/6;
			scene.add(mesh_door);
		});
		
		
		//가스통 꾸러미
		loader.load('resources/json/gas-tank/gas-tank.json', function(geomerty, mat){
				var gap = 10;
			for (var i = 0; i < 3; i++) {
				if (gap == 10) {
					mesh_door = new THREE.Mesh(geomerty,mat[0]);
					mesh_door.scale.set(3,3,3);
					mesh_door.position.set(-200+gap,5,-100);
					mesh_door.rotation.z -= 1.6;
					mesh_door.rotation.y += 0.6;
					scene.add(mesh_door); 
				}
				mesh_door = new THREE.Mesh(geomerty,mat[0]);
				mesh_door.scale.set(3,3,3);
				mesh_door.position.set(-200+gap,5,-120);
				scene.add(mesh_door); 
				gap += 10;
			}
		});
		//금고
		loader.load('resources/json/safe/safe_close.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(0.7, 0.7, 0.7);
			mesh_door.position.set(30,0,45);
			mesh_door.rotation.y -= Math.PI/2;
			scene.add(mesh_door); 
		});
		//우유 상자
		loader.load('resources/json/milk box/milk-crate.json', function(geomerty, mat){
			var height = 0;
			var right = 0;
			var down = 0;
			for (var i = 0; i < 3; i++) {
				mesh_door = new THREE.Mesh(geomerty,mat[0]);
				mesh_door.scale.set(5, 5, 5);
				mesh_door.position.set(-110+right,0+height,-220);
				scene.add(mesh_door);
				if (right != 60) {
					right += 30;
				}else if(height != 60 && right == 40){
					height += 10;
					down += 20 
				}
			}
		});
		//테이블
		loader.load('resources/json/table/crashed_buteco.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(50, 50, 50);
			mesh_door.position.set(150,0,50);
			scene.add(mesh_door);   
		});
		//캔 테이블 위
		loader.load('resources/json/can/Cola_Pepsi_Redbull.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(30, 30, 30);  
			mesh_door.position.set( 150 ,4.5, 50);
			scene.add(mesh_door);    
		});
		//침대
		loader.load('resources/json/bed/old_bed.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(30, 30, 30);
			mesh_door.position.set(-150,0,+150);
			mesh_door.rotation.y += Math.PI/3;
			scene.add(mesh_door);   
		});
		//통나무
		loader.load('resources/json/logs/wood.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(10, 10, 10);
			mesh_door.position.set(-200,0,-150);
			scene.add(mesh_door);    
		});
		//낡은 침대
		loader.load('resources/json/bed/bed.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(20, 20, 20);  
			mesh_door.position.set(-200,0,-80);
			mesh_door.rotation.y += Math.PI/3;
			scene.add(mesh_door);    
		});
		//음료수 자판기
		loader.load('resources/json/vending machine/Orangesplosion_Soda_Machine.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(15, 15, 15);  
			mesh_door.position.set(-235,0,0);
			scene.add(mesh_door);    
		});
		//동상
		loader.load('resources/json/statue/Melpomene.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(15, 15, 15);  
			mesh_door.position.set(-220,0,200);
			mesh_door.rotation.y += Math.PI/1.8;
			scene.add(mesh_door);    
		});
		//우유탱크
		loader.load('resources/json/milkTank/milk tank.json', function(geomerty, mat){
			var gap = 10;
			for (var i = 0; i < 3; i++) {
				mesh_door = new THREE.Mesh(geomerty,mat[0]);
				mesh_door.scale.set(30, 30, 30);
				mesh_door.position.set(-220+gap,0,-230);
				scene.add(mesh_door);  
				gap += 30;
			}
		});
		//돈
		loader.load('resources/json/dollar/dollars.json', function(geomerty, mat){
			var up = 0, right = 0, left = 0, down = 0;
			for (var i = 0; i < 32; i++) {
				mesh_door = new THREE.Mesh(geomerty,mat[0]);
				mesh_door.scale.set(1, 1, 1);  
				mesh_door.position.set(0+left-right,2,0+up-down);
				scene.add(mesh_door);
				if (left != 80) {
					left += 10;
				}else if(up != 80 && left == 80){
					up += 10;
				}else if(right != 80 && left == 80 && up == 80){
					right += 10;
				}else if(down != 80 && left == 80 && up == 80 && down == 80){
					down += 10;
				}
			}
		});
		
		//양초
		loader.load('resources/json/candle/MedievalWallSconce 1_1.json', function(geomerty, mat){
			mesh_door = new THREE.Mesh(geomerty,mat[0]);
			mesh_door.scale.set(3, 3, 3);  
			mesh_door.position.set(10,0,20);
			scene.add(mesh_door);    
		});
		
		
	}		
	
	function onResourcesLoaded() {
		
	}
	
	// 자동 리사이즈
	var onResize = function() {
		camera.aspect = window.innerWidth / window.innerHeight;
		camera.updateProjectionMatrix();
		renderer.setSize( window.innerWidth, window.innerHeight );
		composer.setSize( window.innerWidth, window.innerHeight );
		effectFXAA.uniforms['resolution'].value.set(1 / window.innerWidth,
                                                    1 / window.innerHeight );  
	};
	
	// 렌더
	var render = function() {
		
		if (RESOURCES_LOADED == false) {
			requestAnimationFrame(render);
			loadingScreen.box.position.x -= 0.05;
			
			if (loadingScreen.box.position.x < -10) {
				loadingScreen.box.position.x = 10;
			} // 화면을 넘어가면 초기화

			loadingScreen.box.position.y = Math.sin(loadingScreen.box.position.x);
			renderer.render(loadingScreen.scene, loadingScreen.camera);
			return;
		}
		
		// 손의 위아래 움직임
		requestAnimationFrame( render );
		var limit = 0.6
		if (move_hand < 0.3 ) {
			mesh1.position.y += 0.01;
			move_hand+=0.01;
		}
		if (move_hand > limit) {
			move_hand = 0.01;
		}
		if(move_hand >= 0.3){
			mesh1.position.y -= 0.01;
			move_hand+=0.01;
		}
		
		raycaster_forward.ray.origin.copy(controls.getObject().position);
		raycaster_forward.ray.origin.z -= 10;
		raycaster_backward.ray.origin.copy(controls.getObject().position);
		raycaster_backward.ray.origin.z += 10;
		raycaster_left.ray.origin.copy(controls.getObject().position);
		raycaster_left.ray.origin.x -= 10;
		raycaster_right.ray.origin.copy(controls.getObject().position);
		raycaster_right.ray.origin.x += 10;

		raycasterFromCamera.ray.direction = camera.getWorldDirection().normalize();
		raycasterFromCamera.ray.origin.copy( controls.getObject().position );
		raycasterFromCamera.ray.origin.y += 10;
		
		var forward_intersections = raycaster_forward.intersectObjects( objects );
		var backward_intersections = raycaster_backward.intersectObjects( objects );
		var left_intersections = raycaster_left.intersectObjects( objects );
		var right_intersections = raycaster_right.intersectObjects( objects );
		var cameraIntersections = raycasterFromCamera.intersectObjects( objects );
		
		// 인터섹션이 있는경우
		if ( cameraIntersections.length > 0 ) {
            var selectedObjects = [];
            selectedObjects.push ( cameraIntersections[0].object );
            outlinePass.selectedObjects = selectedObjects;
        } else {
        	outlinePass.selectedObjects = [];
        }
		
		if ( forward_intersections.length > 0 ) {
			var distance = forward_intersections[0].distance;
			if ( distance > 0 && distance < 10 ) {
				controls.getObject().position.z = forward_intersections[0].point.z + 20;
			}
		}

		if ( backward_intersections.length > 0 ) {
			var distance = backward_intersections[0].distance;
			if ( distance > 0 && distance < 10 ) {
				controls.getObject().position.z = backward_intersections[0].point.z - 20;
			}
		}
		
		if ( left_intersections.length > 0 ) {
			var distance = left_intersections[0].distance;
			if ( distance > 0 && distance < 10 ) {
				controls.getObject().position.x = left_intersections[0].point.x + 20;
			}
		}
					
		if ( right_intersections.length > 0 ) {
			var distance = right_intersections[0].distance;
			if ( distance > 0 && distance < 10 ) {
				controls.getObject().position.x = right_intersections[0].point.x - 20;
			}
		}
		
		scene.simulate();
		controls.update( performance.now() - time );
		time = performance.now();
		composer.render();
		
		// renderer.render( scene, camera ); 
	}; // end render

	pointerLockControls();
	init();
	render();
	</script>
</body>
</html>