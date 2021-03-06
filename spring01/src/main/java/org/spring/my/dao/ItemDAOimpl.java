package org.spring.my.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.spring.my.dto.Item;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ItemDAOimpl implements ItemDAO{
	@Autowired
	SqlSession SqlSession;

	@Override
	public List<Item> selectlist(String itemcode) {
		
		return SqlSession.selectList("org.spring.my.ItemMapper.selectlist", itemcode);
	}
}
