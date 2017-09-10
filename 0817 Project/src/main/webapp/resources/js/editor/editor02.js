/**
 * editor02.js
 * author LSH
 * 2017.9.5
 */

var MapEdit02 = {
	//선택 플래그
	isGroupSelected : false
	, isObjSelected : false
	//움직임에 대한 플래그
	, isGroupMove : false
	, isObjMove : false
	//설정할 캔버스의 가로, 세로
	, width : window.innerWidth * 0.7
	, height : window.innerHeight
	//마우스 포인터의 위치를 받아옴
	, mouse : {x : 0, y : 0}
	//선택된 그룹
	, selectedGroup : null
	//움직일 타겟 그룹
	, movingGroup : null
	//선택된 그룹 / 오브젝트의 부모그룹
	, parentGroup : null
	//intersects 의 타겟이 될 List : targetList 안에는 판까지 들어가고 Group 안에는 그룹들만 들어감
	, targetList : []
	//targetGroup 안에 들어가는 모든 그룹과 메쉬는 name 속성을 가지고 있어야 한다.
	, targetGroup : []
	//더하는 오브젝트에 붙일 고유번호
	, objnum : 0


	//scene.children 의 요소를 전부 그룹으로 바꾸기 : 다른 이름 줌	
	, setScene : function(scene){
		console.log("스캔 내부에 존재하는 모든 오브젝트를 그룹화 합니다.");
		//scene 안에 존재하는 모든 오브젝트 그룹화 : 바닥, 조명, 카메라 제외
		objectArr = [];
		children = scene.children;
		$.each(children, function(index, item){
			console.log(index);
			if(item instanceof THREE.Mesh){
				//매쉬가 Plane이 아닐때와 Plane일 때
				//targetList는 다 더해주고
				//targetGroup는 그룹만
				objG = new THREE.Group();
				objG.add(item.clone());
				objG.name = item.name;
				console.log(objG);
				objectArr.push(objG);
				MapEdit02.targetList.push(item);
				MapEdit02.targetGroup.push(objG);
			//나머지 광원, 카메라들도 scene.children 에 넣어야 하므로 더해주기
			}else objectArr.push(item);
		});
		console.log(objectArr);
		console.log(MapEdit02.targetList);
		console.log(MapEdit02.targetGroup);
		scene.children = objectArr;
		console.log(scene);
	}

	//오브젝트 더하기 실험용cube 만들기
	,addCube : function(scene){
		console.log("오브젝트 더하기 실험용 큐브만들기");
		scene.remove(this.movingGroup);
		this.movingGroup = null;
		cubeG = new THREE.BoxGeometry(2,2,2,1,1,1);
		cubeM = new THREE.MeshLambertMaterial({color : Math.random() * 0xffffff});
		cube = new THREE.Mesh(cubeG, cubeM);
		
		cubeHeight = cubeG.parameters.height;
		cube.position.set(0,cubeHeight/2,0);
		group = new THREE.Group();
		group.add(cube);
		group.name = "addObject";

		this.movingGroup = group;
		scene.add(this.movingGroup);

		return scene;
	}

    ,cancel : function(scene){
        console.log("cnacle : 2차 : 선택 및 이동, 더하기 취소");
        if(this.selectedGroup) {
			console.log("오브젝트 선택취소");
            group = findGroup(scene.children, this.selectedGroup.children[0]);
//			console.log(group);
			tempMesh = group.children.find(function(item){
				return item.name == 'temp';
			});
			group.children.pop(tempMesh);
//			console.log(group);
			for(var i in this.targetGroup.children){
				if(group.name == this.targetGroup.children[i].name){
					this.targetGroup.children[i] = group;
					break;
				}
			}
//			console.log(this.targetGroup);
			console.log("선택 취소플래그");
			this.isGroupSelected = false;
			this.isObjSelected = false;
			this.selectedGroup = null;
			
        } else if(this.movingGroup){
            if(!(this.isGroupMove || this.isObjMove)){
                console.log("오브젝트 추가 취소");
                group = findtargetGroup(scene.children, this.movingGroup.children[0]);
                scene.remove(group);
				console.log("추가시킬 그룹 삭제하기");
            }
        }
        else console.log("취소할 작업이 존재하지 않음");
        
        function findGroup (sceneGroupList, thisGroup){
            for(var i in sceneGroupList){
                console.log(sceneGroupList[i].name);
                console.log(thisGroup.name);
                console.log(sceneGroupList[i].name == thisGroup.name);
                if(sceneGroupList[i].name == thisGroup.name) return sceneGroupList[i];
                else console.log("일치하는 그룹을 찾을 수 없습니다.");
            }
        }
		console.log(scene);
		return scene;
    }
    
	//그룹 위에 올려진 Object 선택
	, selectObj : function(scene , intersects){
		console.log("오브젝트 선택하기");
		if(this.selectedGroup){
			console.log("선택된 그룹이 존재");
			if(this.isObjMove){
				console.log("현재 이동중인 오브젝트 위치설정하기");
			}else{
				console.log("선택이동하기");
				if(this.isObjSelected){
					console.log("오브젝트가 선택되어있을 때");
					//선택된 그룹에서 선택용 매쉬 빼기
					var pop = this.selectedGroup.children.pop();
					console.log(pop.name);
					//오브젝트를 scene.add
					scene.add(this.selectedGroup);
					
					//새 그룹을 만들어 오브젝트들 더해주기
					mesh = this.addMesh(intersects.object);
					objGroup = new THREE.Group();
					objGroup.adD(intersects.object);
					objGroup.adD(mesh);
				
					//selectGroup에 통합 선택 매쉬가 들어간 objectGroup를 넣어주기
					this.selectedGroup = objGroup;
					
					scene.add(this.selectedGroup);
				}else{
					console.log("그룹이 선택되어있을 때");
					this.isGroupSelected = false;
				}
			}
		}else{
			console.log("선택된 그룹이 존재하지 않음 : 오브젝트 새로 선택하기");
			//부모그룹에서 해줄 작업 : 부모 그룹에서 오브젝트 분리후 다시 스캔에 더해주기
			scene.remove(this.parentGroup);
			for(var i in this.parentGroup.children){
				if(this.parentGroup.children[i].name = intersects.object.name){
					index = this.parentGroup.children.indexOf(this.parentGroup.children[i]);
					this.parentGroup.children.splice(index, 1);
					console.log(this.parentGroup);
				}
			}
			scene.add(this.parentGroup);

			//선택에 사용할 임시 매쉬 만들기 : intersect에 잡힌 객체의 지오메트리 + 메테리얼 추가
			mesh = this.addMesh(intersects.object);
			//새 그룹을 만들어 오브젝트들 더해주기
			objGroup = new THREE.Group();
			objGroup.adD(intersects.object);
			objGroup.adD(mesh);

			this.isObjSelected = true;
			this.selectedGroup = objGroup;

			scene.add(this.selectedGroup);
		}
		return scene;
	}
	
	//그룹 위에 올려진 Object 이동
	, moveObj : function(){
		
	}
	
	//그룹 위에 올려진 Object 삭제
	, delObj : function(){
		
	}
	
	//그룹 위에 올려진 Object 회전
	, rotationObj : function(){
		
	}
	
	//그룹 전체 선택하기
	, selectGroup : function(scene, intersects, parentGroup){
		console.log(this.selectedGroup);
		if(this.selectedGroup){
			console.log("선택된 그룹 존재");
			if(this.isGroupMove){
				console.log("그룹 전체의 위치 지정하기");
			}else{
				//this.isGroupMove = false -> 선택 이동
				if(!(intersects.object.geometry instanceof THREE.PlaneGeometry)){
					console.log("선택 이동하기");
					if(this.isGroupSelected) {
						scene.remove(this.selectedGroup);
						console.log("group이 선택되어있을 때");
						//그룹이 선택되어있는 경우 : 통합 매쉬 빼기
						tempMesh = this.selectedGroup.children.find(function(item){
							return item.name == "temp";
						});
						
						console.log(this.selectedGroup.children.pop(tempMesh));
						
						//그룹을 scene.add
						console.log(this.selectedGroup);
						scene.add(this.selectedGroup);

						//통합 매쉬 추가하기
						mesh = this.addMesh(parentGroup);
						parentGroup.children.push(mesh);
						console.log(parentGroup);

						//selectGroup에 통합 선택 매쉬가 들어간 parentGroup를 넣어주기
						this.selectedGroup = parentGroup;

//						scene.add(this.selectedGroup);
					}else if(this.isObjSelected){
						console.log("object가 선택되어있을 때");
						this.isObjSelected = false;
						var pop = this.selectedGroup.children.pop();
						isObj = parentGroup.children.find(function(item){
							return item.name == this.selectedGroup.children[0];
						});
						console.log(isObj);
					}
				}
				
			}

		}else{
			if(!(intersects.object.geometry instanceof THREE.PlaneGeometry)){
				console.log("선택된 그룹 없음 : 전체 그룹 새로 선택하기");
				mesh = this.addMesh(parentGroup);
				parentGroup.children.push(mesh);
				console.log(parentGroup);

				this.isGroupSelected = true;
				this.selectedGroup = parentGroup;
			}
		}
		return scene;
	}
	
	//그룹 이동
	, moveGroup : function(){
		
	}
	
	//그룹 삭제
	, delGroup : function(){
		
	}
	
	//그룹 회전
	, rotationGroup : function(){
		
	}
	
	
	//마우스 클릭
	, clickGroupFunction : function(e, scene){
		console.log(scene);
		//마우스 포인터의 위치에 따라 Object 인식하기
    	var projector = new THREE.Projector();
    	var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
    	projector.unprojectVector(vector, camera);
    	var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
		var intersects = raycaster.intersectObjects(MapEdit02.targetList);
		if(intersects.length > 0){
			if(this.movingGroup){
				console.log("움직이는 그룹이 있을 때");
				if(this.isGroupMove || this.isObjMove){
					console.log("오브젝트 이동하기");
					
					
				}else{
					console.log("오브젝트를 올리려고 하는 곳이 그룹의 첫번째 인덱스에 들어있는 객체일 때 : in this.targetList");
					console.log("오브젝트 더하기");
					parentGroup = this.findtargetGroup(intersects[0].object);
					if(parentGroup){
						objname = "cube";
						obj = this.movingGroup.children[0].clone();
						obj.name = objname + "_" + this.objnum;
						position = this.movingGroup.position;
						position.y += this.movingGroup.children[0].geometry.parameters.height / 2;
						console.log(position);
						obj.position = position;
						parentGroup.add(obj);
						obj.position.set(position.x, position.y, position.z);
						console.log(obj);
						this.objnum++;
						this.targetList.push(obj);
					}else{
						console.log("오브젝트를 놓을 공간이 부족합니다.");
					}
				}
			}else{
				console.log("움직이는 그룹이 없을 때");
				for(var i in this.targetGroup){
					console.log(this.targetGroup);
					console.log(intersects[0].object.name);
					console.log(this.targetGroup[i].children[0].name);
					console.log(this.targetGroup[i].children[0].name == intersects[0].object.name);
					if(this.targetGroup[i].children[0].name == intersects[0].object.name){
						console.log(intersects[0]);
						console.log("그룹의 첫번째 오브젝트를 클릭했을 경우");
						//부모그룹을 저장
						this.parentGroup = this.targetGroup[i];
						//그룹 선택하기 : 통합 매쉬가 더해진 그룹을 반환
						scene = this.selectGroup(scene, intersects[0], this.parentGroup);
						return scene;
					} else{
						findMesh = this.targetGroup[i].children.find(function(item){
							return intersects[0].object.name == item.name;
						});
						console.log(findMesh);
						if(findMesh){
							console.log("그룹의 나머지 오브젝트를 선택했을 경우");
							//부모그룹을 저장
							this.parentGroup = this.targetGroup[i];
							//오브젝트 선택하기
							this.selectObj(scene, intersects[0], this.parentGroup); 
							return scene;
						}else{
							console.log("타겟 그룹이 아닌 것을 선택했을 경우 or plane를 아무것도 없이 선택했을 경우");
							
							
							
						}
					}
				}//for
			}
		}
		return scene;
	}
	
	//마우스 이동 : 그룹 이동
	, moveMousePointer : function(e, scene){
		//마우스 위치 받아오기
		MapEdit02.mouse.x = (e.clientX / MapEdit02.width)*2 - 1;
    	MapEdit02.mouse.y = -(e.clientY / MapEdit02.height)*2 + 1;
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
    	
		//움직일 단위가 될 Plane의 Segment찾기
		//움직일 수 있는 범위 설정의 바탕이 되는 PlaneGeom의 width, height 찾기
		plane = scene.children.find(function(item){
			return item.geometry instanceof THREE.PlaneGeometry ? item : null;
		});
		if(plane) {
			planeG = plane.geometry;
			segmentW = planeG.parameters.widthSegments / 4;
			console.log(segmentW);
			
			//범위 설정
			planeW = planeG.parameters.width;
			planeH = planeG.parameters.height;
		}
		
//		console.log(intersects);
		if(intersects.length > 0){
			points = intersects[0].point;
			if(MapEdit02.movingGroup){
				x = Math.round((points.x/segmentW)-1)*segmentW + segmentW;

				console.log(intersects[0].object.geometry instanceof THREE.PlaneGeometry);
				
				if(intersects[0].object.geometry instanceof THREE.PlaneGeometry) y = 0;
				else if(this.findtargetGroup(intersects[0].object)) y = intersects[0].object.geometry.parameters.height;
				else y = Math.round((points.y/segmentW)-1)*segmentW + segmentW;
				
				z = Math.round((points.z/segmentW)-1)*segmentW + segmentW;
				
    			if(x < -(planeW * 0.45)) x = -(planeW*0.45);
				if(x > planeW * 0.45) x = planeW*0.45;
    			if(z < -(planeH * 0.45)) z = -(planeW*0.45);
    			if(z > planeH * 0.45) z = planeW*0.45;
    			
				console.log(x + " : " + y + " : " + z);
    			MapEdit02.movingGroup.position.set(x, y, z);
			}
		}
		return scene;
	}
	
	//마우스 오른쪽 팝업메뉴 : 이동/삭제/복제 선택
	, createContextMenu : function(){
		
	}
	
	//contextmenu 삭제
	, deleteContextmenu : function(){
		var contextmenu = $(".contextM");
    	if(contextmenu.length != 0) contextmenu.remove();
	}

	, addMesh : function(obj){
		//선택에 사용할 임시 매쉬 만들기 : intersect에 잡힌 객체의 지오메트리 + 메테리얼 추가
		var geom;
		if(obj instanceof THREE.Group)	{
			geom = new THREE.Geometry();
			meshes = obj.children;
			for(var i in meshes) geom.merge(meshes[i].geometry, meshes[i].matrix);
		}else geom = obj.geometry;
		
		mat1 = new THREE.MeshLambertMaterial({
			color : 0x42f5ff, opacity : 0.3, transparent : true});
		mat2 = new THREE.MeshBasicMaterial({color : 0x42f5ff, wireframe : true, opacity : 0.5, transparent : true});
		
		var mesh = new THREE.SceneUtils.createMultiMaterialObject(geom, [mat1, mat2]);
		scale = 1.006;
		mesh.scale.set(scale, scale, scale);
		//이 Mesh의 Position은 상대적
		mesh.position.set(0,0,0);
		mesh.name = "temp"
		return mesh;
	}
    
	//타겟 그룹 리스트에서 타겟리스트와 같은 이름의 그룹 찾기
	, findtargetGroup : function(object){
		return this.targetGroup.find(function(item){
			return item.name == object.name;
		});
	}
}