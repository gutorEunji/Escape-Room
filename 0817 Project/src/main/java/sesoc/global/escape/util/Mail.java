package sesoc.global.escape.util;

public interface Mail {
	
	/**
	 * 아이디, 패스워드 인증자에게 메일전송
	 * @param title 메일 제목
	 * @param text 메일 내용
	 * @param from 송신자
	 * @param to 수신자
	 * @param file 첨부파일 경로
	 * @return 메일 발송 성공여부
	 */
	public boolean send(String title, String text, String from, String to, String file);
}
