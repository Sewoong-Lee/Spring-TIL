package org.spring.my.service;

import java.util.List;
import java.util.Map;

import org.spring.my.dto.Board;
import org.spring.my.dto.Page;

public interface BoardService {

	public void insert(Board board);

	public List<Board> selectlist(Page page);

	public Map<String, Object> selectone(int bnum, String userid);

	public void readcountadd(int bnum, String userid);
	
	public void updatelikecnt(int bnum, String userid);
	
	public void updatelikecntcancel(int bnum, String userid);

	public void updatedislikecnt(int bnum, String userid);

	void updatedislikecntcancel(int bnum, String userid);

	public void updateremoveyn(int bnum);

}
