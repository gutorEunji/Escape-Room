package sesoc.global.escape.vo;

public class Room {
	private int no;
	private int map_no;
	private String master_id;
	private String title;
	private String room_pw;
	private int numberOfUsers;

	public Room() {

	}
	
	public Room(int no, int map_no, String master_id, String title, String room_pw, int numberOfUsers) {
		super();
		this.no = no;
		this.map_no = map_no;
		this.master_id = master_id;
		this.title = title;
		this.room_pw = room_pw;
		this.numberOfUsers = numberOfUsers;
	}

	public int getNumberOfUsers() {
		return numberOfUsers;
	}

	public void setNumberOfUsers(int numberOfUsers) {
		this.numberOfUsers = numberOfUsers;
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

	public String getMaster_id() {
		return master_id;
	}

	public void setMaster_id(String master_id) {
		this.master_id = master_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getRoom_pw() {
		return room_pw;
	}

	public void setRoom_pw(String room_pw) {
		this.room_pw = room_pw;
	}

	@Override
	public String toString() {
		return "Room [no=" + no + ", map_no=" + map_no + ", master_id=" + master_id + ", title=" + title + ", room_pw="
				+ room_pw + ", numberOfUsers=" + numberOfUsers + "]";
	}

}
