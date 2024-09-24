<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	
<meta charset="UTF-8">
<title>Insert title here</title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/js/css/content.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/js/header/header.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/js/footer/footer.css">
</head>
<jsp:include page="../header.jsp"/>
<body>
<div class-"container">	
	<input type="hidden" name="boardNo" value="${pageMaker.boardNo}">
	<input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
	<input type="hidden" name="amount" value="${pageMaker.amount}">
<!--번호 ${content_view.boardNo}-->
	<div class="content_area">
		<div class="content_title_area">
			<h1>${content_view.boardTitle}</h1><br>
			ID: ${content_view.boardName}
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			조회수: ${content_view.boardHit}<br>
		</div>
		<div class="content_content_area">
			${content_view.boardContent}
		</div>
	</div>

	<div class="comment-write">
			<!-- <input type="text" id="commentWriter" placeholder="작성자"> -->
			 <!-- 작성자 ID 넘기기 -->
			<input type="text" id="commentWriter" placeholder="ID">
			<input type="text" id="commentContent" placeholder="댓글을 남겨보세요">
			<button onclick="commentWrite()">작성</button>
		</div>

	<div id="comment-list">
		<h4>댓글</h4>
			<c:forEach items="${commentList}" var="comment">
				<div class="comments">
					<p>ID: ${comment.commentWriter}</p>
					<div class="p2">
						<p>${comment.commentContent}</p>
					</div>
					<p>${comment.commentCreatedTime}에 작성</p>
				</div>
			</c:forEach>
	</div>
</div>
</body>
<jsp:include page="../footer.jsp"/>
	<script>
		const commentWrite = () => {
			const writer = document.getElementById("commentWriter").value;
			const content = document.getElementById("commentContent").value;
			const no = "${content_view.boardNo}";

			$.ajax({
				 type: "post"
				,data: {
					 commentWriter: writer
					,commentContent: content
					,boardNo: no
				}
				,url: "/comment/save"
				,success: function(commentList){
					console.log("작성성공");
					console.log(commentList);
					
					let output = "<div id='comment-list'>";
									output += "<h4>댓글</h4>";
									for (let i in commentList){
										output += "<div class='comments'>";
										output += "<p class='comment-id'>ID: "+commentList[i].commentWriter+"</p>";
										output += "<div class='p2'><p>"+commentList[i].commentContent+"</p></div>";
										let commentCreatedTime = commentList[i].commentCreatedTime.substring(0, 10)+" ";
										commentCreatedTime += parseInt(commentList[i].commentCreatedTime.substring(12, 13))+9;
										commentCreatedTime += commentList[i].commentCreatedTime.substring(13, 16);
										output += "<p class='comment-time'>"+commentCreatedTime+"에 작성</p>";
										output += "</div>";
									}
									output += "</div>";
						console.log("@# output=>"+output);

						document.getElementById("comment-list").innerHTML = output;
						document.getElementById("commentWriter").value = "";
						document.getElementById("commentContent").value = "";
				}
				,error: function(){
					console.log("실패");
				}
			});//end of ajax
		}//end of script
	</script>
	<script>
		$(document).ready(function (){
			// 즉시실행함수
			(function(){
				console.log("@# document ready");
				var boardNo = "<c:out value='${content_view.boardNo}'/>";
				console.log("@# boardNo=>"+boardNo);

				$.getJSON("/getFileList", {boardNo: boardNo}, function (arr){
					console.log("@# arr=>"+arr);

					var str="";

					$(arr).each(function (i, attach){
						//image type
						if (attach.image) {
							var fileCallPath = encodeURIComponent(attach.uploadPath +"/s_"+ attach.uuid + "_" + attach.fileName);
							str += "<li data-path='" + attach.uploadPath + "'";
							str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.image + "'"
							str + " ><div>";
							str += "<span>"+attach.fileName+"</span>";
							str += "<img src='/display?fileName="+fileCallPath+"'>";//이미지 출력 처리(컨트롤러단)
							// str += "<span data-file=\'"+ fileCallPath +"\'data-type='image'> x </span>";
							str += "</div></li>";
						} else {
							// var fileCallPath = encodeURIComponent(attach.uploadPath +"/"+ attach.uuid + "_" + attach.fileName);
							str += "<li data-path='" + attach.uploadPath + "'";
							str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.image + "'"
							str + " ><div>";
							str += "<span>"+attach.fileName+"</span>";
							str += "<img src='./resources/img/attach.png'>";
							// str += "<span data-file=\'"+ fileCallPath +"\'data-type='file'> x </span>";
							str += "</div></li>";						
						}
					});//end of arr each

					$(".uploadResult ul").html(str);
				});//end of getJSON

				$(".uploadResult").on("click", "li", function (e){
					console.log("@# uploadResult click");
					
					var liObj = $(this);
					console.log("@# path 01=>",liObj.data("path"));
					console.log("@# uuid=>",liObj.data("uuid"));
					console.log("@# filename=>",liObj.data("filename"));
					console.log("@# type=>",liObj.data("type"));
					
					var path = encodeURIComponent(liObj.data("path") +"/"+ liObj.data("uuid") + "_" + liObj.data("filename"));
					console.log("@# path 02=>",path);

					if (liObj.data("type")) {
						console.log("@# 01");
						console.log("@# view");

						showImage(path);
					} else {
						console.log("@# 02");
						console.log("@# download");

						//컨트롤러의 download 호출
						self.location="/download?fileName="+path;
					}
				});//end of uploadResult click

				function showImage(fileCallPath){
					// alert(fileCallPath);

					$(".bigPicture").css("display","flex").show();
					$(".bigPic")
						.html("<img src='/display?fileName="+fileCallPath+"'>")
						.animate({width: "100%", height: "100%"}, 1000);
				}

				$(".bigPicture").on("click", function (e){
					$(".bigPic")
						.animate({width: "0%", height: "0%"}, 1000);
					setTimeout(function (){
						$(".bigPicture").hide();
					}, 1000);//end of setTimeout
				});//end of bigPicture click
			})();
		});//end of document ready
	</script>
</html>






