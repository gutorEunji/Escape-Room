package sesoc.global.escape.dao;

import sesoc.global.escape.vo.Room;

public interface RoomDAO {
	public int insertRoom(Room room);
	public int deleteRoom(Room room);
	public int insertWaitingUser(Room room);
	public int deleteWaitingUser(Room room);
}
