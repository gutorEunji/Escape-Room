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
				objG = new THREE.Group();
				objG.add(item.clone());
				objG.name = item.name;
				//아이템의 위치를 저장할 itemPosition 세팅
				objG.itemPosition = item.position;
//				console.log(objG);
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
//            group = findGroup(scene.children, this.selectedGroup.children[0]);
			var group;
			for(var i in scene.children){
                if(scene.children[i].name == this.selectedGroup.children[0].name) group = scene.children[i];
                else console.log("일치하는 그룹을 찾을 수 없습니다.");
            }
			if(group){
				tempMesh = group.children.find(function(item){
					return item.name == 'temp';
				});
				group.children.pop(tempMesh);
				if(this.isGroupSelected){
					//그룹을 재설정 해줄 때
					console.log("그룹을 재설정해주기");
					for(var i in this.targetGroup.children){
						if(group.name == this.targetGroup.children[i].name){
							this.targetGroup.children[i] = group;
							break;
						}
					}
				}else if(this.isObjSelected){
					//오브젝트를 재설정 할 때
					console.log("오브젝트를 재설정");
					scene.remove(group);
					this.parentGroup.add(group.children[0]);
					console.log(this.parentGroup);
					
				}
				console.log("선택 취소플래그");
				this.isGroupSelected = false;
				this.isObjSelected = false;
				this.selectedGroup = null;
				
			}
			
        } else if(this.movingGroup){
            if(!(this.isGroupMove || this.isObjMove)){
                console.log("오브젝트 추가 취소");
                console.log(this.movingGroup.children[0]);
				group = findGroup(scene.children, this.movingGroup);
                scene.remove(group);
				this.movingGroup = null;
				
            }else{
				console.log("오브젝트 이동 취소");
				group = findGroup(scene.children, this.movingGroup);
                scene.remove(group);

				console.log("--미리 저장해둔 이동 전 위치로 그룹 이동시키기 작업 추가해야함--");
				
				console.log("movingGroup 삭제 및 플래그 초기화");
				this.movingGroup = null;
				this.isGroupMove = false;
				this.isObjMove = false;
				
			}
        }
        else console.log("취소할 작업이 존재하지 않음");
        
        function findGroup (sceneGroupList, thisGroup){
            for(var i in sceneGroupList){
				console.log(sceneGroupList[i].name);
				console.log(thisGroup.name);
				
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
					scene.remove(this.selectedGroup);
					
					//선택되어있는 그룹에서 통합 매쉬 빼기
					pop = this.selectedGroup.children.pop(function(){
						return this.selectedGroup.children.find(function(item){
							return item.name == "temp";
						});
					});
					if(pop.parentGroupName){
						console.log("부모그룹이 존재할경우 : " + pop.parentGroupName);
						//부모 그룹 안에 매쉬 다시 넣어주기
						parent = scene.children.find(function(item){
							return item.name == pop.parentGroupName;
						});
						parent.add(this.selectedGroup.children[0]);
						console.log(parent);
					}
					//새로 선택한 오브젝트를 그룹으로 만들어주기
					console.log(parentGroup);
					mesh = this.addMesh(intersects.object, intersects.object.position);
					objGroup = new THREE.Group();
					objGroup.add(intersects.object);
					objGroup.add(mesh);
					this.selectedGroup = objGroup;
					//scene 에 더하기
					scene.add(this.selectedGroup);
				}else{
					console.log("그룹이 선택되어있을 때");
					scene.remove(this.selectedGroup);
					//선택용으로 만들어둔 임시 통합 매쉬를 제거한다
					pop = this.selectedGroup.children.pop(function(){
						return this.selectedGroup.children.find(function(item){
							return item.name == "temp";
						});
					});
//					console.log(pop);
					//선택이 해제된 오브젝트 그룹을 돌려준다 : 플래그 내리기
					scene.add(this.selectedGroup);
					this.isGroupSelected = false;
					
					//새로 선택된 오브젝트 그룹으로 만들어주기
					console.log("새로 선택한 오브젝트 그룹으로 만들기");
					console.log(parentGroup);
					mesh = this.addMesh(intersects.object, intersects.object.position);
					objGroup = new THREE.Group();
					objGroup.add(intersects.object);
					objGroup.add(mesh);
					this.selectedGroup = objGroup;
					scene.add(this.selectedGroup);
					this.isObjSelected = true;
					console.log(scene);
				}
			}
		}else{
			console.log("선택된 그룹이 존재하지 않음 : 오브젝트 새로 선택하기");
			
			//부모그룹에서 해줄 작업 : 부모 그룹에서 오브젝트 분리후 다시 스캔에 더해주기
			//그룹에서 뺄 객체를 찾아온다
			pop = this.parentGroup.children.find(function(item){
				return item.name == intersects.object.name;
			});
			temp = this.parentGroup.children.pop(pop);
			console.log(this.parentGroup);
			mesh = this.addMesh(temp, temp.position);
			tempGroup = new THREE.Group();
			tempGroup.add(temp);
			tempGroup.add(mesh);
			tempGroup.name = temp.name;
			
			console.log(tempGroup);
			scene.add(tempGroup);
			
			this.selectedGroup = tempGroup;
			this.isObjSelected = true;
			
			console.log(scene);
		}
		return scene;
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
						
						//이전 그룹을 scene.add
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
						console.log("object가 선택되어있을 때 : parentGroup에 지금 선택되어있는 오브젝트를 더해주고 선택취소 -> 그룹선택");
						scene.remove(this.selectedGroup);
						childMesh = this.selectedGroup.children[0];
						
						//통합된 매쉬
						tempMesh = this.selectedGroup.children.pop()
						if(tempMesh.parentGroupName){
							//이 객체가 어딘가에 속해있는 자식객체인 경우, 부모 객체의 이름을 받아온다.
							parentName = tempMesh.parentGroupName;
							
							pGroup = scene.children.find(function(item){
								return item.name == parentName;
							});
							pGroup.add(childMesh);
							console.log(pGroup);
						}
						
						//새로 선택해서 더해주기
						console.log(intersects);
						console.log(parentGroup);
						
						mesh = this.addMesh(parentGroup);
						parentGroup.add(mesh);
						
						this.selectedGroup = parentGroup;
					}
						this.isObjSelected = false;
						this.isGroupSelected = true;
				}
				
			}

		}else{
			if(!(intersects.object.geometry instanceof THREE.PlaneGeometry)){
				console.log("선택된 그룹 없음 : 전체 그룹 새로 선택하기");
				mesh = this.addMesh(parentGroup, parentGroup.position);
				parentGroup.children.push(mesh);
				console.log(parentGroup);

				this.isGroupSelected = true;
				this.selectedGroup = parentGroup;
			}
		}
		return scene;
	}
	
	//그룹 이동
	, moveGroup : function(scene){
		//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
		tempMesh = MapEdit02.selectedGroup.children.find(function(item){
			return item.name == "temp";
		});
		if(tempMesh.parentGroupName){
			console.log("오브젝트일 때");
			scene.remove(MapEdit02.selectedGroup);
			parentName = tempMesh.parentGroupName;
			//선택되어있는 오브젝트 객체를 움직일 그룹 안으로 넣어줌
			MapEdit02.movingGroup = MapEdit02.selectedGroup.clone();
			console.log(MapEdit02.movingGroup.children);
			//움직임 플래그 설정
			MapEdit02.isObjMove = true;

			//움직여야하니까 해당 객체를 타겟에서 제외시킨다
			pop = MapEdit02.targetList.pop(function(){
				return MapEdit02.targetList.find(function(item){
					return item.name == MapEdit02.movingGroup.name;
				});
			});
			console.log(pop);
			//scene 안에 더해줌
			scene.add(MapEdit02.movingGroup);
			MapEdit02.deleteContextmenu();							
		}
		else{
			console.log("그룹일 때");
			scene.remove(MapEdit02.selectedGroup);
			MapEdit02.movingGroup = MapEdit02.selectedGroup.clone();
			MapEdit02.isGroupMove = true;
			//움직여야하니까 해당 객체를 타겟에서 제외시킨다
			for(var i in MapEdit02.movingGroup.children){
				pop = MapEdit02.targetList.pop(MapEdit02.movingGroup.children[i]);
				console.log(pop);
			}

			scene.add(MapEdit02.movingGroup);
			MapEdit02.deleteContextmenu();
		}
		return scene;
	}
	
	//선택그룹 삭제하기
	, delSelectedGroup : function(scene){
		//삭제 명령을 내렸을 경우 선택되어있는 그룹을 지운다.
		scene.remove(MapEdit02.selectedGroup);
		console.log(MapEdit02.targetList.pop(this.selectedGroup));

		//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
		tempMesh = MapEdit02.selectedGroup.children.find(function(item){
			return item.name == "temp";
		});
		if(tempMesh.parentGroupName){
			//부모 그룹의 정보가 존재할 경우 : 오브젝트
			console.log("오브젝트일 때");
			groupname = tempMesh.parentGroupName;
			parent = MapEdit02.targetGroup.find(function(item){
				return item.name = groupname;
			});
			parent.remove(MapEdit02.selectedGroup.children[0]);
			
			console.log(parent);
			
			targetListParent = MapEdit02.targetList.find(function(item){
				return item.name == groupname;
			});
			targetListParent.remove(MapEdit02.selectedGroup.children[0]);
			
		}else{
			//부모 그룹의 정보가 존재하지 않을 경우 : 그룹
			console.log("그룹일 때");
			MapEdit02.targetGroup.pop(function(){
				return MapEdit02.targetGroup.find(function(item){
					return item.name == this.selectedGroup.name;
				});
			});
			
			MapEdit02.targetList.pop(function(){
				return MapEdit02.targetList.find(function(item){
					return item.name == this.selectedGroup.name;
				});
			});
		}
		MapEdit02.selectedGroup = null;
		MapEdit02.isObjSelected = false;
		MapEdit02.isObjMove = false;
		MapEdit02.isGroupSelected =false;
		MapEdit02.isGroupMove = false;
		MapEdit02.deleteContextmenu();
		
		return scene;
	}
	
	//마우스 클릭
	, clickGroupFunction : function(e, scene){
		console.log(scene);
		
		//혹시 메뉴가 아직 떠 있으면 메뉴 삭제해주기
		this.deleteContextmenu();
		
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
					if(intersects[0].object.geometry instanceof THREE.PlaneGeometry){
						
						//intersect[0].object.geom이 plane인 경우
						console.log("PlaneGeom일 때");
						position = this.movingGroup.position;
						//현재 움직이던 그룹 장면에서 빼주기
						scene.remove(this.movingGroup);
						//현재 움직이고 있는 this.movingGroup이 오브젝트를 가져온건지 그룹을 가져온건지 구분하기
						tempMesh = this.movingGroup.children.find(function(item){
							return item.name == "temp";
						});
						//찾아온 선택 매쉬를 현재 움직이는 그룹에서 빼준다
						this.movingGroup.remove(tempMesh);
						if(tempMesh.parentGroupName){
							//plane의 부모 그룹 찾기
							parent = scene.children.find(function(item){
								return itme.name == intersects[0].object.name;
							});
							//선택한 그룹의 선택 매쉬안에 부모 그룹의 이름이 존재하면 오브잭트를 가져온것
							console.log("object일 때");
							//movingGroup안에 있는 오브젝트 복제 후 퐂지션 설정
							obj = this.movingGroup.children[0].clone();
							obj.position.set(position.x, position.y, position.z);
							//설정한 Obj넣어주기
							parent.add(obj);
							
							this.movingGroup = null;
							this.isObjMove = false;
							this.isObjSelected = false;
							this.taegetList.push(obj);
							
						}else{
							//없을 경우 그룹을 가져온 것
							console.log("Group일 때");
							scene.add(this.movingGroup.clone());
							
							this.movingGroup = null;
							this.isGroupSelected = false;
							this.isGroupMove = false;
							console.log(this.movingGroup)
							for(var i in MapEdit02.movingGroup.children){
								pop = MapEdit02.targetList.push(MapEdit02.movingGroup.children[i]);
								console.log(pop);
							}
						}
					}else{
						//intersect[0].object.geom이 Object3d나 Mesh 인 경우]
						parent = scene.children.find(function(item){
							return itme.name == intersects[0].object.name;
						});
						
						console.log(parent);
							
						console.log(parent.children[0].name);
						console.log(intersects[0].object.name);
						
						if(parent && intersects[0].object.name == parent.children[0].name){
							//포인터에 가장 가까운 위치의 오브젝트가 그룹 안의 첫번째 인덱스에 위치할 때
							//현재 움직이고 있는 this.movingGroup이 오브젝트를 가져온건지 그룹을 가져온건지 구분하기
							tempMesh = this.movingGroup.children.find(function(item){
								return item.name == "temp";
							});
							
							if(tempMesh.parentGroupName){
								//선택한 그룹의 선택 매쉬안에 부모 그룹의 이름이 존재하면 오브잭트를 가져온것
								console.log("object일 때");
							}else{
								//없을 경우 그룹을 가져온 것
								console.log("Group일 때");
							}
							
						}
					}
					
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
						
						console.log("scene");
						console.log(scene);
						
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
						if(!(intersects[0].object.geometry instanceof THREE.PlaneGeometry)){
							console.log(intersects[0]);
							console.log("그룹의 첫번째 오브젝트를 클릭했을 경우");
							//부모그룹을 저장
							this.parentGroup = this.targetGroup[i];
							//그룹 선택하기 : 통합 매쉬가 더해진 그룹을 반환
							scene = this.selectGroup(scene, intersects[0], this.parentGroup);
							return scene;
						}						
					}
					else{
						console.log(this.targetGroup);
						
						findMesh = this.targetGroup[i].children.find(function(item){
							return intersects[0].object.name == item.name;
						});
						console.log(intersects[0].object);
						console.log(findMesh);
//						console.log(findMesh.parent);
						console.log(this.targetGroup);
						if(!(intersects[0].object.geometry instanceof THREE.PlaneGeometry)){
							if(findMesh){
								console.log("그룹의 나머지 오브젝트를 선택했을 경우");
	//							//부모그룹을 저장
								this.parentGroup = findMesh.parent;
								console.log(this.parentGroup);
	//							//오브젝트 선택하기
								this.selectObj(scene, intersects[0]); 
								return scene;
							}
						}
						else{
							console.log("선택한 곳이 PlaneMesh일 경우");
							return this.cancel(scene);
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
		
		console.log(this.targetList);
		console.log(intersects);
		if(intersects.length > 0){
			points = intersects[0].point;
			if(MapEdit02.movingGroup){
				x = Math.round((points.x/segmentW)-1)*segmentW + segmentW;

				if(intersects[0].object.geometry instanceof THREE.PlaneGeometry) y = 0;
				else if(this.findtargetGroup(intersects[0].object)) {
					console.log(this.findtargetGroup(intersects[0].object));
					y = intersects[0].object.geometry.parameters.height;
				}else y = Math.round((points.y/segmentW)-1)*segmentW + segmentW;
				
				z = Math.round((points.z/segmentW)-1)*segmentW + segmentW;
				
    			if(x < -(planeW * 0.45)) x = -(planeW*0.45);
				if(x > planeW * 0.45) x = planeW*0.45;
    			if(z < -(planeH * 0.45)) z = -(planeW*0.45);
    			if(z > planeH * 0.45) z = planeW*0.45;
    			
				console.log(x + " : " + y + " : " + z);
    			MapEdit02.movingGroup.position.set(x, y, z);
				
				for(var i in MapEdit02.movingGroup.children){
					console.log(MapEdit02.movingGroup.children[i].position);
				}
			}
		}
		return scene;
	}
	
	//마우스 오른쪽 클릭 이벤트 핸들러
	, mouseRightClick : function(e, scene){
		console.log("마우스 오른쪽 클릭");

		//contextmenu가 있으면 삭제하고 없으면 다음으로
		this.deleteContextmenu();

		console.log("마우스 오른쪽 클릭");
		var projector = new THREE.Projector();
		var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
		projector.unprojectVector(vector, camera);
		var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
		var intersects = raycaster.intersectObjects(this.targetList);
		console.log(intersects);

		//선택되었을때만 메뉴가 나타나도록
		if(intersects.length > 0 &&(this.isGroupSelected || this.isObjSelected)){
			console.log(intersects[0].object.name + "==" + this.selectedGroup.children[0].name);
			if(intersects[0].object.name == this.selectedGroup.children[0].name){
				console.log("intersect의 길이가 0 이상이고 isGroupSelected = " + this.isGroupSelected
							+ " isObjSelected = " + this.isObjSelected + "일 때");

				//팝업메뉴용 div
				var div = "<div class = 'contextM'>";
				div += "<label data-order = 'move'>이동</label>";
				div += "<br>";
				div += "<label data-order = 'delete'>삭제</label>";
				div += "<br>";
				div += "<label data-order = 'rotationL'>왼쪽으로 45도 회전</label>";
				div += "<br>";
				div += "<label data-order = 'rotationR'>오른쪽으로 45도 회전</label>";
				div += "</div>";

				$("#canvas").append(div);

				//div 스타일 설정, 이벤트 걸기
				$(".contextM").css({
					"position" : "absolute", "top" : e.clientY, "left" : e.clientX
					,"color" : "white", "background" : "rgba(0,0,0,0.5)", "padding" : "5px", 
					"z-index" : "10", "text-align" : "center"
				})
				.on("click", function(e){
					e.stopPropagation();
				});
				$(".contextM label")
				.css({
					"width" : "100px"
				}) 
				.on("mousedown", function(e){
					e.stopPropagation();
					var order = $(this).data("order");
					if(order == "delete"){
						console.log("삭제버튼 누름");
						scene = MapEdit02.delSelectedGroup(scene);
						
					}else if (order == "move"){
						console.log("이동버튼 누름");
						//마우스 포인터 위치가 어긋나는 오류를 잡아야함
						scene = MapEdit02.moveGroup(scene);
						
					}else if(order == "rotationL" || order == "rotationR"){
						console.log("selectGroup 회전");
						
						//각도 정하기
						var rotation;
						if(order == "rotationR") rotation = Math.PI / 4;
						else rotation = -(Math.PI / 4);
						console.log("회전 각도 : " + rotation);
						
						//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
						tempMesh = MapEdit02.selectedGroup.children.find(function(item){
							return item.name == "temp";
						});
						if(tempMesh.parentGroupName){
							console.log("오브젝트일 때");
							for(var i in MapEdit02.selectedGroup.children){
								MapEdit02.selectedGroup.children[i].rotation.y += rotation;
							}
						}
						else{
							console.log("그룹일 때");
							
							
							
//							//선택용으로 만든 temp 매쉬 제거
//							pop =  MapEdit02.selectedGroup.children.find(function(item){
//								return item.name == "temp";
//							});
//							
//							MapEdit02.selectedGroup.remove(pop);
//							console.log(pop);
//							console.log(MapEdit02.selectedGroup);
//							
//							//나머지 오브젝트의 회전
//							for(var i in MapEdit02.selectedGroup.children){
//								MapEdit02.selectedGroup.children[i].rotation.y += rotation;
//							}
//							mesh = MapEdit02.addMesh(MapEdit02.selectedGroup);
//							MapEdit02.selectedGroup.add(mesh);
//							
//							console.log(MapEdit02.selectedGroup);
						}
						
						MapEdit02.deleteContextmenu();
					}
				});
			}

		}
		return scene;
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
		mat2 = new THREE.MeshBasicMaterial({color : 0x42f5ff, wireframe : true});
		
		var mesh = new THREE.SceneUtils.createMultiMaterialObject(geom, [mat1, mat2]);
		scale = 1.006;
		mesh.scale.set(scale, scale, scale);
		//이 Mesh의 Position은 상대적
		
		mesh.rotation.y = obj.rotation.y;
		
		console.log(arguments[1]);
		if(arguments[1]) mesh.position.set(arguments[1].x, arguments[1].y, arguments[1].z);
		else mesh.position.set(0,0,0);
		mesh.name = "temp"
		//부모 객제가 있을 경우 부모 객체의 이름 정보를 넣어줌
		if(obj.parent) mesh.parentGroupName = obj.parent.name;
		console.log(mesh.position);
		return mesh;
	}
    
	//타겟 그룹 리스트에서 타겟리스트와 같은 이름의 그룹 찾기
	, findtargetGroup : function(object){
		return this.targetGroup.find(function(item){
			return item.name == object.name;
		});
	}
}