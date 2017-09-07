package sesoc.global.escape.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Repository;

import sesoc.global.escape.dao.UserDAO;
import sesoc.global.escape.vo.Users;

@Repository
public class UserRepository {
	
	@Autowired
	SqlSession sqlSession;
	
	public int insertUser(Users user) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		return dao.insertUser(user);
	}
	
	public Users selectNickName(Users user) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		System.out.println("selectNickName L : " + user);
		return dao.selectNickName(user);
	}
	
	public Users selectEmail(Users user) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		return dao.selectEmail(user);
	}
	
	public Users selectId(Users user) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		return dao.selectId(user);
	}
	
	public int updateUser(Users user) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		return dao.updateUser(user);
	}
	
}
