package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dao.PageDAO;
import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.Criteria;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("PageService")
public class PageServiceImpl implements PageService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> listWithPaging(Criteria cri) {
		log.info("@# PageServiceImpl listWithPaging");
		log.info("@# cri=>"+cri);
		
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		ArrayList<BoardDTO> list=dao.listWithPaging(cri);
		
		return list;
	}

	@Override
//	public int getTotalCount() {
	public int getTotalCount(Criteria cri) {
		log.info("@# PageServiceImpl getTotalCount");
		
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
//		int total=dao.getTotalCount();
		int total=dao.getTotalCount(cri);
		
		return total;
	}

}







