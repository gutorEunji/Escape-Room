package sesoc.global.escape.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import sesoc.global.escape.repository.RoomRepository;
import sesoc.global.escape.repository.UserRepository;
import sesoc.global.escape.vo.Room;
import sesoc.global.escape.vo.SocketData;
import sesoc.global.escape.vo.Users;
import sesoc.global.escape.vo.WaitingUsers;
import sesoc.global.escape.vo.WebsocketVO;
import sesoc.global.escape.webSocket.WebSocketHandler;

@Controller
public class RoomController {
	
	@Autowired
	UserRepository user_repo;
	
	@Autowired
	RoomRepository room_repo;

	@RequestMapping(value = "waitingRoom", method = RequestMethod.GET)
	public String waitingRoom(String room_no, Users user, Model model) {
		
		Users selectedUser = null;
		if(user.getNickname() != null){
			selectedUser = user_repo.selectNickName(user);
		}else{
			selectedUser = user_repo.selectId(user);
		}
		model.addAttribute("user", selectedUser);
		model.addAttribute("room_no", room_no);
		return "room/waitingRoom";
	}// waitingRoom

	@ResponseBody
	@RequestMapping(value = "renew", method = RequestMethod.GET)
	public List<WaitingUsers> renew(String userId, String userPw, String roomNum) {
		return user_repo.selectWaitingUser(new Room(Integer.parseInt(roomNum), 0, null, null, null, 0));
	}// waitingRoom
	
	@RequestMapping(value = "makingRoomPopUp", method = RequestMethod.GET)
	public String makingRoomPopUp(String id, Model model) {
		model.addAttribute("user_id", id);
		return "room/makingRoomPopUp";
	}
	
	@ResponseBody
	@RequestMapping(value = "makingRoom", method = RequestMethod.POST)
	public int makingRoom(Room room, String id) {
		int room_no = room_repo.selectNextRoomNo();
		room.setNo(room_no);
		room.setMaster_id(id);
		int result = room_repo.insertRoom(room);
		if(result == 1) {
			return room_no;
		}
		return -1;
	}
	
	@RequestMapping(value = "roomList", method = RequestMethod.GET)
	public String roomList(String nickname, Model model) {
//		model.addAttribute("roomList", room_repo.selectAllRoom());
		model.addAttribute("nickname", nickname);
		return "room/roomList";
	}// waitingRoom
	
	@ResponseBody
	@RequestMapping(value="roomListRenew", method=RequestMethod.GET)
	public List<Room> roomListRenew(String selectedWord, String searchWord) {
		Map<String, String> map = new HashMap<>();
		map.put("selectedWord", selectedWord);
		map.put("searchWord", searchWord);
		
		return room_repo.selectAllRoom(map);
	}// waitingRoom
	
	
}
