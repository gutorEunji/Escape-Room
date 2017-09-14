package sesoc.global.escape.vo;

public class WaitingUsers {
	private int no;
	private int room_no;
	private String user_id;
	private String session_id;
	private String profile;
	private String nickname;
	
	public WaitingUsers() {
		
	}
	
	public WaitingUsers(int no, int room_no, String user_id, String session_id, String profile, String nickname) {
		super();
		this.no = no;
		this.room_no = room_no;
		this.user_id = user_id;
		this.session_id = session_id;
		this.profile = profile;
		this.nickname = nickname;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getProfile() {
		return profile;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public String getSession_id() {
		return session_id;
	}

	public void setSession_id(String session_id) {
		this.session_id = session_id;
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}
	

	public int getRoom_no() {
		return room_no;
	}

	public void setRoom_no(int room_no) {
		this.room_no = room_no;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	@Override
	public String toString() {
		return "WaitingUsers [no=" + no + ", room_no=" + room_no + ", user_id=" + user_id + ", session_id=" + session_id
				+ ", profile=" + profile + ", nickname=" + nickname + "]";
	}

}
