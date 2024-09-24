package com.boot.dto;

import lombok.Getter;
import lombok.ToString;

//@Data
//@AllArgsConstructor
//@NoArgsConstructor
@Getter
@ToString
public class PageDTO {
	private int startpage;//시작페이지: 1, 11
	private int endpage;//끝페이지: 10, 20
	private boolean prev, next;
	private int total;
	private Criteria cri;//화면에 출력 갯수
	
	public PageDTO(int total, Criteria cri) {
		this.total = total;
		this.cri = cri;
		
//	    ex>3페이지=3/10->0.3 -> 1 * 10 = 10(끝페이지)
//	    ex>11페이지=11/10->1.1 -> 2 * 10 = 20(끝페이지)
		this.endpage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
//	    ex>10-9=1페이지
//	    ex>20-9=11페이지
		this.startpage = this.endpage - 9;
		
//	    ex>total: 70, 현재 페이지: 3 -> endPage: 10 => 70*1.0 / 10 => 7페이지
//	    ex>total: 300, 현재 페이지: 3 -> endPage: 10 => 300*1.0 / 10 => 30페이지
		int realEnd = (int)Math.ceil((total * 1.0) / cri.getAmount());
		
//	    ex>7페이지 <= 10페이지 : endPage: 7페이지
//	    ex>30페이지 <= 10페이지 : endPage: 10페이지
		if (realEnd <= this.endpage) {
			this.endpage = realEnd;
		}
		
//	    1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
		this.prev = this.startpage > 1;
		
//	    ex>10페이지 < 30페이지
		this.next = this.endpage < realEnd;
	}
	
	
}












