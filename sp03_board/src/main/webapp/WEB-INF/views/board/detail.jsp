<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/includefile.jsp" %>
<%@ include file="../include/boaeddetail.jsp" %> <!-- 디테일 제이쿼리 -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- <script type="text/javascript" src="${psth}/resources/js/reply.js"></script> --%> <!-- 리소스 폴더 파일 불러오기 -->
</head>
<body>	
	세션 ${sessionScope.userid} <br>
	좋아요 구분 : ${bfmap.board.LIKEGUBUN}
	<h2>상세 조회</h2>
	순번 : <a >${bfmap.board.BNUM}</a> <br>
	조회수 : ${bfmap.board.READCNT} <br>
	<button id="btnlike">좋아요</button> : <span id="likecnt">${bfmap.board.LIKECNT}</span>
	<button id="btntislike">싫어요</button> : <span id="dislikecnt">${bfmap.board.DISLIKECNT}</span> <br>
	작성일 : <fmt:formatDate value="${bfmap.board.REGDATE}" pattern="yyyy-MM-dd HH:mm" /> <br>
	최근수정일 : <fmt:formatDate value="${bfmap.board.MODIFYDATE}" pattern="yyyy-MM-dd HH:mm" /> <br>
	작성자 : <a >${bfmap.board.USERID}</a> <br>
	제목 : ${bfmap.board.SUBJECT} <br>
	
	내용 : 
	<!-- 삭제라면 내용 -->
	<c:if test="${bfmap.board.REMOVEYN == 'y'}">
	<textarea rows="5" cols="10" name="content" id="content">삭제된 내용 입니다.</textarea><br>
	파일 : 
	<c:forEach var="file" items="${bfmap.bflist}">
		<img alt="삭제된 내용입니다." src="" width="100">
	</c:forEach>
	</c:if>
	
	<!-- 삭제가 아니라면 내용 -->
	<c:if test="${bfmap.board.REMOVEYN != 'y'}">
	<textarea rows="5" cols="10" name="content" id="content">${bfmap.board.CONTENT}</textarea><br>
	파일 : 
	<c:forEach var="file" items="${bfmap.bflist}">
		<img alt="사진" src="${path}/uploadimg/${file.filename}" width="100">
	</c:forEach>
	</c:if>
	<!-- 작성자만 수정 삭제 버튼 보이게 -->
	<c:if test="${bfmap.board.USERID == sessionScope.userid}">
		<button id="btnupdateform">수정</button>
		<button id="btndelete">삭제</button>
	</c:if>
	<button id="btnrepadd">댓글</button>
	<button id="btnlistmove">리스트로 가즈아~~~~</button>
	<hr id="rep0">
	<!-- 댓글 추가 -->
	<h3>댓글</h3>
	<div id="replyadd" hidden>
		<!-- 글 순서 --><input type="hidden" id="restep" value="0">
		<!-- 글 순서 --><input type="hidden" id="relevel" value="0">
		작성자 : <input type="text" id="repuserid" readonly value="${sessionScope.userid}"> <br>
		내용 : <textarea rows="3" cols="20" id="repcontent"></textarea>
		<button id="btnrepsave">저장</button>
		<button type="reset" id="btnrepreset">취소</button>
	</div>
	<!-- 댓글 리스트 -->
	<%-- ${replylist} --%>
	<div id="replist">
		
		
	</div>
	
	
	
	
	
	
</body>
</html>