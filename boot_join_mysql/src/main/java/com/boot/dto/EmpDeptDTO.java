package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EmpDeptDTO {
	//xml 정보뿐만 아니라 전체 테이블의 컬럼을 정의(개발시 유연성-DTO 공유 등)
	
	//emp table
	private int empno;
	private String ename;
	private String job;
	private int mgr;
	private Timestamp hiredate;
	private int sal;
	private int comm;
	
	//dept table
	private int deptno;
	private String dname;
	private String loc;
}