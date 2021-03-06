package org.spring.my.service;

import java.util.List;
import java.util.Map;

import org.spring.my.dto.Reply;

public interface ReplyService {
	public void insert(Reply reply);
	public List<Map<String, Object>> selectlist(int bnum, String userid);
	public void update(Reply reply);
	public void delete(int rnum);
}
