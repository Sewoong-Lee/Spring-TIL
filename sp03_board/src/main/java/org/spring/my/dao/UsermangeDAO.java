package org.spring.my.dao;

import java.util.Map;

import org.spring.my.dto.Usermange;

public interface UsermangeDAO {
	public Usermange selectone(Usermange usermange);
	
	public void insert(Usermange usermange);
	
	public void update(Usermange usermange);

}
