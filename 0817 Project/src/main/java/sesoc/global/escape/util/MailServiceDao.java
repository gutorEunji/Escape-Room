package sesoc.global.escape.util;

import java.io.File;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailServiceDao implements Mail{
	
	@Autowired
	private JavaMailSender sender;
	
	public void setJavaMailSender(JavaMailSender sender){
		this.sender = sender;
	};
	
	@Override
	public boolean send(String title, String text, String from, String to, String filePath) {
		System.out.println(sender);
		try {
			//메시지에 제목, 내용, 보내는사람, 받는사람, 첨부파일 추가하기
			//javax.mail.internet.MimeMessage 생성하기
			MimeMessage message = sender.createMimeMessage();
			System.out.println("MimeMessage생성");
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			helper.setSubject(title);
			helper.setText(text, true);
			helper.setFrom(from);
			helper.setTo(to);
			
			//첨부파일의 처리
			if(filePath != null){
				File file = new File(filePath);
				if(file.exists()){
					helper.addAttachment(file.getName(), new File(filePath));
				}
			}
			System.out.println("핼퍼 등록 : " + message);
			sender.send(message);
			System.out.println("메일전송완료");
			
			return true;
			
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return false;
	}

}
