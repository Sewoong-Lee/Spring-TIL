package org.spring.my.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.spring.my.dto.Usermange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UsermangeDAOimpl implements UsermangeDAO{
	@Autowired
	private SqlSession SqlSession;

	@Override
	public Usermange selectone(Usermange usermange) {
		
		return SqlSession.selectOne("org.spring.my.UsermangeMapper.selectone", usermange);
	}

	@Override
	public void insert(Usermange usermange) {
		SqlSession.insert("org.spring.my.UsermangeMapper.insert", usermange);
		
	}
	
	//좋아요/싫어요
	@Override
	public void update(Usermange usermange) {
		SqlSession.update("org.spring.my.UsermangeMapper.update", usermange);
		
	}

	@Override
	public void pUpdateReadCnt(Usermange usermange) {
		SqlSession.update("org.spring.my.UsermangeMapper.pUpdateReadCnt", usermange);
		
	}

	
	
}
