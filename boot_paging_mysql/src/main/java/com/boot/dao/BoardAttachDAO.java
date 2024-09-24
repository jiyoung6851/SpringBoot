package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BoardAttachDTO;
@Mapper
public interface BoardAttachDAO {
//	파일 업로드는 파라미터를 DTO 사용
	public void insertFile(BoardAttachDTO vo);
	public List<BoardAttachDTO> getFileList(int boardNo);
	public void deleteFile(String boardNo);
}

/*
 * controller <-> service <-> dao <-> dto
 * 
 * 1. 서비스를 만드는 경우(insert, select, delete)
 * 	- uploadService - 파일 저장 처리
 * 	- 같은 service <-> dao <-> DB
 * 
 * 2. 서비스를 만들지 않는 경우(insert)
 * */
