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
	
	/**
	 * @param waitingUser
	 * @return INSERT 성공여부
	 * 대기방에 입장한 유저들의 정보를 DB에 추가
	 */
	public int insertWaitingUser(WaitingUsers waitingUser){
		RoomRepository repo = provider_room.get();
		return repo.insertWaitingUser(waitingUser);
	}//getuserInfo
	
	/**
	 * @param room
	 * @return
	 * 방장이 방을 나갔을 때 방에 대한 모든 DB가 삭제
	 */
	public int deleteRoom(Room room){
		RoomRepository repo = provider_room.get();
		return repo.deleteRoom(room);
	}//deleteRoom
	
	/**
	 * @param waitinguser
	 * @return DB에 있는 방장 정보 반환
	 * DB에 있는 방장 정보만 불러온다
	 */
	public WaitingUsers selectBySessionId(WaitingUsers waitinguser){
		RoomRepository repo = provider_room.get();
		return repo.selectBySessionId(waitinguser);
	}//selectBySessionId
	
	/**
	 * @param waitinguser
	 * @return DB에 있는 일반 유저에 대한 정보 반환
	 * DB에 있는 일반 유저에 대한 정보만 불러온다
	 */
	public WaitingUsers findUser(WaitingUsers waitinguser){
		UserRepository repo = provider_user.get();
		return repo.findUser(waitinguser);
	}//selectBySessionId
	
	/**
	 * @param room
	 * @return 해당 방에 대한 모든 유저들의 정보를 반환
	 * 특정한 방에 접속에 있는 유저들의 대한 정보를 List로 반환한다
	 */
	public List<WaitingUsers> selectAll(Room room){
		UserRepository repo = provider_user.get();
		return repo.selectWaitingUser(room);
	}//selectAll
	
	/**
	 * @param sessionId
	 * @return 
	 * 방장이 아닌 일반 유저가 방에서 퇴장시에 DB에서 삭제
	 */
	public int deleteNormalUser(String sessionId){
		UserRepository repo = provider_user.get();
		return repo.deleteNormalUser(sessionId);
	}//deleteNormalUser
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		 System.out.println("afterConnectionEstablished");
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
				
				List<WaitingUsers> list = selectAll(new Room(rNo, 0, null, null, null, 0));
				for (WaitingUsers waitingUsers : list) {
					for (WebsocketVO socket : sessionList) {
						if(socket.getSession().getId().equals(waitingUsers.getSession_id())){
							socket.getSession().sendMessage(new TextMessage("|Enter|"));
						}//if
					}//inner for
				}//for
				
//				afterConnectionEstablished(session);
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
				List<WaitingUsers> userList = selectAll(new Room(Integer.parseInt(roomNo), 0, null, null, null, 0));
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
	  * @param session
	  * @throws Exception
	  * 유저가 방에서 퇴장했을 때에 대한 로직처리
	  */
	 public void whenExit(WebSocketSession session) throws Exception{
		 
		 WaitingUsers user = selectBySessionId(new WaitingUsers(0, 0, null, session.getId(), null, null));
		 
		 if(user != null){
			 List<WaitingUsers> deleting_list = selectAll(new Room(user.getRoom_no(), 0, null, null, null, 0));
			 deleteRoom(new Room(user.getRoom_no(), 0, null, null, null, 0));
			 for (WaitingUsers waitingUsers : deleting_list) {
				 for (WebsocketVO websocketVO : sessionList) {
					 
					 if(websocketVO.getSession().getId().equals(waitingUsers.getSession_id())){
						 if(!(websocketVO.getSession().getId().equals(session.getId()))){
							 websocketVO.getSession().sendMessage(new TextMessage("|room_deleted|"));
						 }//inner if
						 sessionList.remove(websocketVO);
						 break;
					 }//if-else
					 
				 }//inner for
			}//outer for
			 
		 }else{
			 deleteNormalUser(session.getId());
			 
			 for (WebsocketVO websocketVO : sessionList) {
				 if(websocketVO.getSession().getId().equals(session.getId())){
					 sessionList.remove(websocketVO);
					 break;
				 }//if
			 }//for
			 
			 for (WebsocketVO data : sessionList) {
				 data.getSession().sendMessage(new TextMessage("|Enter|"));
			 } // for
		 }//else if
		 
	 }//whenExit
	 
}//class
