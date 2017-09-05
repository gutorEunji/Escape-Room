drop table room;
drop table playrecord;
drop table map;
drop table users;

CREATE TABLE USERS 
(
  ID VARCHAR2(30 BYTE) primary key 
, PW VARCHAR2(30 BYTE) 
, EMAIL VARCHAR2(50 BYTE) unique
, NAME VARCHAR2(30 BYTE) 
, NICKNAME VARCHAR2(30 BYTE) unique
, PROFILE VARCHAR2(20 BYTE)
);

CREATE TABLE MAP 
(
  NO number primary key
, user_id VARCHAR2(20 BYTE) 
, title VARCHAR2(20 BYTE) 
, content VARCHAR2(20 BYTE) 
, rank VARCHAR2(20 BYTE) 
, theme VARCHAR2(20 BYTE) 
, abgtime VARCHAR2(20 BYTE) 
, deadtime VARCHAR2(20 BYTE) 
, inputdate VARCHAR2(20 BYTE) DEFAULT sysdate 
, CONSTRAINT MAP_USEIID_FK FOREIGN KEY(USER_ID) references users(id)
);

CREATE TABLE PLAYRECORD 
(
  NO NUMBER primary key
, USER_ID VARCHAR2(20) NOT NULL 
, CONTRIBUTION VARCHAR2(20) 
, MAP_NO number NOT NULL 
, INPUTDATE VARCHAR2(20) 
, PLAYTIME VARCHAR2(20) 
, RANK VARCHAR2(20) 
, CONSTRAINT PLAYRECORD_USEIID_FK FOREIGN KEY(USER_ID) references users(id)
, CONSTRAINT PLAYRECORD_mapno_FK FOREIGN KEY(map_no) references map(no)
);

CREATE TABLE ROOM 
(
  NO NUMBER primary key
, MAP_NO number 
, MASTER_ID VARCHAR2(20 BYTE) 
, USER_ID VARCHAR2(20 BYTE) 
, MAX_NUM VARCHAR2(20 BYTE) 
, TITLE VARCHAR2(20 BYTE) 
, ROOM_PW VARCHAR2(20 BYTE) 
, CONSTRAINT room_USEIID_FK FOREIGN KEY(user_id) references users(id)
, CONSTRAINT room_masterid_FK FOREIGN KEY(master_id) references users(id)
, CONSTRAINT room_mapno_FK FOREIGN KEY(map_no) references map(no)
);
