package org.spring.my.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.spring.my.dao.BoardDAO;
import org.spring.my.dao.FileDAO;
import org.spring.my.dao.UsermangeDAO;
import org.spring.my.dto.Board;
import org.spring.my.dto.Boardfile;
import org.spring.my.dto.Page;
import org.spring.my.dto.Usermange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class BoardServiceimpl implements BoardService{
	
	@Autowired
	private BoardDAO boarddao;
	@Autowired
	private FileService fileservice;
	@Autowired
	private FileDAO filedao;
	@Autowired
	private UsermangeDAO usermangedao;
	
	//메소드 단위로 트랜잭션 설정
	//트랜잭션으로 파일에서 에러가 나면 내용까지 인서트 막음
	@Transactional
	@Override
	public void insert(Board board) {
		//게시물 저장
		boarddao.insert(board);//인서트를 하고나면 저장 후 bnum이 셋팅완료
		
		//매퍼에게 전달할 맵
		Map<String, Object> fmap = new HashMap<>();
		
		//파일맵에 bnum저장
		fmap.put("bnum", board.getBnum());
		
		//파일이름 리스트 만들기
		List<String> filenamelist = new ArrayList<>();
		
		//board디티오의 파일 이름 저장
		List<MultipartFile> files= board.getFiles();
		//만약 files가 널이라면(파일 추가 인풋창을 다 날리면) 리턴
		if(files == null) return ;
		
		for(MultipartFile mf :files) {
			//파일 업로드 저장
			String filename = fileservice.fileupload(mf);
			
			//파일 네임이 공백이 아닐때만 추가해라
			if(!filename.equals("")) {
				filenamelist.add(filename);
			}
		}
		//filenamelist의 사이즈가 0이면 돌아가라
		if(filenamelist.size() == 0) return ;
		fmap.put("filenamelist", filenamelist);
		//System.out.println(fmap);
		fileservice.insertboardfile(fmap);
	}

	@Override
	public List<Board> selectlist(Page page) {
		//**페이지 값 구하기
		//전체 게시물 수 구하기
		int totcnt = boarddao.selecttotcnt(page);
		
		//전체 페이지 수 구하기
		int totpage = totcnt / page.getPerpage();
		if(totcnt % page.getPerpage() != 0) { //나머지가 있으면 1페이지 추가
			totpage += 1;
		}
		page.setTotpage(totpage);
		
		//현재 페이지
		int  curpage = page.getCurpage();
		//시작번호
		int startnum = (curpage-1) * page.getPerpage() + 1;
		page.setStartnum(startnum);
		//끝번호
		int endnum = startnum + page.getPerpage() -1;
		page.setEndnum(endnum);
		
		//시작페이지
		int startpage = curpage - ((curpage-1) % page.getPerblock());
		page.setStartpage(startpage);
		//끝페이지
		int endpage = startpage + page.getPerblock() -1;
		if(endpage > totpage) endpage = totpage;
		page.setEndpage(endpage);
		
		return boarddao.selectlist(page);
	}

	@Override
	public Map<String, Object> selectone(int bnum, String userid) {
		//게시물 한건 조회
		Map<String, Object> findmap = new HashMap<String, Object>();
		findmap.put("bnum", bnum);
		findmap.put("userid", userid);
		
		Map<String, Object> board = boarddao.selectone(findmap);
		//게시물 파일 조회
		List<Boardfile> bflist = filedao.selectlist(bnum);
		
		Map<String, Object> bfmap = new HashMap<>();
		bfmap.put("board", board);
		bfmap.put("bflist", bflist);
		
		return bfmap;
	}
	
	//조회수 +1
	@Transactional  //트랜잭션 걸어줌
	@Override
	public void readcountadd(int bnum, String userid) {
		//유저매니저 테이블에 데이터가 없다면 인서트 (중복조회수 방지)
		Usermange usermange = new Usermange();
		usermange.setGubun("1"); //1: 게시글 2:댓글
		usermange.setNum(bnum); //게시글 또는 댓글의 번호
		usermange.setUserid(userid);  //회원 아이디
		usermange.setLikegubun("0");  //0:조회, 1:좋아요, 2:싫어요
		
		if(usermangedao.selectone(usermange) == null) {
			//기존에 조회 정보가 없다면 매니져테이블에 인서트 및 조회 +1 
			usermangedao.insert(usermange);
			boarddao.readcountadd(bnum);
		}
		
	}
	
	//좋아요+1
	@Transactional  //트랜잭션 걸어줌
	@Override
	public void updatelikecnt(int bnum, String userid) {
		//1)board의 likecnt +1
		boarddao.updatelikecnt(bnum);
		
		//2)usermange에 likegubun 1로 변경
		Usermange usermange = new Usermange();
		usermange.setGubun("1"); //1: 게시글 2:댓글
		usermange.setNum(bnum); //게시글 또는 댓글의 번호
		usermange.setUserid(userid);  //회원 아이디
		usermange.setLikegubun("1");  //0:조회, 1:좋아요, 2:싫어요
		
		usermangedao.update(usermange);
	}
	
	//좋아요 취소
	@Transactional  //트랜잭션 걸어줌
	@Override
	public void updatelikecntcancel(int bnum, String userid) {
		//1)board =>likecnt - 1
		boarddao.updatelikecntcancel(bnum);
				
		//2)usermanage => state 1 변경
		Usermange usermange = new Usermange();
		usermange.setGubun("1"); //1:게시글, 2:댓글
		usermange.setNum(bnum); //게시글또는 댓글의 번호
		usermange.setUserid(userid); //회원ID
		usermange.setLikegubun("0"); //0:조회, 1:좋아요, 2:싫어요
			
		usermangedao.update(usermange);
		
	}
	
	//싫어요 +1
	@Transactional  //트랜잭션 걸어줌
	@Override
	public void updatedislikecnt(int bnum, String userid) {
		//1)board의 dislikecnt +1
		boarddao.updatedislikecnt(bnum);
		
		//2)usermange에 likegubun 1로 변경
		Usermange usermange = new Usermange();
		usermange.setGubun("1"); //1: 게시글 2:댓글
		usermange.setNum(bnum); //게시글 또는 댓글의 번호
		usermange.setUserid(userid);  //회원 아이디
		usermange.setLikegubun("2");  //0:조회, 1:좋아요, 2:싫어요
		
		usermangedao.update(usermange);
		
	}
	
	//싫어요 취소
	@Transactional  //트랜잭션 걸어줌
	@Override
	public void updatedislikecntcancel(int bnum, String userid) {
		//1)board =>likecnt - 1
		boarddao.updatedislikecntcancel(bnum);
					
		//2)usermanage => state 1 변경
		Usermange usermange = new Usermange();
		usermange.setGubun("1"); //1:게시글, 2:댓글
		usermange.setNum(bnum); //게시글또는 댓글의 번호
		usermange.setUserid(userid); //회원ID
		usermange.setLikegubun("0"); //0:조회, 1:좋아요, 2:싫어요
				
		usermangedao.update(usermange);
			
	}

	@Override
	public void updateremoveyn(int bnum) {
		
		boarddao.updateremoveyn(bnum);
	}
	
	
	

}
