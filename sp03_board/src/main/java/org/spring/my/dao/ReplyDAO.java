package org.spring.my.dao;

import java.util.List;
import java.util.Map;

import org.spring.my.dto.Reply;

public interface ReplyDAO {
	public void insert(Reply reply);
	public void updaterestep(Reply reply);
	public List<Map<String, Object>> selectlist(Map<String, Object> findmap);
	public void update(Reply reply);
	public void delete(int rnum);
}
