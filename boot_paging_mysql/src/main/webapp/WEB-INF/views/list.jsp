<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<style>
		.div_page ul{
			display: flex;
			list-style: none;
		}
	</style>
</head>
<body>
	<table width="500" border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>제목</td>
			<td>날짜</td>
			<td>히트</td>
		</tr>
<!-- 		list : 모델객체에서 보낸 이름 -->
		<c:forEach items="${list}" var="dto">
			<tr>
				<td>${dto.boardNo}</td>
				<td>${dto.boardName}</td>
<%-- 				<td>${dto.boardTitle}</td> --%>
				<td>
<!-- 			content_view : 컨트롤러단 호출 -->
					<!-- <a href="content_view?boardNo=${dto.boardNo}">${dto.boardTitle}</a> -->
					<a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>
				</td>
				<td>${dto.boardDate}</td>
				<td>${dto.boardHit}</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="5">
<!-- 			write_view : 컨트롤러단 호출 -->
				<a href="write_view">글작성</a>
			</td>
		</tr>
	</table>
	<form method="get" id="searchform">
		<select name="type">
			<option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/>>전체</option>
			<option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
			<option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
			<option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
			<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목 or 내용</option>
			<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/>>제목 or 작성자</option>
			<option value="TCW" <c:out value="${pageMaker.cri.type eq 'TCW' ? 'selected' : ''}"/>>제목 or 내용 or 작성자</option>
		</select>

		<!-- Criteria를 이용해서 키워드 값을 넘김 -->
		<input type="text" name="keyword" value="${pageMaker.cri.keyword}">
		<!-- <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}"> -->
		 <!-- 전체검색중 5페이지에서 22 키워드로 검색시 안나올때 처리 -->
		<input type="hidden" name="pageNum" value="1">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		<button>Search</button>
	</form>

	<h3>${pageMaker}</h3>
	<div class="div_page">
		<ul>
			<c:if test="${pageMaker.prev}">
				<li class="paginate_button">
					<a href="${pageMaker.startpage - 1}">
						[Previous]
					</a>
				</li> 
			</c:if>
			<c:forEach var="num" begin="${pageMaker.startpage}" end="${pageMaker.endpage}">
				<!-- <li>[${num}]</li> -->
				 <!-- 현재 페이지는 배경색 노란색으로 표시 -->
				<li class="paginate_button" ${pageMaker.cri.pageNum == num ? "style='background-color: yellow'" : ""}>
					<a href="${num}">
						[${num}]
					</a>
				</li>
			</c:forEach>
			<c:if test="${pageMaker.next}">
				<li class="paginate_button">
					<a href="${pageMaker.endpage + 1}">
						[Next]
					</a>
				</li> 
			</c:if>
		</ul>
	</div>

	<!-- 페이징 처리할 때 get방식 -->
	<form id="actionForm" method="get" action="list">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		<!-- 페이징 검색 시 페이지번호 클릭할 때 필요한 파라미터 -->
		<input type="hidden" name="type" value="${pageMaker.cri.type}">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
	</form>

</body>
</html>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
<script>
	var actionForm = $("#actionForm");

	//페이지 번호 처리
	$(".paginate_button a").on("click",function(e){
		//e.preventDefault : 기본 동작 막음 : 페이지 링크 통해서 이동
		e.preventDefault();
		console.log("click~!!!");
		console.log("@# href => "+$(this).attr("href"));
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});//end of paginate_button click
	
	//게시글 처리
	$(".move_link").on("click", function(e){
		e.preventDefault();
		
		console.log("move_link click~!!!");
		console.log("@# href => "+$(this).attr("href"));
		
		var targetBno = $(this).attr("href")

		// 게시글 클릭후 뒤로가기 누른 후 다른 게시글 클릭할때 boardNo 계속 누적되는거 방지
		// var bno = actionForm.find("input[name='boardNo']").val();
		// if(bno != ""){
		// 	actionForm.find("input[name='boardNo']"),remove();
		// }

		// "content_view?boardNo=${dto.boardNo}"를 actionForm 로 처리
		actionForm.append("<input type ='hidden' name='boardNo' value='"+targetBno+"'>");
		// actionForm.submit();
		actionForm.attr("action","content_view").submit();
	});//end of move_link click

/*
contentView => 페이지번호(클릭시) => 링크
contentView => 페이지번호(클릭시) + 페이징처리(cri 값들:페이지번호, amount) => actionForm.submit();
*/

	 var searchform = $("#searchform");
	//Search 버튼 클릭
	$("#searchform").on("click", function(){
		//alert("검색");
		if(!searchform.find("option:selectred").val()){
			alert("검색종류를 선택하세요.");
			return false;
		}

		searchform.attr("action","list").submit();
	});//end of searchform click
</script>