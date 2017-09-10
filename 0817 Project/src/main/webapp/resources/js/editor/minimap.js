/**
 * minimap.js
 * author LSH
 * 2017.8.31
 */

	function initMinimap(){
		var saveJSON = {};
		var sceneJSON;
		var scene = new THREE.Scene(); 
		var loader = new THREE.SceneLoader();
		
		var camera = new THREE.PerspectiveCamera(60,200/200, 1, 1000);
		camera.position.set(0,50,0);
		camera.lookAt(scene.position);
//		console.log(camera);
		
		var minimaprenderer = new THREE.WebGLRenderer();
		minimaprenderer.setClearColor(0x000000, 1);
		minimaprenderer.setSize(200, 200);
		minimaprenderer.domElement.style.position = "absolute";
		minimaprenderer.domElement.style.left = "0px";
		minimaprenderer.domElement.style.bottom = "0px";
		
		var orbit = new THREE.OrbitControls(camera, minimaprenderer.domElmenet);
		
		$("#canvas").append(minimaprenderer.domElement);
		
		render();
		
		function render(){
			sceneJSON = JSON.parse(localStorage.getItem("savedScene"));
			checkJSON(sceneJSON.objects);
			orbit.update();
			minimaprenderer.render(scene, camera);
			requestAnimationFrame(render);
		}
		
		
		//LocalStorage의 정보가 변경되었을 경우, 이 함수를 실행해서 Scene를 업데이트한다.
		function checkJSON(objs){
			//저장된 scene가 같지 않을 때(업데이트 됨)
			if(Object.keys(objs).length != Object.keys(saveJSON).length){
				//오브젝트 복사하기
				for(var i in objs)	saveJSON[i] = objs[i];
				
				for(var i in sceneJSON.textures){
					sceneJSON.textures[i].url = "asset/texture/" + sceneJSON.textures[i].url;
				}
				
				//sceneJSON 의 오브젝트 이름일 cube가 아니고 Object로 시작하지도 않을 때 사용자 설정 object를 로딩해서 설정해주기
				var objLoader = new THREE.JSONLoader();
				var objPath = "resources/asset/model/";
				var objs = sceneJSON.objects;
				var keys = Object.keys(objs);
//				console.log(sceneJSON);
				
				for(var i in keys){
					var name = keys[i];
					index = name.indexOf("_");
					prename = name.substr(0, index);
//					console.log(prename+" : "+ prename != "Object" && prename != "cube");
					
					if(prename != "Object" && prename != "wall"){
//						console.log(prename);
						//object의 정보 받아오기
						position = objs[name].position;
						scale = objs[name].scale;
						
//						console.log(position);
//						console.log(scale);
						
//						console.log(objPath + prename);
						objLoader.load(objPath + prename ,function(geom, mat){
							mesh = new THREE.SceneUtils.createMultiMaterialObject(geom, mat);
							mesh.scale.set(scale[0] , scale[1], scale[2]);
							mesh.position.set(position[0], position[1], position[2]);
							mesh.name = name;
//							console.log("새로 만든 매쉬");
//							console.log(mesh);
							scene.add(mesh);
//							console.log(scene);
						}, 'resources/asset/texture/');
					}
				}
				
				//sceneLoader
				loader.parse(sceneJSON, function(e){
					scene = e.scene;
				},".");
			}
			
		}
		
	}