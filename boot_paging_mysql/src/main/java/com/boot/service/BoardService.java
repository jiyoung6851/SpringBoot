package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.BoardDTO;

public interface BoardService {
	public ArrayList<BoardDTO> list();
//	public void write(HashMap<String, String> param);
	public void write(BoardDTO boardDTO);
	public BoardDTO contentView(HashMap<String, String> param);
	public void modify(HashMap<String, String> param);
	public void delete(HashMap<String, String> param);
}

/*
 * 부분 나눠서 삭제
 * xml -> dao -> service 끝(테이블 삭제)
 * controller -> service 끝(저장파일 삭제)
 * 
 * 한번에 삭제
 * controller <-> xml
 */