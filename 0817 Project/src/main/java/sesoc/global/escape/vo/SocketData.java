package sesoc.global.escape.vo;

public class SocketData {
	private String roomNum;
	private Users loginUser;
	private String webSocketId;
	
	public SocketData(String roomNum, Users loginUser, String webSocketId) {
		super();
		this.roomNum = roomNum;
		this.loginUser = loginUser;
		this.webSocketId = webSocketId;
	}

	public String getRoomNum() {
		return roomNum;
	}

	public void setRoomNum(String roomNum) {
		this.roomNum = roomNum;
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
		return "WebSocketTest [roomNum=" + roomNum + ", loginUser=" + loginUser + ", webSocketId=" + webSocketId + "]";
	}
	
}//class
