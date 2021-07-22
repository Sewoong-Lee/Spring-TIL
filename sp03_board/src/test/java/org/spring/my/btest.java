package org.spring.my;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.spring.my.dao.BoardDAO;
import org.spring.my.dto.Board;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

//테스트 라이브러리를 사용하기 위한 사전작업
@RunWith(SpringJUnit4ClassRunner.class)
//세션을 만들기위한 파일의 경로와, 오토와이드를 하기위한 서블렛 컷텍스트 파일 경로를 지정
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/**/servlet-context.xml"})
public class btest {
	
	@Autowired
	private BoardDAO boarddao;
	
	@Test
	public void testinsert() {
		Board board = new Board();
		board.setUserid("ddd");
		board.setSubject("테스트 제목");
		board.setContent("테스트 내용");
		board.setIp("192.111.1.100");
		
		boarddao.insert(board);
	}
	
	@Test
	public void testdelete() {
		int bnum = 3;
		
		boarddao.delete(bnum);
	}
	
	@Test
	public void testupdate() {
		Board board = new Board();
		board.setBnum(1);
		board.setSubject("test22");
		board.setContent("test22");
		board.setIp("192.111.1.100");
		
		boarddao.update(board);
	}
	
	@Test
	public void testselectlist() {
		
//		List<Board> blist = boarddao.selectlist();
//		
//		System.out.println(blist);
//		//null이 아닐때 성공
//		assertNotNull(blist);
	}
	
	/*
	 * @Test public void testselectone() { int bnum = 4; Board board =
	 * boarddao.selectone(bnum);
	 * 
	 * System.out.println(board); }
	 */
	
	
	
	
	
	

}
