package sesoc.global.escape.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import sesoc.global.escape.repository.UserRepository;
import sesoc.global.escape.util.MailServiceDao;
import sesoc.global.escape.vo.SocketData;
import sesoc.global.escape.vo.Users;
import sesoc.global.escape.vo.WebsocketVO;
import sesoc.global.escape.webSocket.WebSocketHandler;

@Controller
public class UserController {
   
   @Autowired
   UserRepository repo;
   
   @Autowired
   MailServiceDao mailserviceDao;
   
   @RequestMapping(value="loginForm", method=RequestMethod.GET)
   public String loginForm() {
	   return "user/loginForm";
   }

   @RequestMapping(value="findForm", method=RequestMethod.GET)
   public String findForm() {
      return "user/findForm";
   }
   
   @RequestMapping(value="joinForm", method=RequestMethod.GET)
   public String joinForm() {
      return "user/joinForm";
   }

   @RequestMapping(value="join", method=RequestMethod.POST)
   public String join(Users user, Model model) {
      System.out.println(user.getProfile());
      int result = repo.insertUser(user);
      
      if(result == 1) {
         model.addAttribute("message", "가입 완료");
      }
      else {
         model.addAttribute("message", "가입 실패");
      }
      
      return "message";
   }
   
   @RequestMapping(value="logout", method=RequestMethod.GET) 
   public String logout(HttpSession session) {
      session.invalidate();
      return "home";
   }
   
   @RequestMapping(value="login", method=RequestMethod.POST)
   public String login(Users user, Model model, HttpSession session) {
      Users selectedUser = repo.selectId(user);
      String result = "mainForm";
      
      if(selectedUser == null) {
         return "home";
      }
      
      model.addAttribute("profile", selectedUser.getProfile());
      session.setAttribute("loginUser", selectedUser);
      
      return result;
   }
   
   @ResponseBody
   @RequestMapping(value="checkNickName", method=RequestMethod.GET)
   public boolean checkNickName(Users user) {
      Users selectedUser = repo.selectNickName(user);
      boolean result = false;
      
      if(selectedUser == null) {
         result = true; 
      }
      
      return result;
   }
   
   @ResponseBody
   @RequestMapping(value="checkId", method=RequestMethod.GET)
   public boolean checkId(Users user) {
      Users selectedUser = repo.selectId(user);
      boolean result = false;
      
      if(selectedUser == null) {
         result = true; 
      }
      
      return result;
   }
   
   @ResponseBody
   @RequestMapping(value="checkEmail", method=RequestMethod.GET)
   public boolean checkEmail(Users user, HttpSession session) {
      Users selectedUser = repo.selectEmail(user);
      if(selectedUser == null) {
         String title = "Creative Room Escape : 이메일 인증 안내";
         
         UUID uuid = UUID.randomUUID();
         String uuidString = uuid.toString();
         
         session.setAttribute("certifiedNum", uuidString);
         
         String text = "일상생활에서의 탈출! 언제나 당신께 즐거움을 드리는 Creative Room Escape 입니다."
                + "<br>이메일 인증 번호를 보내드리니 확인 후 팝업 창에 정확히 입력 바랍니다."
                + "<br>"
                + "인증 번호 : " + uuid
                + "<br>언제나 저희 서비스를 이용해주셔서 감사드리며, 앞으로도 저희 서비스를 즐겁게 이용해주시기 바랍니다."
                + "<br>감사합니다.";
         mailserviceDao.send(title, text, "tngus@gmail.com", user.getEmail(), null);
         return true;
      }
      
      return false;
   }
   
   @RequestMapping(value="checkEmailForm", method=RequestMethod.GET)
   public String checkEmailForm() {
      return "user/checkEmailForm";
   }
   
   @ResponseBody
   @RequestMapping(value="certifiedCheck", method=RequestMethod.GET)
   public boolean certifiedCheck(String certifiedNum, HttpSession session) {
      String savedCN = (String) session.getAttribute("certifiedNum");
      
      if(savedCN.equals(certifiedNum)) {
         return true;
      }
      
      return false;
   }
   
   
   /**
    * 아이디 확인 후 유저 검색해서 있으면 해당 이메일로 메일 전송하기
    * @param email 유저가 입력한 이메일(고유)
    * @param name 유저 이름
    * @param ratts 메세지 전달용
    * @return 이메일과 닉네임이 일치하는 아이디 존재여부
    */
   @RequestMapping(value = "findID", method = RequestMethod.POST)
   public String findID(Users user, RedirectAttributes ratts){
      //받은 닉네임과 이메일로 유저 검색
      Users selectedUser = repo.selectEmail(user);
      
      if(selectedUser != null){
         //유저가 있을 경우
         String id = selectedUser.getId();
         String title = "Creative Room Escape : 아이디 찾기 안내";
         StringBuilder sb = new StringBuilder();
         sb.append("일상생활에서의 탈출! 언제나 당신께 즐거움을 드리는 Creative Room Escape 입니다.");
         sb.append("<br>귀하의 아이디는 <strong>" + id + "</strong>입니다.");
         sb.append("<br>언제나 저희 서비스를 이용해주셔서 감사드리며, 앞으로도 저희 서비스를 즐겁게 이용해주시기 바랍니다.");
         sb.append("<br>감사합니다.");
         
         mailserviceDao.send(title, sb.toString(), "tngus@gmail.com", selectedUser.getEmail(), null);
         ratts.addFlashAttribute("message", "귀하의 이메일 주소로 해당 이메일로 가입된 아이디를 전송하였으니 확인 바랍니다.");
      }else{
         ratts.addFlashAttribute("message", "해당 이메일로 가입된 아이디가 존재하지 않습니다. 확인 후 다시 이용바랍니다.");
      }
      
      return "redirect:findForm";   
   }
   
   /**
    * 유저에게 아이디와 이메일을 받아 인증번호를 전송한다
    * @param session 세션에 만든 UUID 저장
    * @param userid 받아온 userid 유저검색용
    * @param email 받아온 email 유저검색용
    * @param ratts 결과에 따른 메시지 송신용
    * @return 메일을 보낸 후 홈화면으로 이동한다
    */
   @RequestMapping(value = "findPW", method = RequestMethod.POST)
   public String findPW(Users user, RedirectAttributes ratts, HttpSession session){
      //입력받은 아이디와 이메일로 유저 검색 
      Users selectedUser = repo.selectId(user);
      String url = "http://localhost:8888/escape";
      
      if(user != null){
         //만약 찾아온 유저가 있다면
         String title = "Creative Room Escape : 비밀번호 찾기 안내";
         String id = selectedUser.getId();
         
         UUID uuid = UUID.randomUUID();
         String uuidString = uuid.toString();
         
         session.setAttribute("certifiedNum", uuidString);
         //세션에 검색한 유저의 정보를 넣어준다. 나중에 패스워드 업데이트할 때 쓸거임
         
         String text = "일상생활에서의 탈출! 언제나 당신께 즐거움을 드리는 Creative Room Escape 입니다."
                + "<br>비밀번호 재설정을 위한 링크를 보내드리니 클릭 후 재설정 바랍니다."
                + "<br>"
                + "<fildset>"
                + "<legend><strong>" + id + "님 비밀번호 인증코드</strong></legend>"
                + "<a href = '"+ url +"/CertifyNum?certifiedNum=" + uuidString + "&id=" + id + "'>"+ uuidString +"</a>"
                + "</fildset>"
                + "<br>언제나 저희 서비스를 이용해주셔서 감사드리며, 앞으로도 저희 서비스를 즐겁게 이용해주시기 바랍니다."
                + "<br>감사합니다.";
         mailserviceDao.send(title, text, "tngus@gmail.com", selectedUser.getEmail(), null);
         ratts.addFlashAttribute("message","귀하의 이메일 주소로 비밀번호 재설정에 필요한 인증코드를 발송하였으니 확인 바랍니다.");
      }else{
         ratts.addFlashAttribute("message","해당 이메일 주소로 가입된 아이디가 존재하지 않습니다. 확인 후 다시 이용바랍니다.");
      }
      return "redirect:findForm";
   }
   
   /**
    * 비밀번호 인증번호 체크하기
    * @param uuid 비밀번호 인증번호로 준 UUID
    * @param session 세션에 저장된 UUID를 가져올 때 사용
    * @param ratts UUID가 일치하지 않을 때 메시지 송신용
    * @return 결과에 따라 비밀번호를 업데이트 하거나 홈화면으로 이동한다
    */
   @RequestMapping(value = "/checkuuid", method = RequestMethod.GET)
   public String checkUUID(String certifiedNum, String id, HttpSession session, RedirectAttributes ratts, Model model){
      String savedUUID = (String) session.getAttribute("certifiedNum");
      if(certifiedNum.equals(savedUUID)) {
         model.addAttribute("id", id);
         return "updatePWD";
      }
      else {
         ratts.addAttribute("message","인증번호가 일치하지 않습니다.");
      }
      return "redirect:findForm";
   };
   
   @RequestMapping(value = "/CertifyNum", method = RequestMethod.GET)
   public String updatePWD(String id, Model model){
      model.addAttribute("id", id);
      return "user/updatePWForm";
   }
   
   @RequestMapping(value = "/updatePWD", method = RequestMethod.POST)
   public String updatePWD(Users user, Model model){
      int result = repo.updateUser(user);
      if(result == 1) {
         model.addAttribute("message", "비밀번호가 정상적으로 변경되었습니다.");
      }
      else {
         model.addAttribute("message", "비밀번호가 정상적으로 변경되지 않았습니다.");
      }
      return "message";
   }
   
   @RequestMapping(value = "/profileForm", method = RequestMethod.GET)
   public String profileForm(){
      return "user/profileForm";
   }
   
   @RequestMapping(value = "/updateForm", method = RequestMethod.GET)
   public String updateForm(){
      return "user/updateForm";
   }
   
   @RequestMapping(value="update", method=RequestMethod.POST)
   public String update(Users user, HttpSession session, Model model) {
      user.setId(((Users)session.getAttribute("loginUser")).getId());
      System.out.println(user);
      int result = repo.updateUser(user);
      String mapping = "";
      String message = "정상적으로 회원 정보가 수정되었습니다. 다시 로그인 해주세요";
      
      if(result != 1) {
         message = "정상적으로 회원 정보가 수정되지 않았습니다. 다시 시도해주세요";
         mapping = "mainForm";
      }
      
      model.addAttribute("message", message);
      model.addAttribute("mapping", mapping);
      
      return "message";
   }
   
}
