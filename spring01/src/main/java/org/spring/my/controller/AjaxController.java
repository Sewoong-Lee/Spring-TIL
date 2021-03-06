package org.spring.my.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.spring.my.dto.Item;
import org.spring.my.dto.MemberDTO;
import org.spring.my.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import oracle.jdbc.proxy.annotation.Post;

@Controller
@RequestMapping("ajax")
public class AjaxController {
	private static final Logger logger = LoggerFactory.getLogger(AjaxController.class);
	
	@Autowired
	private ItemService itemservice;
	
	//ajax테스트 폼으로
	@RequestMapping("01")
	public String ajax01() {
		
		return "0301_ajax/20210719_01";
	}
	//produces : 리턴되는 데이터 타입 (인코딩)
	@ResponseBody //반환값을 데이터 자체로 인식
	@RequestMapping(value = "01_text", produces = "application/text; charset=utf-8") //한글처리
	public String ajax01(String userid, int age) {
		logger.info(userid);
		logger.info("나이"+age);
		return "성공";
	}
	
	//json테스트 폼으로 이동(파라메터로)
	@RequestMapping("02")
	public String ajax02() {
		
		return "0301_ajax/20210719_02_json";
	}
	
	@ResponseBody
	@PostMapping(value="02_json", produces = "application/text; charset=utf-8")
	public String ajax02(@RequestBody HashMap<String, Object> map) {
		//@RequestBody : 제이슨 형태의 값을 받기 위해(다중값이 아닌 하나로만 받아야 한다) 
		logger.info(map.toString());
		
		return "성공";
	}
	
	//dto테스트 폼으로 이동(파라메터로)
	@RequestMapping("03")
	public String ajax03() {
			
		return "0301_ajax/20210719_03_dto";
	}
	
	@ResponseBody
	@RequestMapping(value="03_dto")
	public Map<String,String> ajax03(String userid) {
		logger.info(userid);
		MemberDTO member = new MemberDTO();
		member.setUserid(userid);
		member.setName("이름");
		member.setPasswd("1111");
		
		//맵으로 보내보기
		Map<String,String> mmap = new HashMap<>();
		mmap.put("userid", userid);
		mmap.put("name", "이름");
		mmap.put("passwd", "1111");
		
		return mmap;
	}
	
	//dto테스트 폼으로 이동(파라메터로)
	@RequestMapping("04")
	public String ajax04() {
				
		return "0301_ajax/20210719_04_list";
	}
	
//	@ResponseBody
//	@RequestMapping(value="04_list")
//	public List<Item> ajax05(String itemcode) {
//		logger.info(itemcode);
//		Item item = new Item();
//		List<Item> ilist = itemservice.selectlist(itemcode);
//		logger.info(ilist.toString());
//		return ilist;
//	}
	
	@ResponseBody
	@RequestMapping(value="04_list/{itemcode}", method = RequestMethod.GET)
	public List<Item> ajax05(@PathVariable("itemcode") String itemcode) {
		//@PathVariable : url에서 값을 읽어오는데 사용
		logger.info(itemcode);
		Item item = new Item();
		List<Item> ilist = itemservice.selectlist(itemcode);
		logger.info(ilist.toString());
		return ilist;
	}
	
}
