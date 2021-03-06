package org.spring.my.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.spring.my.dto.Reply;
import org.spring.my.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

//@RestController //@Controller + @ResponseBody 아래의 @ResponseBody 를 생략 가능
@Controller
@RequestMapping("reply")
public class ReplyController {
	@Autowired
	private ReplyService replyservice;
	
	//댓글 추가
	@ResponseBody //리턴값을 테이터 자체로
	@RequestMapping(value = "/", method = RequestMethod.POST)  //뒤에 아무것도 없으면 여기
	public String add(@RequestBody Reply reply, HttpSession session, HttpServletRequest request) {
		String userid = (String)session.getAttribute("userid"); //접속된 아이디
		reply.setUserid(userid);  
		reply.setIp(request.getRemoteAddr());
		//댓글 추가
		replyservice.insert(reply);
		return "ok";
	}
	
	//댓글 리스트 조회
	@ResponseBody
	@RequestMapping(value = "/list/{bnum}", method = RequestMethod.GET)
	public List<Map<String, Object>> list(@PathVariable("bnum") int bnum, HttpSession session){
		String userid = (String)session.getAttribute("userid"); //접속된 아이디
		//댓글 조회
		List<Map<String, Object>> replist = replyservice.selectlist(bnum,userid);
				
		return replist;
	}
	
	//댓글 수정
	@ResponseBody 
	@RequestMapping(value = "/{rnum}", method = RequestMethod.PUT, //{RequestMethod.PUT,RequestMethod.PATCH} 2개 이상의 메소드 처리 가능
	produces = "application/text; charset=utf-8")
	public String update(@RequestBody Reply reply) { // @RequestBody 제이슨 형식을 받을때
		//수정
		replyservice.update(reply);
		return "수정 완료";
	}
	
	//댓글 삭제
	@ResponseBody 
	@RequestMapping(value = "/{rnum}", method = RequestMethod.DELETE, //{RequestMethod.PUT,RequestMethod.PATCH} 2개 이상의 메소드 처리 가능
	produces = "application/text; charset=utf-8")
	public String update(@PathVariable("rnum") int rnum) { //@PathVariable 매핑 정보의 값을 가져올 수 있다.
		//삭제
		replyservice.delete(rnum);
		return "삭제 완료";
	}
	
	
	
}
