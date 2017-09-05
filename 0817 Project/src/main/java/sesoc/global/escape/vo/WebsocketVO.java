package sesoc.global.escape.vo;

import org.springframework.web.socket.WebSocketSession;

public class WebsocketVO {
	private String roomNum;
	private WebSocketSession session;
	private Users loginUser;
	private String webSocketId;
	
	public WebsocketVO(String roomNum, WebSocketSession session, Users loginUser, String webSocketId) {
		super();
		this.roomNum = roomNum;
		this.session = session;
		this.loginUser = loginUser;
		this.webSocketId = webSocketId;
	}

	public String getRoomNum() {
		return roomNum;
	}

	public void setRoomNum(String roomNum) {
		this.roomNum = roomNum;
	}

	public WebSocketSession getSession() {
		return session;
	}

	public void setSession(WebSocketSession session) {
		this.session = session;
	}

	public Users getLoginUser() {
		return loginUser;
	}

	public void setLoginUser(Users loginUser) {
		this.loginUser = loginUser;
	}

	public String getWebSocketId() {
		return webSocketId;
	}

	public void setWebSocketId(String webSocketId) {
		this.webSocketId = webSocketId;
	}

	@Override
	public String toString() {
		return "WebsocketVO [roomNum=" + roomNum + ", session=" + session + ", loginUser=" + loginUser
				+ ", webSocketId=" + webSocketId + "]";
	}
	
}//class
