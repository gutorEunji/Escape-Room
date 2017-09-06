package sesoc.global.escape.dao;

import java.util.List;

import sesoc.global.escape.vo.Room;
import sesoc.global.escape.vo.WaitingUsers;

public interface RoomDAO {
	public int selectNextRoomNo();
	public int insertRoom(Room room);
	public int deleteRoom(Room room);
	public int insertWaitingUser(WaitingUsers waitingUser);
	public List<WaitingUsers> selectWaitingUser(Room room);
	public int deleteWaitingUser(WaitingUsers waitingUser);
}
