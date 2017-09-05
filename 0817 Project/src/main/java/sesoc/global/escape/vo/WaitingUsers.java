package sesoc.global.escape.vo;

public class WaitingUsers {
	private int no;
	private int map_no;
	private String user_id;
	
	public WaitingUsers() {
		
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public int getMap_no() {
		return map_no;
	}

	public void setMap_no(int map_no) {
		this.map_no = map_no;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	@Override
	public String toString() {
		return "WatingUsers [no=" + no + ", map_no=" + map_no + ", user_id=" + user_id + "]";
	}
	
}
