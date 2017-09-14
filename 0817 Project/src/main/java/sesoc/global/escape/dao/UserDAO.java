package sesoc.global.escape.dao;

import java.util.List;

import sesoc.global.escape.vo.Room;
import sesoc.global.escape.vo.Users;
import sesoc.global.escape.vo.WaitingUsers;

public interface UserDAO {
	public int insertUser(Users user);
	public Users selectId(Users user);
	public Users selectNickName(Users user);
	public Users selectEmail(Users user); 
	public int updateUser(Users user);
	public List<WaitingUsers> selectWaitingUser(Room room);
	public int deleteNormalUser(String sessionId);
	public WaitingUsers findUser(WaitingUsers waitinguser);
	public Users findById(Users user);
}
