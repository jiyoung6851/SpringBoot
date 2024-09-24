package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.dto.Criteria;
import com.boot.dto.PageDTO;
import com.boot.service.BoardService;
import com.boot.service.CommentService;
import com.boot.service.PageService;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class PageController {
	@Autowired
	private PageService service;
	
//	@RequestMapping("/listWithPaging")
	@RequestMapping("/list")
	public String listWithPaging(Criteria cri, Model model) {
		log.info("@# list");
		log.info("@# cri=>"+cri);
		
		ArrayList<BoardDTO> list = service.listWithPaging(cri);
//		int total = service.getTotalCount();
		int total = service.getTotalCount(cri);
		log.info("@# total=>"+total);
		
		model.addAttribute("list", list);
//		model.addAttribute("pageMaker", new PageDTO(123, cri));
		model.addAttribute("pageMaker", new PageDTO(total, cri));
		
		return "list";
	}
	
}
















