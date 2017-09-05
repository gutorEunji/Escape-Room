<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script type="text/javascript" src="resources/libs/three.min.js"></script>
	<script type="text/javascript" src="resources/libs/physi.js"></script>
	<script type="text/javascript" src="resources/libs/PointerLockControls.js"></script>
	
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
			<span style="font-size: 40px">시작하려면 클릭하세요</span>
		</div>
	</div>
	
	<script>
	'use strict';
	
	Physijs.scripts.worker = 'resources/libs/physijs_worker.js';
	Physijs.scripts.ammo = 'ammo.js';
	
	// Global
	var scene, camera, renderer, subLight, mainLight, bulbGeometry, bulbMat,
			lightHelper, shadowCameraHelper, ground, ceiling;
	var nWall, wWall, sWall, eWall;
	var controls,
			time = performance.now();
	var objects = [],
			raycaster_right,
			raycaster_left,
			raycaster_forward,
			raycaster_backward;
	var block = document.getElementById( 'block' ),
			instructions = document.getElementById( 'instructions' );
	
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
		camera.position.y = 15;
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
		
		// 조명 생성
		bulbGeometry = new THREE.SphereGeometry( 5, 16, 8 );
		bulbMat = new THREE.MeshStandardMaterial( {
			emissive: 0xffffee,
			emissiveIntensity: 1,
			color: 0x000000
		});
		mainLight = new THREE.SpotLight ( 0xffee88, 20, 2000 );
		mainLight.add( new THREE.Mesh( bulbGeometry, bulbMat ) );
		mainLight.position.set( 0, 100, 0 );
		mainLight.castShadow = true;
		mainLight.shadow.mapSize.width = 1024;
		mainLight.shadow.mapSize.height= 1024;
		scene.add( mainLight );
		
		subLight = new THREE.HemisphereLight(0xddeeff, 0x0f0e0d, 0.02);
		scene.add( subLight );
		
		
		// 땅바닥 생성
		var floorMat = new THREE.MeshStandardMaterial( {
					roughness: 0.8,
					color: 0xDCDCDC,
					metalness: 0.2,
					bumpScale: 0.0005
		});
		var textureLoader = new THREE.TextureLoader();
		textureLoader.load( "resources/images/hardwood2_diffuse.jpg", function( map ) {
			map.wrapS = THREE.RepeatWrapping;
			map.wrapT = THREE.RepeatWrapping;
			map.anisotropy = 4;
			map.repeat.set( 10, 24 );
			floorMat.map = map;
			floorMat.needsUpdate = true;
		} );
		textureLoader.load( "resources/images/hardwood2_bump.jpg", function( map ) {
			map.wrapS = THREE.RepeatWrapping;
			map.wrapT = THREE.RepeatWrapping;
			map.anisotropy = 4;
			map.repeat.set( 10, 24 );
			floorMat.bumpMap = map;
			floorMat.needsUpdate = true;
		} );
		textureLoader.load( "resources/images/hardwood2_roughness.jpg", function( map ) {
			map.wrapS = THREE.RepeatWrapping;
			map.wrapT = THREE.RepeatWrapping;
			map.anisotropy = 4;
			map.repeat.set( 10, 24 );
			floorMat.roughnessMap = map;
			floorMat.needsUpdate = true;
		} );
		
		ground = new Physijs.BoxMesh(
				new THREE.BoxGeometry( 500, 1, 500 ),
				floorMat,
				// new THREE.MeshLambertMaterial( { color: 0xDCDCDC } ),
				0
		);
		ground.receiveShadow = true;
		scene.add( ground );
		
		
		// 천장 생성
		ceiling = new Physijs.BoxMesh (
					new THREE.BoxGeometry( 500, 1, 500 ),
					new THREE.MeshLambertMaterial( { color: 0xFF0000 } ),
					0
		);
		ceiling.receiveShadow = true;
		ceiling.position.y = 101;
		scene.add( ceiling );
		
		// 큐브
		var cubecube = new Physijs.BoxMesh( new THREE.BoxGeometry( 10, 10, 10 ),
																				new THREE.MeshLambertMaterial( { color: 0x00FF00 } ),
																				1 );
		cubecube.position.set ( 20, 10, 20 );
		cubecube.castShadow = true;
		scene.add( cubecube );
		
		
		// 벽생성
		nWall = new Physijs.BoxMesh(
			new THREE.BoxGeometry( 500, 100, 1 ),
			new THREE.MeshLambertMaterial( {color: 0xA9A9A9} ),
			0
		);
		nWall.castShadow = true;
		nWall.position.y = 50;
		nWall.position.z = -249.5;
		nWall.name = "북쪽 벽";
		scene.add( nWall );
		objects.push( nWall );
		
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
		
		window.addEventListener( 'resize', onResize, false );
	}; // end init
	
	// 자동 리사이즈
	var onResize = function() {
		
		camera.aspect = window.innerWidth / window.innerHeight;
		camera.updateProjectionMatrix();
		renderer.setSize(window.innerWidth, window.innerHeight);
	
	};
	
	// 렌더
	var render = function() {
		requestAnimationFrame( render );
		
		console.log ( camera.position );
		// console.log ( camera.getWorldDirection() );
		
		raycaster_forward.ray.origin.copy(controls.getObject().position);
		raycaster_forward.ray.origin.z -= 10;
		raycaster_backward.ray.origin.copy(controls.getObject().position);
		raycaster_backward.ray.origin.z += 10;
		raycaster_left.ray.origin.copy(controls.getObject().position);
		raycaster_left.ray.origin.x -= 10;
		raycaster_right.ray.origin.copy(controls.getObject().position);
		raycaster_right.ray.origin.x += 10;
		
		var forward_intersections = raycaster_forward.intersectObjects( objects );
		var backward_intersections = raycaster_backward.intersectObjects( objects );
		var left_intersections = raycaster_left.intersectObjects( objects );
		var right_intersections = raycaster_right.intersectObjects( objects );
		
		// 인터섹션이 있는경우
		if ( forward_intersections.length > 0 ) {
			var distance = forward_intersections[0].distance;
			if ( distance > 0 && distance < 10 ) {
				controls.getObject().position.z = forward_intersections[0].point.z + 20;
				if ( forward_intersections[0].object.name ) {
					console.log( forward_intersections[0].object.name );
				} else {
					context.clearRect(0,0,300,300);
					texture.needsUpdate = true;
				}
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
		
		renderer.render( scene, camera );
	}; // end render
	
	
	pointerLockControls();
	init();
	render();
	</script>
</body>
</html>