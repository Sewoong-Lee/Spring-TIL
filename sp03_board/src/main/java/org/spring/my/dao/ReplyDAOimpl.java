package org.spring.my.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.spring.my.dto.Reply;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReplyDAOimpl implements ReplyDAO{
	
	@Autowired
	private SqlSession SqlSession;
	
	
	@Override
	public void insert(Reply reply) {
		SqlSession.insert("org.spring.my.ReplyMapper.insert", reply);
		
	}


	@Override
	public void updaterestep(Reply reply) {
		SqlSession.update("org.spring.my.ReplyMapper.updaterestep", reply);
		
	}


	@Override
	public List<Map<String, Object>> selectlist(Map<String, Object> findmap) {
		
		return SqlSession.selectList("org.spring.my.ReplyMapper.selectlist", findmap);
	}


	@Override
	public void update(Reply reply) {
		SqlSession.update("org.spring.my.ReplyMapper.update", reply);
		
	}


	@Override
	public void delete(int rnum) {
		SqlSession.delete("org.spring.my.ReplyMapper.delete", rnum);
		
	}

}
