package com.boot.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.EmpDeptDTO;

//실행시 매퍼파일을 읽어 들이도록 지정 여기서는 mybatis.mapper를 불러들임
@Mapper //spring boot에서는 dao에 mapper붙여야한다.
public interface EmpDeptDAO {
	public ArrayList<EmpDeptDTO> list();
}