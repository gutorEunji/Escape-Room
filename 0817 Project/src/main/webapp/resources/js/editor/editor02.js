/**
 * editor02.js
 * author LSH
 * 2017.9.5
 */

var MapEdit02 = {
	//선택 플래그
	isGroupSelected: false,
	isObjSelected: false
		//움직임에 대한 플래그
		,
	isGroupMove: false,
	isObjMove: false
		//설정할 캔버스의 가로, 세로
		,
	width: window.innerWidth * 0.7,
	height: window.innerHeight
		//마우스 포인터의 위치를 받아옴
		,
	mouse: {
		x: 0,
		y: 0
	}
	//선택된 그룹
	,
	selectedGroup: null
		//움직일 타겟 그룹
		,
	movingGroup: null
		//선택된 그룹 / 오브젝트의 부모그룹
		,
	parentGroup: null
		//intersects 의 타겟이 될 List : targetList 안에는 판까지 들어가고 Group 안에는 그룹들만 들어감
		,
	targetList: []
		//targetGroup 안에 들어가는 모든 그룹과 메쉬는 name 속성을 가지고 있어야 한다.
		,
	targetGroup: []
		//더하는 오브젝트에 붙일 고유번호
		,
	objnum: 0


		//scene.children 의 요소를 전부 그룹으로 바꾸기 : 다른 이름 줌	
		,
	setScene: function (scene) {
			console.log("스캔 내부에 존재하는 모든 오브젝트를 그룹화 합니다.");
			//scene 안에 존재하는 모든 오브젝트 그룹화 : 바닥, 조명, 카메라 제외
			objectArr = [];
			children = scene.children;
			$.each(children, function (index, item) {
				console.log(index);
				if (item instanceof THREE.Mesh) {
					//매쉬가 Plane이 아닐때와 Plane일 때
					objG = new THREE.Group();
					objG.add(item.clone());
					objG.name = item.name;
					objectArr.push(objG);
					MapEdit02.targetList.push(item);
					MapEdit02.targetGroup.push(objG);
					//나머지 광원, 카메라들도 scene.children 에 넣어야 하므로 더해주기
				} else objectArr.push(item);
			});
			console.log(objectArr);
			console.log(MapEdit02.targetList);
			console.log(MapEdit02.targetGroup);
			scene.children = objectArr;
			console.log(scene);
		}

		//오브젝트 더하기 실험용cube 만들기
		,
	addCube: function (scene) {
			console.log("오브젝트 더하기 실험용 큐브만들기");
			scene.remove(this.movingGroup);
			this.movingGroup = null;
			cubeG = new THREE.BoxGeometry(2, 2, 2, 1, 1, 1);
			cubeM = new THREE.MeshLambertMaterial({
				color: Math.random() * 0xffffff
			});
			cube = new THREE.Mesh(cubeG, cubeM);

			cubeHeight = cubeG.parameters.height;
			cube.position.set(0, cubeHeight / 2, 0);
			group = new THREE.Group();
			group.add(cube);
			group.name = "addObject";

			this.movingGroup = group;
			scene.add(this.movingGroup);

			return scene;
		}

		,
	cancel: function (scene) {
			console.log("cnacle : 2차 : 선택 및 이동, 더하기 취소");
			if (this.selectedGroup) {
				console.log("오브젝트 선택취소");
				//            group = findGroup(scene.children, this.selectedGroup.children[0]);
				var group;
				for (var i in scene.children) {
					if (scene.children[i].name == this.selectedGroup.children[0].name) group = scene.children[i];
					else console.log("일치하는 그룹을 찾을 수 없습니다.");
				}
				if (group) {
					//선택을 해제한다
					tempMesh =this.findTempMesh(group.children);
					group.remove(tempMesh);
					
					if (this.isGroupSelected) {
						//그룹을 재설정 해줄 때
						console.log("그룹을 재설정해주기");
						for (var i in this.targetGroup.children) {
							if (group.name == this.targetGroup.children[i].name) {
								this.targetGroup.children[i] = group;
								break;
							}
						}
					} else if (this.isObjSelected) {
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

			} else if (this.movingGroup) {
				if (!(this.isGroupMove || this.isObjMove)) {
					console.log("오브젝트 추가 취소");
					console.log(this.movingGroup.children[0]);
					group = findGroup(scene.children, this.movingGroup);
					scene.remove(group);
					this.movingGroup = null;

				} else {
					console.log("오브젝트 이동 취소");
					group = findGroup(scene.children, this.movingGroup);
					scene.remove(group);

					console.log("--미리 저장해둔 이동 전 위치로 그룹 이동시키기 작업 추가해야함--");

					console.log("movingGroup 삭제 및 플래그 초기화");
					this.movingGroup = null;
					this.isGroupMove = false;
					this.isObjMove = false;

				}
			} else console.log("취소할 작업이 존재하지 않음");

			function findGroup(sceneGroupList, thisGroup) {
				for (var i in sceneGroupList) {
					console.log(sceneGroupList[i].name);
					console.log(thisGroup.name);

					if (sceneGroupList[i].name == thisGroup.name) return sceneGroupList[i];
					else console.log("일치하는 그룹을 찾을 수 없습니다.");
				}
			}
			console.log(scene);
			console.log(this.targetGroup);
			return scene;
		}

		//그룹 위에 올려진 Object 선택
		,
	selectObj: function (scene, intersects) {
			console.log("오브젝트 선택하기");
			if (this.selectedGroup) {
				console.log("선택된 그룹이 존재");
				if (this.isObjMove) {
					console.log("현재 이동중인 오브젝트 위치설정하기");
				} else {
					console.log("선택이동하기");
					if (this.isObjSelected) {
						console.log("오브젝트가 선택되어있을 때");
						scene.remove(this.selectedGroup);

						//선택되어있는 그룹에서 통합 매쉬 빼기
						tempMesh = this.findTempMesh(this.selectedGroup.children);
						this.selectedGroup.remove(tempMesh);

						if (tempMesh.parentGroupName) {
							console.log("부모그룹이 존재할경우 : " + tempMesh.parentGroupName);
							//부모 그룹 안에 매쉬 다시 넣어주기
							parent = scene.children.find(function (item) {
								return item.name == tempMesh.parentGroupName;
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
					} else {
						console.log("그룹이 선택되어있을 때");
						scene.remove(this.selectedGroup);
						//선택용으로 만들어둔 임시 통합 매쉬를 제거한다
						tempMesh = this.findTempMesh(this.selectedGroup.children);
						this.selectedGroup.remove(tempMesh);
						
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
			} else {
				console.log("선택된 그룹이 존재하지 않음 : 오브젝트 새로 선택하기");

				//부모그룹에서 해줄 작업 : 부모 그룹에서 오브젝트 분리후 다시 스캔에 더해주기
				//그룹에서 뺄 객체를 찾아온다
				find = this.parentGroup.children.find(function (item) {
					return item.name == intersects.object.name;
				});
				index = this.parentGroup.children.indexOf(find);
				this.parentGroup.children.splice(index, 1);
				console.log(this.parentGroup);
				
				
				mesh = this.addMesh(find);
				tempGroup = new THREE.Group();
				tempGroup.add(find);
				tempGroup.add(mesh);
				tempGroup.name = find.name;
//				console.log(tempGroup);
				scene.add(tempGroup);

				this.selectedGroup = tempGroup;
				this.isObjSelected = true;

				console.log(scene);
			}
			return scene;
		}

		//그룹 전체 선택하기
		,
	selectGroup: function (scene, intersects, parentGroup) {
			console.log(this.selectedGroup);
			if (this.selectedGroup) {
				console.log("선택된 그룹 존재");
				if (this.isGroupMove) {
					console.log("그룹 전체의 위치 지정하기");
				} else {
					//this.isGroupMove = false -> 선택 이동
					if (!(intersects.object.geometry instanceof THREE.PlaneGeometry)) {
						console.log("선택 이동하기");
						if (this.isGroupSelected) {
							scene.remove(this.selectedGroup);
							console.log("group이 선택되어있을 때");
							//그룹이 선택되어있는 경우 : 통합 매쉬 빼기
							tempMesh = this.findTempMesh(this.selectedGroup.children);
							this.selectedGroup.remove(tempMesh);

							//이전 그룹을 scene.add
							console.log(this.selectedGroup);
							scene.add(this.selectedGroup);

							//통합 매쉬 추가하기
							mesh = this.addMesh(parentGroup);
							parentGroup.children.push(mesh);
							console.log(parentGroup);

							//selectGroup에 통합 선택 매쉬가 들어간 parentGroup를 넣어주기
							this.selectedGroup = parentGroup;

							//scene.add(this.selectedGroup);
						} else if (this.isObjSelected) {
							console.log("object가 선택되어있을 때 : parentGroup에 지금 선택되어있는 오브젝트를 더해주고 선택취소 -> 그룹선택");
							scene.remove(this.selectedGroup);
							childMesh = this.selectedGroup.children[0];

							//통합된 매쉬
							tempMesh = this.findTempMesh(this.selectedGroup.children);
							if (tempMesh.parentGroupName) {
								//이 객체가 어딘가에 속해있는 자식객체인 경우, 부모 객체의 이름을 받아온다.
								parentName = tempMesh.parentGroupName;

								pGroup = scene.children.find(function (item) {
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

			} else {
				if (!(intersects.object.geometry instanceof THREE.PlaneGeometry)) {
					scene.remove(parentGroup);
					console.log("선택된 그룹 없음 : 전체 그룹 새로 선택하기");
					mesh = this.addMesh(parentGroup, parentGroup.position);
					parentGroup.add(mesh);
					console.log(parentGroup);
					scene.add(parentGroup);
					this.isGroupSelected = true;
					this.selectedGroup = parentGroup;
				}
			}
			return scene;
		}

		//그룹 이동
		,
	moveGroup: function (scene) {
			//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
			tempMesh = MapEdit02.selectedGroup.children.find(function (item) {
				return item.name == "temp";
			});
			if (tempMesh.parentGroupName) {
				console.log("오브젝트일 때");
				scene.remove(MapEdit02.selectedGroup);
				parentName = tempMesh.parentGroupName;
				//선택되어있는 오브젝트 객체를 움직일 그룹 안으로 넣어줌
				MapEdit02.movingGroup = MapEdit02.selectedGroup;
				
				//넣어줄 오브젝트의 포지션을 0,0,0 으로 해준다
				for(var i in this.movingGroup.children){
					this.movingGroup.children[i].position.set(0,0,0);
				}
				console.log(MapEdit02.movingGroup);
				//움직임 플래그 설정
				MapEdit02.isObjMove = true;

				//움직여야하니까 해당 객체를 타겟에서 제외시킨다
				find = MapEdit02.targetList.find(function (item) {
					return item.name == MapEdit02.movingGroup.name;
				});
				index = MapEdit02.targetList.indexOf(find);
				MapEdit02.targetList.splice(index, 1);
				console.log(this.targetList);
				
				console.log(MapEdit02.movingGroup.position.clone());
				
				//scene 안에 더해줌
				scene.add(MapEdit02.movingGroup);
				MapEdit02.deleteContextmenu();
			} else {
				console.log("그룹일 때");
				scene.remove(MapEdit02.selectedGroup);
				MapEdit02.movingGroup = MapEdit02.selectedGroup;
				MapEdit02.isGroupMove = true;
				for (var i in this.movingGroup.children) {
				//움직여야하니까 해당 객체를 타겟에서 제외시킨다
					find = this.targetList.find(function (item) {
						return item.name == MapEdit02.movingGroup.children[i].name;
					});
					if (find) {
						var index = this.targetList.indexOf(find);
						console.log(index);
						this.targetList.splice(index, 1);
						console.log(this.targetList);
					}
				}
				objFirstPosition = this.movingGroup.children[0].position.clone();
				for(var i in this.movingGroup.children){
					this.movingGroup.children[i].position.x -= objFirstPosition.x;
					this.movingGroup.children[i].position.z -= objFirstPosition.z;
				}
				
				scene.add(MapEdit02.movingGroup);
				MapEdit02.deleteContextmenu();
			}
			return scene;
		}

		//선택그룹 삭제하기
		,
	delSelectedGroup: function (scene) {
			//삭제 명령을 내렸을 경우 선택되어있는 그룹을 지운다.
			scene.remove(MapEdit02.selectedGroup);
			MapEdit02.targetList.splice(function(){
				return MapEdit02.targetList.indexOf(this.selectedGroup);
			},1);

			//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
			tempMesh = MapEdit02.selectedGroup.children.find(function (item) {
				return item.name == "temp";
			});
			if (tempMesh.parentGroupName) {
				//부모 그룹의 정보가 존재할 경우 : 오브젝트
				console.log("오브젝트일 때");
				groupname = tempMesh.parentGroupName;
				parent = MapEdit02.targetGroup.find(function (item) {
					return item.name = groupname;
				});
				parent.remove(MapEdit02.selectedGroup.children[0]);

				console.log(parent);

				targetListParent = MapEdit02.targetList.find(function (item) {
					return item.name == groupname;
				});
				targetListParent.remove(MapEdit02.selectedGroup.children[0]);

			} else {
				//부모 그룹의 정보가 존재하지 않을 경우 : 그룹
				console.log("그룹일 때");
				MapEdit02.targetGroup.splice(function () {
					find = MapEdit02.targetGroup.find(function (item) {
						return item.name == this.selectedGroup.name;
					});
					return MapEdit02.targetGroup.indexOf(find);
				}, 1);

				MapEdit02.targetList.splice(function () {
					MapEdit02.targetList.find(function (item) {
						return item.name == this.selectedGroup.name;
					});
					return MapEdit02.targetList.indexOf(find);
				}, 1);
			}
			MapEdit02.selectedGroup = null;
			MapEdit02.isObjSelected = false;
			MapEdit02.isObjMove = false;
			MapEdit02.isGroupSelected = false;
			MapEdit02.isGroupMove = false;
			MapEdit02.deleteContextmenu();

			return scene;
		}

		//마우스 클릭
		,
	clickGroupFunction: function (e, scene) {
			console.log(scene);
			console.log(this.targetGroup);

			//혹시 메뉴가 아직 떠 있으면 메뉴 삭제해주기
			this.deleteContextmenu();

			//마우스 포인터의 위치에 따라 Object 인식하기
			var projector = new THREE.Projector();
			var vector = new THREE.Vector3(this.mouse.x, this.mouse.y, 1);
			projector.unprojectVector(vector, camera);
			var raycaster = new THREE.Raycaster(camera.position, vector.sub(camera.position).normalize());
			var intersects = raycaster.intersectObjects(MapEdit02.targetList);
			if (intersects.length > 0) {
				console.log(intersects);
				console.log(raycaster);
				if (this.movingGroup) {
					console.log("움직이는 그룹이 있을 때");
					if (this.isGroupMove || this.isObjMove) {
						console.log("오브젝트 이동하기");
						if (intersects[0].object.geometry instanceof THREE.PlaneGeometry) {
							//intersect[0].object.geom이 plane인 경우
							console.log("PlaneGeom일 때");
							position = this.movingGroup.position;
							//현재 움직이던 그룹 장면에서 빼주기
							scene.remove(this.movingGroup);
							//현재 움직이고 있는 this.movingGroup이 오브젝트를 가져온건지 그룹을 가져온건지 구분하기
							tempMesh = this.findTempMesh(this.movingGroup.children);
							//찾아온 선택 매쉬를 현재 움직이는 그룹에서 빼준다
							this.movingGroup.remove(tempMesh);
							console.log(tempMesh);
							if (tempMesh.parentGroupName) {
								//선택한 그룹의 선택 매쉬안에 부모 그룹의 이름이 존재하면 오브잭트를 가져온것
								console.log("object일 때");
								
								//movingGroup안에 있는 오브젝트 복제 후  포지션 설정
								obj = this.movingGroup.children[0].clone();
								
								if(obj.geometry instanceof THREE.BoxGeometry){
									position.y += obj.geometry.parameters.height;
									console.log("박스 지오메트리일 경우 높이 더하기 : " + position.y);
								}
								
								obj.position.set(position.x, position.y, position.z);
								//plane의 부모 그룹 찾기 : scene
								parent = scene.children.find(function (item) {
									return item.name == intersects[0].object.name;
								});
								console.log(parent);
								//설정한 Obj를 각각 장면과 타겟 리스트 안에 넣어주기
								parent.add(obj);
								this.targetList.push(obj);
								
								//select, move 플래그 재설정
								this.selectedGroup = null;
								this.movingGroup = null;
								this.isObjMove = false;
								this.isObjSelected = false;
								this.targetList.push(obj);

							} else {
								//없을 경우 그룹을 가져온 것
								console.log("Group일 때");	
								//targetGroup 업데이트
								for(var i in this.targetGroup){
									if(this.targetGroup[i].name == this.movingGroup.name) this.targetGroup[i] = this.movingGroup;
								}
								scene.add(this.movingGroup);
								
								//그룹에 세팅된 포지션을 받아오고
								position = this.movingGroup.position;
								//각자 오브젝트의 위치에 더해준다
								for(var i in this.movingGroup.children){
									p = this.movingGroup.children[i].position;
									p.x += position.x;
//									p.y += position.y;
									p.z += position.z;
									console.log(this.movingGroup.children[i].name);
									console.log(p);
								}
								//마지막으로 그룹의 포지션을 0으로 해줌
								this.movingGroup.position.set(0,0,0);
								
								//타겟 포인트에 집어넣기
								for (var i in MapEdit02.movingGroup.children) {
									MapEdit02.targetList.push(MapEdit02.movingGroup.children[i]);
									console.log(MapEdit02.targetList);
								}

								this.selectedGroup = null;
								this.movingGroup = null;
								this.isGroupSelected = false;
								this.isGroupMove = false;
								console.log(scene);
								console.log(this.targetGroup);
							}
						} else {
							//intersect[0].object.geom이 Object3d나 Mesh 인 경우
							//부모그룹 찾기
							parent = scene.children.find(function (item) {
								return item.name == intersects[0].object.name;
							});
							console.log(parent);

							console.log(parent.children[0].name);
							console.log(intersects[0].object.name);

							if (parent && intersects[0].object.name == parent.children[0].name) {
								//포인터에 가장 가까운 위치의 오브젝트가 그룹 안의 첫번째 인덱스에 위치할 때
								//현재 움직이고 있는 this.movingGroup이 오브젝트를 가져온건지 그룹을 가져온건지 구분하기
								tempMesh = this.movingGroup.children.find(function (item) {
									return item.name == "temp";
								});

								if (tempMesh.parentGroupName) {
									//선택한 그룹의 선택 매쉬안에 부모 그룹의 이름이 존재하면 오브잭트를 가져온것
									console.log("object일 때");
									
									scene.remove(this.movingGroup);
									
									//movingGroup안에 있는 오브젝트 복제 후  포지션 설정
									position = this.movingGroup.position;
									obj = this.movingGroup.children[0].clone();
									
								if(obj.geometry instanceof THREE.BoxGeometry){
									position.y += obj.geometry.parameters.height;
									console.log("박스 지오메트리일 경우 높이 더하기 : " + position.y);
								}
								
									obj.position.set(position.x, position.y, position.z);
									
									//설정한 Obj넣어주기
									parent.add(obj);
									this.selectedGroup = null;
									this.movingGroup = null;
									this.isObjMove = false;
									this.isObjSelected = false;
									this.targetList.push(obj);
									
								}else console.log("가구와 벽은 같은 가구와 벽 오브젝트 위에 올릴 수 없습니다.");
							}
						}

					} else {
						console.log("오브젝트를 올리려고 하는 곳이 그룹의 첫번째 인덱스에 들어있는 객체일 때 : in this.targetList");
						console.log("오브젝트 더하기");
						parentGroup = this.findtargetGroup(intersects[0].object);
						if (parentGroup) {
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
							console.log(this.targetList);

							console.log("scene");
							console.log(scene);

						} else {
							console.log("오브젝트를 놓을 공간이 부족합니다.");
						}
					}
				} else {
					console.log("움직이는 그룹이 없을 때");
					for (var i in this.targetGroup) {
						console.log(this.targetGroup);
						console.log(intersects[0].object.name);
						console.log(this.targetGroup[i].children[0].name);
						console.log(this.targetGroup[i].children[0].name == intersects[0].object.name);

						if (this.targetGroup[i].children[0].name == intersects[0].object.name) {
							if (!(intersects[0].object.geometry instanceof THREE.PlaneGeometry)) {
								console.log(intersects[0]);
								console.log("그룹의 첫번째 오브젝트를 클릭했을 경우");
								//부모그룹을 저장
								this.parentGroup = this.targetGroup[i];
								console.log(this.targetGroup[i]);
								//그룹 선택하기 : 통합 매쉬가 더해진 그룹을 반환
								scene = this.selectGroup(scene, intersects[0], this.parentGroup);
								return scene;
							}
						} else {
							console.log(this.targetGroup);

							findMesh = this.targetGroup[i].children.find(function (item) {
								return intersects[0].object.name == item.name;
							});
							console.log(intersects[0].object);
							console.log(findMesh);
							//						console.log(findMesh.parent);
							console.log(this.targetGroup);
							if (!(intersects[0].object.geometry instanceof THREE.PlaneGeometry)) {
								if (findMesh) {
									console.log("그룹의 나머지 오브젝트를 선택했을 경우");
									//							//부모그룹을 저장
									this.parentGroup = findMesh.parent;
									console.log(this.parentGroup);
									//							//오브젝트 선택하기
									this.selectObj(scene, intersects[0]);
									return scene;
								}
							} else {
								console.log("선택한 곳이 PlaneMesh일 경우");
								return this.cancel(scene);
							}
						}
					} //for
				}
			}
			return scene;
		}

		//마우스 이동 : 그룹 이동
		,
	moveMousePointer: function (e, scene) {
			//마우스 위치 받아오기
			MapEdit02.mouse.x = (e.clientX / MapEdit02.width) * 2 - 1;
			MapEdit02.mouse.y = -(e.clientY / MapEdit02.height) * 2 + 1;
			//scene에 들어있는 카메라 찾기
			camera = scene.children.find(function (item) {
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
			plane = scene.children.find(function (item) {
				return item.geometry instanceof THREE.PlaneGeometry ? item : null;
			});
			if (plane) {
				planeG = plane.geometry;
				segmentW = planeG.parameters.widthSegments / 4;
				console.log(segmentW);

				//범위 설정
				planeW = planeG.parameters.width;
				planeH = planeG.parameters.height;
			}
			if (intersects.length > 0) {
				points = intersects[0].point;
				if (MapEdit02.movingGroup) {
					x = Math.round((points.x / segmentW) - 1) * segmentW + segmentW;

					if (intersects[0].object.geometry instanceof THREE.PlaneGeometry) y = 0;
					else if (this.findtargetGroup(intersects[0].object)) {
						console.log(this.findtargetGroup(intersects[0].object));
						if(intersects[0].object.geometry.parameters){
							//intersects의 가장 가까운 오브젝트의 지오메트리의 높이가 존재하면
							y = intersects[0].object.geometry.parameters.height;
							console.log("object의 파라미터 중 height 가 있으면 : " + y);
						}else{
							//height가 없을 경우
							console.log("Object의 파라미터 중 height가 없을 경우");
							faceHeight = intersects[0].distance;
							index = intersects.length-1;
							raycasterH = intersects[index].distance;
							console.log(raycasterH + "-" + faceHeight);
							y = raycasterH - faceHeight;
						}
						
					} else y = Math.round((points.y / segmentW) - 1) * segmentW + segmentW;

					z = Math.round((points.z / segmentW) - 1) * segmentW + segmentW;

					if (x < -(planeW * 0.45)) x = -(planeW * 0.45);
					if (x > planeW * 0.45) x = planeW * 0.45;
					if (z < -(planeH * 0.45)) z = -(planeW * 0.45);
					if (z > planeH * 0.45) z = planeW * 0.45;

					console.log(x + " : " + y + " : " + z);
					MapEdit02.movingGroup.position.set(x, y, z);
				}
			}
			return scene;
		}

		//마우스 오른쪽 클릭 이벤트 핸들러
		,
	mouseRightClick: function (e, scene) {
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
			if (intersects.length > 0 && (this.isGroupSelected || this.isObjSelected)) {
				console.log(intersects[0].object.name + "==" + this.selectedGroup.children[0].name);
				if (intersects[0].object.name == this.selectedGroup.children[0].name) {
					console.log("intersect의 길이가 0 이상이고 isGroupSelected = " + this.isGroupSelected +
						" isObjSelected = " + this.isObjSelected + "일 때");

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
							"position": "absolute",
							"top": e.clientY,
							"left": e.clientX,
							"color": "white",
							"background": "rgba(0,0,0,0.5)",
							"padding": "5px",
							"z-index": "10",
							"text-align": "center"
						})
						.on("click", function (e) {
							e.stopPropagation();
						});
					$(".contextM label")
						.css({
							"width": "100px"
						})
						.on("mousedown", function (e) {
							e.stopPropagation();
							var order = $(this).data("order");
							if (order == "delete") {
								console.log("삭제버튼 누름");
								scene = MapEdit02.delSelectedGroup(scene);

							} else if (order == "move") {
								console.log("이동버튼 누름");
								//마우스 포인터 위치가 어긋나는 오류를 잡아야함
								scene = MapEdit02.moveGroup(scene);

							} else if (order == "rotationL" || order == "rotationR") {
								console.log("selectGroup 회전");

								//각도 정하기
								var rotation;
								if (order == "rotationL") rotation = Math.PI / 4;
								else rotation = -(Math.PI / 4);
								console.log("회전 각도 : " + rotation);

								//targetGroup에서 삭제작업 : 그룹일 경우와 오브젝트일 경우
								tempMesh = MapEdit02.selectedGroup.children.find(function (item) {
									return item.name == "temp";
								});
								if (tempMesh.parentGroupName) {
									console.log("오브젝트일 때");
									for (var i in MapEdit02.selectedGroup.children) {
										MapEdit02.selectedGroup.children[i].rotation.y += rotation;
									}
								} else {
									console.log("그룹일 때");
									//회전 중심축이 되는 그룹의 첫번째 오브젝트를 회전시킴과 동시에 좌표를 구해준다.
									rotcenter = MapEdit02.selectedGroup.children[0].position;
//									MapEdit02.selectedGroup.children[0].rotation.y += rotation;
									
									//그룹의 나머지 오브젝트를 중심축에 맞춰 회전시킨 후 더한다.
									for(var i in MapEdit02.selectedGroup.children){
										MapEdit02.selectedGroup.children[i].rotation.y += rotation;
										p = MapEdit02.selectedGroup.children[i].position;
										position = rotationGroup(rotcenter.x, rotcenter.z, rotation, p);
										MapEdit02.selectedGroup.children[i].position.set(position.x, position.y, position.z);
										
									}
									function rotationGroup(px, pz, rotation, p){
										s = Math.sin(rotation);
										c = Math.cos(rotation);
										//현재 오브젝트의 좌표에서 회전 중심축을 빼기 : 회전시 그리는 원의 반지름
										p.x -= px;
										p.z -= pz;
										//회전시 움직이는 위치 계산
										xnew = p.z * s + p.x * c;
										znew = p.z * c - p.x * s;
										p.x = xnew + px;
										p.z = znew + pz;
										return p;
									}
								}
								MapEdit02.deleteContextmenu();
							}
						});
				}

			}
			return scene;
		}

		,
	findTempMesh: function (arr) {
			temp = arr.find(function (item) {
				return item.name == "temp";
			});
			return temp;
		}

		//contextmenu 삭제
		,
	deleteContextmenu: function () {
			var contextmenu = $(".contextM");
			if (contextmenu.length != 0) contextmenu.remove();
		}

		,
	addMesh: function (obj) {
			//선택에 사용할 임시 매쉬 만들기 : intersect에 잡힌 객체의 지오메트리 + 메테리얼 추가
			var geom = new THREE.Geometry();
			if (obj instanceof THREE.Mesh) {
				console.log("Object일 때");
				geom = obj.geometry;
			} else {
				console.log("Group일 때 : 통합 지오메트리 생성");
				meshes = obj.children;
				for (var i in meshes) {
					console.log(meshes[i].geometry);
					console.log(meshes[i].matrix);
					geom.merge(meshes[i].geometry, meshes[i].matrix);
				}
			}
			mat1 = new THREE.MeshLambertMaterial({
				color: 0x42f5ff,
				opacity: 0.3,
				transparent: true
			});
			mat2 = new THREE.MeshBasicMaterial({
				color: 0x42f5ff,
				wireframe: true
			});

			var mesh = new THREE.SceneUtils.createMultiMaterialObject(geom, [mat1, mat2]);
			scale = 1.006;
			mesh.scale.set(scale, scale, scale);
			//이 Mesh의 Position은 상대적

			mesh.rotation.y = obj.rotation.y;

			console.log(obj.position);
			if(obj instanceof THREE.Mesh) mesh.position.set(obj.position.x, obj.position.y, obj.position.z);
		
			mesh.name = "temp"
			//부모 객제가 있을 경우 부모 객체의 이름 정보를 넣어줌
//			console.log(obj.parent.name);
			if (obj.parent) mesh.parentGroupName = obj.parent.name;
			console.log(mesh.position);
			return mesh;
		}

		//타겟 그룹 리스트에서 타겟리스트와 같은 이름의 그룹 찾기
		,
	findtargetGroup: function (object) {
		return this.targetGroup.find(function (item) {
			return item.name == object.name;
		});
	}
}
