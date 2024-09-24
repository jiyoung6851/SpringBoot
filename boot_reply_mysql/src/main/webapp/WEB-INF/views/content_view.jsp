<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="boardNo" value="${content_view.boardNo}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.boardNo}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit}
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
<%-- 					${content_view.boardName} --%>
					<input type="text" name="boardName" value="${content_view.boardName}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
<%-- 					${content_view.boardTitle} --%>
					<input type="text" name="boardTitle" value="${content_view.boardTitle}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
<%-- 					${content_view.boardContent} --%>
					<input type="text" name="boardContent" value="${content_view.boardContent}">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정">
					&nbsp;&nbsp;<a href="list">목록보기</a>
					&nbsp;&nbsp;<a href="delete?boardNo=${content_view.boardNo}">삭제</a>
				</td>
			</tr>
		</form>
	</table>

	<div>
		<input type="text" id="commentWriter" placeholder="작성자">
		<input type="text" id="commentContent" placeholder="내용">
		<button onclick="commentWrite()">댓글작성</button>
	</div>
	
	<div id="comment-list">
		<table>
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
			</tr>
			<c:forEach items="${commentList}" var="comment">
				<tr>
					<td>${comment.commentNo}</td>
					<td>${comment.commentWriter}</td>
					<td>${comment.commentContent}</td>
					<td>${comment.commentCreatedTime}</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
<script>
	const commentWrite = () => {
			const writer = document.getElementById("commentWriter").value;
			const content = document.getElementById("commentContent").value;
			const no = "${content_view.boardNo}";
			
			$.ajax({
				type:"post"
				,data:{
					commentWriter : writer
					,commentContent : content
					,boardNo : no
				}
				,url:"/comment/save"
				,success: function(commentList){
					console.log("작성성공")
					console.log("commentList",commentList)
					
					let output = "<table>";
						output += "<tr><th>댓글번호</th>";
							output += "<th>작성자</th>";
							output += "<th>내용</th>";
							output += "<th>작성시간</th></tr>";
							for(let i in commentList){
								output += "<tr>";
									output += "<td>"+commentList[i].commentNo+"</td>";
									output += "<td>"+commentList[i].commentWriter+"</td>";
									output += "<td>"+commentList[i].commentContent+"</td>";
									// output += "<td>"+commentList[i].commentCreatedTime+"</td>";
									let commentCreatedTime = commentList[i].commentCreatedTime.substring(0,10)+" ";
									//commentCreatedTime += commentList[i].commentCreatedTime.substring(12,13)+" ";
									commentCreatedTime += parseInt(commentList[i].commentCreatedTime.substring(12,13))+9;
									commentCreatedTime += commentList[i].commentCreatedTime.substring(13,16);
									output += "<td>"+commentCreatedTime+"</td>";
									output += "</tr>";
								}
								output += "</table>";
								console.log("@# output => "+output);
								
								document.getElementById("comment-list").innerHTML = output;
								document.getElementById("commentWriter").value = "";
								document.getElementById("commentContent").value = "";
							}
							,error: function(){
					console.log("실패")
				}
			});//end of ajax
		}//end of script
	</script>
</html>