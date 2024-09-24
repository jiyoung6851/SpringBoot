package com.boot.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.EmpDeptDAO;
import com.boot.dto.EmpDeptDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("EmpInfoService")
public class EmpInfoServiceImpl implements EmpInfoService{
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<EmpDeptDTO> list() {
		log.info("@# EmpInfoServiceImpl list");
		
		EmpDeptDAO dao = sqlSession.getMapper(EmpDeptDAO.class);
//		model.addAttribute("list", dao.list());
		ArrayList<EmpDeptDTO> list=dao.list();
		
		return list;
	}
}
