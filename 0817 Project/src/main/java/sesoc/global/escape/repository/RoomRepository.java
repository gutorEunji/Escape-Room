package sesoc.global.escape.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import sesoc.global.escape.dao.RoomDAO;
import sesoc.global.escape.vo.Room;
import sesoc.global.escape.vo.WaitingUsers;

@Repository
public class RoomRepository {
	
	@Autowired
	SqlSession sqlSession;
	
	public int selectNextRoomNo() {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.selectNextRoomNo();
	}
	
	public int insertRoom(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.insertRoom(room);
	}
	
	public int deleteRoom(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.deleteRoom(room);
	}
	
	public int insertWaitingUser(WaitingUsers watingUser) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.insertWaitingUser(watingUser);
	}
	
	public List<WaitingUsers> selectWaitingUser(Room room) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.selectWaitingUser(room);
	}
	
	public int deleteWatingUser(WaitingUsers watingUser) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.deleteWaitingUser(watingUser);
	}

	public List<Room> selectAllRoom(Map<String, String> map) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		List<Room> result = dao.selectAllRoom(map);
		return result;
//		return dao.selectAllRoom();
	}

	public WaitingUsers selectBySessionId(WaitingUsers waitinguser) {
		RoomDAO dao = sqlSession.getMapper(RoomDAO.class);
		return dao.selectBySessionId(waitinguser);
	}
}
