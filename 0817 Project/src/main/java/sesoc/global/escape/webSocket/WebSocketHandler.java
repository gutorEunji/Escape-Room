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

import sesoc.global.escape.repository.UserRepository;
import sesoc.global.escape.vo.Users;
import sesoc.global.escape.vo.WebsocketVO;

public class WebSocketHandler extends TextWebSocketHandler {

	public static List<WebsocketVO> sessionList = new ArrayList<>();
	private static Logger logger = LoggerFactory.getLogger(WebSocketHandler.class);
	private String roomNum;
	
	@Autowired
	private Provider<UserRepository> provider;
	
	//일반 클래스에서 @Autowired 쓰기 위해 필요한 메소드  # Provider를 써야함.
	public Users getUserInfo(Users user){
		UserRepository repo = provider.get();
		return repo.selectId(user);
	}//getuserInfo
	
	 @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		 System.out.println("afterConnectionEstablished");
		 
		 for (WebsocketVO data : sessionList) {
			data.getSession().sendMessage(new TextMessage("|Enter|"));
		 } // for
	}//afterConnectionEstablished
	 
	 @Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		 
		 if (message.getPayload().toString().contains("|roomNum|") && message.getPayload().toString().contains("|userId|") && message.getPayload().toString().contains("|userPw|")) {
				roomNum = message.getPayload().toString().replaceAll("|roomNum|", "");
				int aIndex = roomNum.indexOf("|roomNum|");
				String rNo = roomNum.substring(0, aIndex);
				int bIndex = roomNum.indexOf("|userId|");
				String userId = roomNum.substring(aIndex, bIndex).replace("|roomNum|", "");
				int cIndex = roomNum.indexOf("|userPw|");
				String userPw = roomNum.substring(bIndex, cIndex).replace("|userId|", "");
				
				
				WebsocketVO vo = new WebsocketVO(rNo, session, getUserInfo(new Users(userId, userPw)), session.getId());
				sessionList.add(vo);
				
				afterConnectionEstablished(session);
				return;
			} // if
			
			for (WebsocketVO data : sessionList) {
				String msg = message.getPayload().toString();
				int index = msg.indexOf("*");
				
				String roomNo = message.getPayload().toString().substring(0, index);
				
				String nickname = "";
				for (WebsocketVO webVO : sessionList) {
					if(webVO.getWebSocketId().equals(session.getId())){
						nickname = webVO.getLoginUser().getNickname();
					}//if
				}//inner for
				
				if (data.getRoomNum().equals(roomNo)) {
					data.getSession().sendMessage(new TextMessage(nickname + " : " + msg.substring(index+1)));
				} // if
			} // for
		 
	}//handleMessage
	 
	 @Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		 System.out.println("afterConnectionClosed");
		 whenExit(session, session.getId());
	}//afterConnectionClosed
	 
	 public void whenExit(WebSocketSession session, String sessionId) throws Exception{
		for (WebsocketVO websocketVO : sessionList) {
			if(websocketVO.getWebSocketId().equals(sessionId)){
				sessionList.remove(websocketVO);
				break;
			}//if
		}//for
		afterConnectionEstablished(session);
	 }//class
	 
}//class
