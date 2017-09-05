package sesoc.global.escape.dao;

import sesoc.global.escape.vo.Users;

public interface UserDAO {
	public int insertUser(Users user);
	public Users selectId(Users user);
	public Users selectNickName(Users user);
	public Users selectEmail(Users user); 
	public int updateUser(Users user);
}
