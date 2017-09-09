package sesoc.global.escape.webSocket;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import sesoc.global.escape.dao.RoomDAO;
import sesoc.global.escape.repository.RoomRepository;
import sesoc.global.escape.repository.UserRepository;
import sesoc.global.escape.vo.Room;
import sesoc.global.escape.vo.Users;
import sesoc.global.escape.vo.WaitingUsers;
import sesoc.global.escape.vo.WebsocketVO;

public class WebSocketHandler extends TextWebSocketHandler {

	public static List<WebsocketVO> sessionList = new ArrayList<>();
	private static Logger logger = LoggerFactory.getLogger(WebSocketHandler.class);
	private String roomNum;
	
	@Autowired
	private Provider<RoomRepository> provider_room;
	
	@Autowired
	private Provider<UserRepository> provider_user;
	
	public int insertWaitingUser(WaitingUsers waitingUser){
		RoomRepository repo = provider_room.get();
		return repo.insertWaitingUser(waitingUser);
	}//getuserInfo
	
	public int deleteRoom(Room room){
		RoomRepository repo = provider_room.get();
		return repo.deleteRoom(room);
	}//deleteRoom
	
	public WaitingUsers selectBySessionId(WaitingUsers waitinguser){
		RoomRepository repo = provider_room.get();
		return repo.selectBySessionId(waitinguser);
	}//selectBySessionId
	
	public WaitingUsers findUser(WaitingUsers waitinguser){
		UserRepository repo = provider_user.get();
		return repo.findUser(waitinguser);
	}//selectBySessionId
	
	public List<WaitingUsers> selectAll(Room room){
		UserRepository repo = provider_user.get();
		return repo.selectWaitingUser(room);
	}//selectAll
	
	public int deleteNormalUser(String sessionId){
		UserRepository repo = provider_user.get();
		return repo.deleteNormalUser(sessionId);
	}//deleteNormalUser
	
	 @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		 System.out.println("afterConnectionEstablished");
		 
		 for (WebsocketVO data : sessionList) {
			data.getSession().sendMessage(new TextMessage("|Enter|"));
		 } // for
	}//afterConnectionEstablished
	 
	 @Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		 //다른 사용자 로그인시 갱신에 필요한 메소드
		 if (message.getPayload().toString().contains("|roomNum|") && message.getPayload().toString().contains("|userId|") && message.getPayload().toString().contains("|userPw|")) {
				roomNum = message.getPayload().toString().replaceAll("|roomNum|", "");
				int aIndex = roomNum.indexOf("|roomNum|");
				int rNo = Integer.parseInt(roomNum.substring(0, aIndex));
				int bIndex = roomNum.indexOf("|userId|");
				String userId = roomNum.substring(aIndex, bIndex).replace("|roomNum|", "");
				
				// websocket 등록
				insertWaitingUser(new WaitingUsers(0, rNo, userId, session.getId(), null, null));
				sessionList.add(new WebsocketVO(null, session, null, null));
				
				List<WaitingUsers> list = selectAll(new Room(rNo, 0, null, null, null));
				for (WaitingUsers waitingUsers : list) {
					for (WebsocketVO socket : sessionList) {
						if(socket.getSession().getId().equals(waitingUsers.getSession_id())){
							socket.getSession().sendMessage(new TextMessage("|Enter|"));
						}//if
					}//inner for
				}//for
				
				afterConnectionEstablished(session);
				return;
			} // if
		 
			//메세지 전송 준비
			for (WebsocketVO data : sessionList) {
				String msg = message.getPayload().toString();
				int index = msg.indexOf("*");
				String roomNo = message.getPayload().toString().substring(0, index);
				
				String nickname = "";
				WaitingUsers user = null;
				for (WebsocketVO webVO : sessionList) {
					if(webVO.getSession().getId().equals(session.getId())){
						user = findUser(new WaitingUsers(0, 0, null, webVO.getSession().getId(), null, null));
						nickname = user.getNickname();
					}//if
				}//inner for
				
				//메세지 전송
				List<WaitingUsers> userList = selectAll(new Room(Integer.parseInt(roomNo), 0, null, null, null));
				for (WaitingUsers waitingUsers : userList) {
					if(waitingUsers.getSession_id().equals(data.getSession().getId())){
						data.getSession().sendMessage(new TextMessage(nickname + " : " + msg.substring(index+1)));
					}//if
				}//outer fore
				
				
			} // for
		 
	}//handleMessage
	 
	 @Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		 System.out.println("afterConnectionClosed");
		 whenExit(session);
	}//afterConnectionClosed
	 
	 /**
	  * 유저 퇴장시 호출
	  * */
	 public void whenExit(WebSocketSession session) throws Exception{
		 WaitingUsers user = selectBySessionId(new WaitingUsers(0, 0, null, session.getId(), null, null));
		 if(user != null){
			 System.out.println("whenExit 방장");
			 deleteRoom(new Room(user.getRoom_no(), 0, null, null, null));
		 }//if
		 
		 deleteNormalUser(session.getId());
		 
		for (WebsocketVO websocketVO : sessionList) {
			if(websocketVO.getSession().getId().equals(session.getId())){
				sessionList.remove(websocketVO);
				break;
			}//if
		}//for
		afterConnectionEstablished(session);
	 }//class
	 
}//class
