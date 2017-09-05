package sesoc.global.escape.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import sesoc.global.escape.dao.RoomDAO;
import sesoc.global.escape.vo.Room;

@Repository
public class RoomRepository {
	
	@Autowired
	SqlSession sqlSession;
	
	public int insertRoom(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.insertRoom(room);
	}
	
	public int deleteRoom(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.deleteRoom(room);
	}
	
	public int insertWatingUser(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.insertWaitingUser(room);
	}
	
	public int deleteWatingUser(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.deleteWaitingUser(room);
	}
}
