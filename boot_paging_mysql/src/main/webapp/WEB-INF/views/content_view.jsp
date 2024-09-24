<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<style>
	.uploadResult{
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul{
		display: flex;
		flex-flow: row;
	}
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	.uploadResult ul li img{
		width: 20px;
	}
</style>
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<table width="500" border=1>
		<form  method="post" action="modify">
			<input type="hidden" name="boardNo" value="${pageMaker.boardNo}">
			<input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
			<input type="hidden" name="amount" value="${pageMaker.amount}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.boardNo }
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit }
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="boardName" value="${content_view.boardName }">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle" value="${content_view.boardTitle }">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<input type="text" name="boardContent" value="${content_view.boardContent }">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정">
					<!-- &nbsp;&nbsp;<a href="list">목록보기</a> -->
					<!-- formaction="list" : name으로 설정된 값들을 가지고 이동 -->
					&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="list">
					<!-- &nbsp;&nbsp;<a href='delete?boardNo=${content_view.boardNo }'">삭제</a> -->
					&nbsp;&nbsp;<input type="submit" value="삭제" formaction="delete">
				</td>
			</tr>
		</form>
	</table>
	
	<!-- 첨부 파일 출력 공간-->
	File
	<div class="bigPicture">
		<div class="bigPic">

		</div>
	</div>
	<div class="uploadResult">
		<ul>

		</ul>
	</div>

	<div>
		<input type="text" id="commentWriter" placeholder="작성자">
		<input type="text" id="commentContent" placeholder="내용">
		<button type="button" onclick="commentWrite();">댓글작성</button>
	</div>
	<div id="comment-list">
		<table>
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
			</tr>
			<c:forEach items="${commentList }" var="comm">
				<tr>
					<td>${comm.commentNo }</td>
					<td>${comm.commentWriter }</td>
					<td>${comm.commentContent }</td>
					<td>
						<fmt:formatDate value="${comm.commentCreatedTime }" pattern="yyyy-MM-dd HH:mm" />
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
<script>
	const commentWrite = () => {
		const writer = document.getElementById("commentWriter").value;
		const content = document.getElementById("commentContent").value;
		const no = "${content_view.boardNo }";

		$.ajax({
			type: "post",
			data: {commentWriter : writer, commentContent: content, boardNo: no},
			url: "/comment/save",
			success: function(commentList) {
				console.log("작성성공");
				console.log(commentList);
				
				let output = "<table>";
					output+= "<tr>";
					output+= "<th>댓글번호</th>";
					output+= "<th>작성자</th>";
					output+= "<th>내용</th>";
					output+= "<th>작성시간</th>";
					output+= "</tr>";
					for(let i in commentList) {
						output+= "<tr>";
						output+= "<td>"+commentList[i].commentNo+"</td>";
						output+= "<td>"+commentList[i].commentWriter+"</td>";
						output+= "<td>"+commentList[i].commentContent+"</td>";
						//output+= "<td>"+commentList[i].commentCreatedTime+"</td>";
						let commentCreatedTime = commentList[i].commentCreatedTime.substring(0, 10)+" ";
							commentCreatedTime += (parseInt(commentList[i].commentCreatedTime.substring(12, 13))+9);
							commentCreatedTime += commentList[i].commentCreatedTime.substring(13, 16);
						output+= "<td>"+commentCreatedTime+"</td>";
						output+= "</tr>";
					}
					output+= "</table>";
					console.log("@# output=>"+output);
				//document.getElementById("comment-list").innerHTML(output);
				$("#comment-list").html(output);
				$("#commentWriter").val("");
				$("#commentContent").val("");

			},
			error: function() {
				console.log("작성실패");
			}
		});
	}
</script>
<script>
	$(document).ready(function(){
		//즉시 실행 함수
		(function(){
			console.log("@# document.ready");
			var boardNo = "<c:out value='${content_view.boardNo }'/>";
			console.log("@# boardNo=>"+boardNo);
			$.getJSON("/getFileList", {boardNo : boardNo}, function(arr) {
				console.log("@# arr => " + arr);

				var str = "";

				$(arr).each(function(i, attach){
					if(attach.image) {
					// image type
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
						str += "<li data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-path='"+attach.uploadPath+"' data-filename='"+attach.fileName+"' data-type='"+attach.image+"'><div>";
						// str += "<span>"+obj.fileName+"</span>";
						str += "<img src='/display?fileName="+fileCallPath+"'>" //이미지 출력 처리(컨트롤러단)
						// str += "<span data-file=\'"+fileCallPath+"\'data-type='image'> X </span>"; // 삭제 처리
						str += "</div></li>";
					} else {
						// var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
						str += "<li data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-path='"+attach.uploadPath+"' data-filename='"+attach.fileName+"' data-type='"+attach.image+"'<div>";
						str += "<span>"+attach.fileName+"</span>";
						str += "<img src='./resources/img/attach.png'>" //고정 이미지(attach.png) 출력 처리(컨트롤러단)
						// str += "<span data-file=\'"+fileCallPath+"\'data-type='file'> X </span>";
						str += "</div></li>";
					}
				}); // end of arr each

				$(".UploadResult ul").html(str);
			}); // end of json
			
			$(".uploadResult").on("click", "li", function(e) {
				console.log("@# uploadResult click");
				
				var liObj = $(this);
				console.log("@# path 01 => " + liObj.data("path"));
				console.log("@# uuid => " + liObj.data("uuid"));
				console.log("@# filename => " + liObj.data("filename"));
				console.log("@# type => " + liObj.data("type"));
				
				var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
				console.log("@# path 02 => " + path);


				if (liObj.data("type")) {
					console.log("@# 01");
					console.log("@# view");

					showImage(path);
				} else {
					console.log("@# 02"); 
					console.log("@# download"); 

					self.location="/download?fileName=" + path;
					// 컨트롤러의 다운로드
				}
			}); // end of uploadResult click
			function showImage(fileCallPath) {
				// alert(fileCallPath);

				$(".bigPicture").css("display", "flex").show;
				$(".bigPic").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width: "100%", height: "100%"}, 1000);
			}

			$(".bigPicture").on("click", function(e){
				$(".bigPic").animate({width: "0%", height: "0%"}, 1000);
				setTimeout(function(){
					$(".bigPicture").hide();
				}, 1000); // end of setTimeout
			}); // end of bigPicture click
		})();
	});// end of document ready
</script>
</html>