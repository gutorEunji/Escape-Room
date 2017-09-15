/**
 * mapEditor01
 * author LSH
 * 2017.9.3
 */

var MapEdit01 = {
	//Object로 만들어서 사용하기 : 변수
	//선택 여부
	isSelected : false
	//이동중 여부
	, ismove : false
	//마우스 위치
	, mouse : {x : 0, y : 0}
	//마우스 위치를 파악할 타겟 리스트 : plane 포함
	, targetList : []
	//설치된 오브젝트만 타겟으로 하는 리스트 
	, targetGroup : []
	, savePoint : null
	, group : null
	//cube와 obj의 이름에 사용할 숫자
	, cubenum : 0
	, objnum : 0
	, btnname : null
	, width : window.innerWidth * 0.7
	, height : window.innerHeight

	//함수
	, setBasicOption : function(scene){
		console.log("기본 Scene세팅하기");
		scene = new THREE.Scene();
		//빛 더해주기
		pointLight = new THREE.PointLight(0xffffff);
		pointLight.position.set(100, 250, 100);

		pointLight2 = new THREE.PointLight(0xffffff);
		pointLight.position.set(-150, 150, -150);
		
		//와이어프레임 붙어있는 planeMesh
		planeG = new THREE.PlaneGeometry(50, 50,10,10);
		planeMWire = new THREE.MeshBasicMaterial({color : 0xEEEEEE
			, vertexColors: THREE.FaceColors
			, wireframe: true
			, transparent: true
			, opacity : 0.3
			});
		
		for(var i = 0; i<planeG.faces.length; i++){
			face = planeG.faces[i];
			face.color.setHex(0xcccccc);
		}
		planeMesh = new THREE.Mesh(planeG, planeMWire);
		
		planeMesh.rotation.x = -Math.PI / 2;
		planeMesh.position.set(0, 0, 0);
		planeMesh.name = "plane";
		
		//카메라 만들기
		fov = 60;
		aspect = this.width / this.height;
		near = 0.01;
		far = 1000;
		var camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
		camera.position.set(0, 50, 0);
        camera.lookAt(scene.position);
        
		scene.add(planeMesh);
		scene.add(pointLight);
		scene.add(pointLight2);
		scene.add(camera);
		
		this.targetList = [planeMesh];
		this.targetGroup = [];
		
		this.saveScene(scene);
		
		return scene;
	}
	
	//cube group 만들기
	,addCube : function(scene, wallsize){
		console.log("큐브만들기 : 나중에 텍스쳐 추가");
		this.mouseClickFunction(null, scene, "removeSecneGroup");
		if(this.findGroup(scene)) scene.remove(group);
		smallPlane = this.makeSmallPlane();
		//z축을 기준으로 벽의 길이 결정하기
		cubeG = new THREE.BoxGeometry(1,10,wallsize,1,1,1);
		cubeM = new THREE.MeshLambertMaterial({color : Math.random() * 0xffffff});
		cube = new THREE.Mesh(cubeG, cubeM);
		
		cubeHeight = cubeG.parameters.height;
		cube.position.set(0,cubeHeight/2,0);
		
		this.group = new THREE.Group();
		this.group.add(smallPlane);
		this.group.add(cube);
		console.log(this.group);
		
		scene.add(this.group);
		
		return scene;
	}
	
	//Object group 만들기
	,addObject : function(scene, btnname){
		console.log("오브젝트 가져와서 만들기");
		this.mouseClickFunction(null, scene, "removeSecneGroup");
		group = this.findGroup(scene);
		if(group) scene.remove(group);
		this.btnname = btnname;
		//scene에 추가할 새 움직이는 그룹 만들기
		smallPlane = this.makeSmallPlane();
		this.group = new THREE.Group();
		this.group.add(smallPlane);
		console.log(this.group);
		
		var mesh; 
		var loader = new THREE.JSONLoader();
		loader.load('resources/json/model/chair01.json', function(geomerty, mat){
			mesh = new THREE.Mesh(geomerty, mat[0]);
			console.log(mesh);
			mesh.scale.set(4,4,4);
			mesh.position.set(0, 0, 0);
			MapEdit01.group.add(mesh);
		}, 'resources/json/texture/');
		console.log(this.group);
		scene.add(this.group);
		
		return scene;
	}
	
	//브러쉬 취소
	,cancel : function(scene){
		console.log("cnacle");
		findgroup = this.findGroup(scene);
		if(findgroup){
			if(this.isSelected){
				console.log("cancel : 선택취소");
				temp = findgroup.children[1];
				
				//group엔 더 이상 볼 일 없으므로 지워주기
				scene.remove(group);
				scene.add(temp);

				this.isSelected = false;
			}
			else{
				console.log("브러쉬 취소");
				scene.remove(findgroup);
				findgroup = null;
			}
		}
//		this.saveScene(scene);
		
		return scene;
	}

	//scene 비우기
	,clearScene : function(scene){
		group = this.findGroup(scene);
		if(group) scene.add(group);
		scene = this.setBasicOption(scene);
		console.log(scene);
		console.log(this.targetList);
		console.log(this.targetGroup);
		return scene;
	}
	
	//그룹 회전시키기
	, rotateObj : function(scene, buttonName){
		group = this.findGroup(scene);
		
		if(group){
			var rotation;
			if(buttonName == 'rotationR') rotation = Math.PI / 4;
			else rotation = -(Math.PI / 4);
			console.log("회전 각도 : " + rotation);
			
			//현재 선택되어있는 객체 가져오기
			selectedGroup = group;
			var selectedObj;
			if(selectedGroup != null) selectedObj = selectedGroup.children[1];
			console.log("회전시킬 nowSelectObj : ");
			console.log(selectedObj);
			selectedObj.rotation.y += rotation;
			
			scene.remove(this.findGroup(scene));
			scene.add(selectedGroup);
			
			return scene;
		}
	}
	
	//scene 저장하기
	, saveScene : function(scene){
		console.log("장면 저장하기");
		var exporter = new THREE.SceneExporter();
		scenej = exporter.parse(scene);
//		console.log(scene);
		sceneJSON = JSON.stringify(scenej);
		localStorage.setItem("savedScene", sceneJSON);
	}
	
	//scene 불러오기
	, loadScene : function(scene){
		console.log("저장된 장면 불러오기");
		sceneJSON = JSON.parse(localStorage.getItem("savedScene"));
		//textures url 재설정
		var textures = sceneJSON.textures;
		for(var i in textures){
			textures[i].url = "resources/asset/texture/" + textures[i].url;
		}
		//scene Load
		var loader = new THREE.SceneLoader();
		loader.parse(sceneJSON, function(e){
			scene = e.scene;
		},".");
		console.log(scene);
		return scene;
	}
	
	//MouseMove Event Handler
	, groupMove : function(e, scene){
		//마우스 위치 받아오기
		this.mouse.x = (e.clientX / this.width)*2 - 1;
    	this.mouse.y = -(e.clientY / this.height)*2 + 1;
    	
    	//scene에 들어있는 카메라 찾기
    	camera = scene.children.find(function(item){
    		return item instanceof THREE.Camera ? item : null;
    	});
    	
    	//마우스 포인터의 위치에 따라 Object 인식하기
    	var projector = new THREE.Projector();
    	var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
    	projector.unprojectVector(vector, camera);
    	var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
		var intersects = raycaster.intersectObjects(this.targetList);
    	
		//부모 객체와의 교차점이 하나 이상 있는 경우
		if(intersects.length > 0){
    		points = intersects[0].point;
    		plane = scene.children.find(function(item){
    			if(item.geometry instanceof THREE.PlaneGeometry)
    				return item;
    		});
    		planeG = plane.geometry;
//    		console.log(planeG);
    		segmentW = planeG.parameters.widthSegments / 4;
    		//scene에 추가된 움직일 그룹이 있을 경우 : 이동 or 생성
    		if(this.group) {
    			//좌표 설정
    			x = Math.round((points.x/segmentW)-1)*segmentW + segmentW;
    			y = 0;
    			z = Math.round((points.z/segmentW)-1)*segmentW + segmentW;
    			
    			//범위 설정
    			planeW = planeG.parameters.width;
    			planeH = planeG.parameters.height;
    			if(x < -(planeW * 0.45)) x = -(planeW*0.45);
    			if(x > planeW * 0.45) x = planeW*0.45;
    			if(z < -(planeH * 0.45)) z = -(planeW*0.45);
    			if(z > planeH * 0.45) z = planeW*0.45;
    			
    			this.group.position.set(x,y,z);
//    			console.log(this.group.position);
    		}
     	}
		return scene;
	}
	
	//MouseClick Event Handler
	, mouseClickFunction : function(e, scene){
		//contextmenu가 있으면 삭제하고 없으면 다음으로
    	this.deleteContextmenu();
		var group;
		console.log(arguments[2]);
		if(arguments[2]) group = null;
		else group = this.findGroup(scene);
		
		//scene에 들어있는 카메라 찾기
    	camera = scene.children.find(function(item){
    		return item instanceof THREE.Camera ? item : null;
    	});
    	
    	//선택되었을 때
    	console.log(this.isSelected);
    	if(this.isSelected){
    		//선택하기 위한 준비
    		var projector = new THREE.Projector();
    		var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
			projector.unprojectVector(vector, camera);
			var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
			//이동중이 아닐 때 : group 존재 : ismove = false
    		if(!this.ismove){
    			var intersects = raycaster.intersectObjects(this.targetGroup);
    			if(!intersects[0]){
    				console.log("바닥을 클릭했을 때 : 선택취소");
    				temp = group.children[1];
    				
    				//group엔 더 이상 볼 일 없으므로 지워주기
    				scene.remove(group);
    				scene.add(temp);

    				this.isSelected = false;
    			}
    			//선택 포커스 이동
    			else if(group != intersects[0].object)
    			{
    				//이전에 선택되어있는 객체의 그룹 해제
    				temp = group.children[1];
    				scene.add(temp);
    				console.log("선택포커스 이동하기");
    				scene.remove(group);
    				
    				//새롭게 선택한 객체 만들어주기
    				temp = intersects[0].object;
    				console.log(temp);
    				tposition = temp.position;
    				
    				selectGroup = new THREE.Group();
    				selectGroup.add(
    						this.makeSmallPlane(tposition.x, 0.01, tposition.z));
    				selectGroup.add(temp);
    				console.log(selectGroup);
    				scene.add(selectGroup);
    				console.log(scene);
    			}
    		}
    		//이동중일 때 : ismove = true
    		else{
    			console.log("이동작업");
    			var intersects = raycaster.intersectObjects(this.targetList);
    			//포인터와 겹친 객체들의 교차점이 0개 이상일 때
    			if(intersects.length > 0){
    				if(intersects[0].object.geometry instanceof THREE.PlaneGeometry)
    				{//포인터에 선택된것이 Plane 객체일 때 : 이동
//    					point = intersects[0].point;
						position = group.position;
//    					console.log(point);
						console.log(position);
    					temp = group.children[1].clone();
    					console.log(temp);
    					//만약 boxGeom일 경우 원래 높이의 1/2만큼 올려주고, 아닐경우 그냥하기
    					var y;
    					if(temp.geometry instanceof THREE.BoxGeometry){
    						y = temp.geometry.parameters.height/2;
    					}else {
//							y = point.y;
							y = position.y;
						}
//						temp.position.set(point.x, y, point.z);
    					temp.position.set(position.x, y, position.z);
						scene.add(temp);
    					scene.remove(group);
    					
    					this.targetList.push(temp);
    					this.targetGroup.push(temp);
    					
    					this.ismove = false;
    					this.isSelected = false;
    					this.saveScene(scene);
    				}else console.log('이미 다른 오브젝트가 선택한 위치에 존재합니다.');
    			}
    		}
    	}
    	//선택되지 않음
    	else{
    		//선택하기 위한 준비
    		var projector = new THREE.Projector();
    		var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
			projector.unprojectVector(vector, camera);
			var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
    		
    		//group이 있으니 복제를 합시다
			console.log("group");
			console.log(group);
    		if(group){
    			var intersects = raycaster.intersectObjects(this.targetList);
				//포인터에 잡힌 꼭짓섬이 0개 이상일 때
    			if(intersects.length > 0){
    				if(intersects[0].object.geometry instanceof THREE.PlaneGeometry){
    					//위치 잡기
    					position = group.position;
    					//복제시킬 오브젝트 복사하기
    					temp = group.children[1].clone();
    					
    					//놓으려고 하는 매쉬가 벽일 때
    					if(temp.geometry instanceof THREE.BoxGeometry) {
    						temp.name = "wall_" + this.cubenum;
    						wallHeight = temp.geometry.parameters.height;
    						temp.position.set(position.x, wallHeight/2, position.z);
    						this.cubenum++;
    					}
    					//놓으려고 하는 매쉬가 일반 오브젝트일 때
    					else {
    						temp.position.set(position.x, position.y, position.z);
    						temp.name = this.btnname + "_" + this.objnum;
    						this.objnum++;
    					}
    					
    					this.targetList.push(temp);
    					this.targetGroup.push(temp);
    					scene.add(temp);
    					this.saveScene(scene);
    				}else console.log("이미 같은 자리에 오브젝트가 존재합니다.");
				}
    			//복제작업 종료
    		}    		
    		//group이 존재하지 않으면 선택을 하고 isSelected = true;
    		else{
    			var intersects = raycaster.intersectObjects(this.targetGroup);
    			if(intersects.length > 0){
    				//가장 가까운 오브젝트 뽑아오기
    				console.log("오브젝트 선택하기");
    				console.log(scene);
        			temp = intersects[0].object;
        			scene.remove(temp);
        			console.log(temp);
        			console.log(scene);
        			position = temp.position;
        			this.savePoint = position;
        			
        			smallP = this.makeSmallPlane(position.x, 0.1, position.z);
        			selectgroup = new THREE.Group();
        			selectgroup.add(smallP);
        			selectgroup.add(temp);
        			
        			scene.add(selectgroup);
        			this.isSelected = true;
        			
        			console.log(scene);
    			}
    			//새 선택작업 끝
    		}
    	}
    	return scene;
	}
    	
	//MouseDown : 오른쪽 마우스 클릭할 때
	, downMouseButtonRight : function(e, scene){
		//오른쪽버튼 원래 contextmenu 비활성화
    	e.preventDefault();
    	//contextmenu가 있으면 삭제하고 없으면 다음으로
    	this.deleteContextmenu();
    	
		console.log("마우스 오른쪽 클릭");
		var projector = new THREE.Projector();
		var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
    	projector.unprojectVector(vector, camera);
    	var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
		var intersects = raycaster.intersectObjects(this.targetGroup);
		console.log(intersects);
		
		//선택되었을때만 메뉴가 나타나도록
		if(intersects.length > 0 && this.isSelected){
			var obj = intersects[0].object;
			console.log(intersects[0]);
			//팝업메뉴용 div
			var div = "<div class = 'contextM'>";
			div += "<label data-order = 'move'>이동</label>";
			div += "<br>";
			div += "<label data-order = 'delete'>삭제</label>";
			div += "</div>";
			$("#canvas").append(div);
			
			//div 스타일 설정, 이벤트 걸기
			$(".contextM").css({
				"position" : "absolute", "top" : e.clientY, "left" : e.clientX
				,"color" : "white", "background" : "rgba(0,0,0,0.5)",
				"width" : "50px", "z-index" : "10", "text-align" : "center"
			});
			7
			var group = this.findGroup(scene);
			var obj = group.children[1];
			$(".contextM label")
			.css({
				"width" : "100%"
			}) 
			.on("mousedown", function(e){
				e.stopPropagation();
				var order = $(this).data("order");
				if(order == "delete"){
					//삭제 명령을 내렸을 경우 선택되어있는 그룹을 지운다.
					console.log(obj);
					console.log(group);
					scene.remove(group);
		        	//오브젝트 지우기
					MapEdit01.deleteContextmenu();
					MapEdit01.findAndDelObj(obj, MapEdit01.targetList);
					MapEdit01.findAndDelObj(obj, MapEdit01.targetGroup);
					MapEdit01.isSelected = false;
				}else{
					console.log("이동버튼 누름");
					MapEdit01.moveObj(intersects, scene);
					MapEdit01.deleteContextmenu();
				}
			});
		}
    	return scene;
	}
	
	//그룹 움직이기
	,moveObj : function(intersects, scene){
		console.log(intersects);
		console.log(scene);
		var find = this.findObj(intersects);
		//포인터와 겹쳐있는 객체들이 0개 이상이고
		if(intersects.length > 0){
			//포인터와 가장 가까운 객체가 Plane이 아닐 때
			if(!(find.object.geometry instanceof THREE.PlaneGeometry)){
				//오브젝트 선택하기
				var obj;
				//만약 선택되어있다면
				if(this.isSelected){
					group = this.findGroup(scene);
					scene.remove(group);
					group.children[0].position.set(0,0.01,0);
					group.children[1].position.set(0,group.children[1].position.y,0);
					this.group = group;
					scene.remove(obj);
					obj = this.group.children[1];
					//중복클릭될 우려가 있으므로, targetList 애서는 잠시 빼준다.
					console.log(this.targetList.length);
					this.findAndDelObj(obj, this.targetList);
					this.findAndDelObj(obj, this.targetGroup);
					console.log(this.targetList.length);
					
					//클릭한곳이랑 가장 가까운 객체의 좌표를 받아옴
					this.savePoint = intersects[0].point;
					console.log(this.savePoint);
					scene.add(this.group);
					this.group.position.set(0, 0, 0);
					intersects = null;
					this.ismove = true;
				}
			}
		}
	}
	
	//오브젝트 배열에서 객체 찾아서 지우기
	, findAndDelObj : function(object, arr){
		console.log("findAndDelObj");
		console.log(arr);
    	var find = arr.find(function(item){
			return item.name == object.name;
		});
    	//찾은 Object가 Plane이 아닐 경우에만 지우는 작업하기
		if(!(find.geometry instanceof THREE.PlaneGeometry)){
        	var index = arr.indexOf(find);
			arr.splice(index, 1);
			console.log(arr);
		}else console.log("이건 플레인임");
	}
	
	//마우스 오른쪽 Context Menu 없애기
	, deleteContextmenu : function(){
		var contextmenu = $(".contextM");
    	if(contextmenu.length != 0) contextmenu.remove();
	}
	
	//배열 중 PlaneGeom이 아닌 Object 찾기
	, findObj : function(arr){
		var find = arr.find(function(item){
			var result;
			//plane말고 가장 가까운 Object를 반환
			if(arr.length > 1)
				result = !(item.object.geometry instanceof THREE.PlaneGeometry) ? item : null; 
			//다른게 없으면 그냥 가장 가까이 있는거 반환
			else result =  arr[0];	
			return result;
		});
		return find;
	}
	
	//그룹 만들 작은 판형 매쉬 생성
	, makeSmallPlane : function(){
		smallPlaneG = new THREE.PlaneGeometry(5, 5, 1, 1);
		smallPlaneM1 = new THREE.MeshBasicMaterial({color : 0x00ddee, wireframe: true, wireframeLinewidth: 2, transparent: true});
		smallPlaneM2 = new THREE.MeshLambertMaterial({color : 0x00ddee, transparent: true, opacity: 0.1})
		smallPlane = new THREE.SceneUtils.createMultiMaterialObject(smallPlaneG, [smallPlaneM1, smallPlaneM2]);
		smallPlane.rotation.x = -Math.PI / 2;
		
		if(arguments.length > 0){
			smallPlane.position.set(arguments[0], arguments[1], arguments[2]);
		}
		else smallPlane.position.set(0,0.01,0);
		
		return smallPlane;
	}
	
	//scene 안에 있는 group 찾아내기(움직이는 것)
	, findGroup : function(scene){
		group = scene.children.find(function(item){
			if(item instanceof THREE.Group) return item;
			else return null;
		});
		console.log("findGroup : " + group);
		return group;
	}
}