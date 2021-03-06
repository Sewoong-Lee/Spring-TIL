<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/includefile.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	
	$(function() {
		$('.alist').click(function(e) {
			e.preventDefault();  //버튼의 기본기능 제거
			var curpage = $(this).attr('href');
			var findkey = $('#findkey').val();
			var findvalue = $('#findvalue').val();
			
			//alert(findkey + findvalue);
			//alert(curpage);
			location.href = '${path}/board/list?curpage='+curpage+'&findkey='+findkey+'&findvalue='+findvalue;
		});
		
		//제목 클릭했을떄
		$('.asubject').click(function(e) {
			e.preventDefault();  //버튼의 기본기능 제거
			
/* 			//로그인 후 사용 가능
			if('${sessionScope.userid}' == ''){
				alert('로그인 후 사용 가능');
				location.href = '${path}/login';
				return;
			} */
			
			var bnum = $(this).attr('href');
			location.href = '${path}/board/detail?bnum='+bnum;
		});
	});


</script>
</head>
<body>
<%@ include file="../header.jsp" %>
<%-- ${blist} --%>
	<h2>게시물 리스트</h2>
	<form action="${path}/board/list">
		<select name="findkey" id="findkey">
			<option value="subject" ${page.findkey == 'subject' ? 'selected' : ''}>제목</option>
			<option value="content" ${page.findkey == 'content' ? 'selected' : ''}>내용</option>
			<option value="subcon" ${page.findkey == 'subcon' ? 'selected' : ''}>제목+내용</option>
			<option value="userid" ${page.findkey == 'userid' ? 'selected' : ''}>작성자</option>
		</select>
		<input type="text" name="findvalue" maxlength="10" value="${page.findvalue}" id="findvalue">
		<input type="hidden" name="curpage" value="1"><!-- 세션에 현재 페이지의 값이 저장되어 조회를 할 경우에 현재 페이지 초기화 -->
		<button>검색</button>
	</form>
	<table>
		<tr>
			<th>순번</th>
			<th>작성자</th>
			<th>제목</th>
			<th>조회수</th>
			<th>좋아요</th>
			<th>싫어요</th>
			<th>작성일</th>
		</tr>
		<c:forEach var="blist" items="${blist}">
		<tr>
			<td>${blist.bnum}</td>
			<td>${blist.USERID}</td>
			<td> <a href="${blist.bnum}" class="asubject">${blist.subject} (${blist.rcnt}) </a> </td>
			<td>${blist.readcnt}</td>
			<td>${blist.likecnt}</td>
			<td>${blist.dislikecnt}</td>
			<%-- <td><fmt:formatDate value="${blist.regdate}" pattern="yyyy.MM.dd" /></td> --%>
			<td>${blist.regdate}</td>
		</tr>
		</c:forEach>
	</table>
	<hr>
	<c:if test="${page.startpage != 1}">
		<a href="${page.startpage-1}" class="alist">이전</a>
	</c:if>
	
	<c:forEach var="i" begin="${page.startpage}" end="${page.endpage}">
		<c:if test="${page.curpage==i}">
			<a href="${i}" class="alist" id="acurpage">  ${i}  </a>
		</c:if>
		<c:if test="${page.curpage!=i}">
			<a href="${i}" class="alist">  ${i}  </a>
		</c:if>
	</c:forEach>
	
	<c:if test="${page.totpage > page.endpage}">
		<a href="${page.endpage+1}" class="alist">다음</a>
	</c:if>
</body>
</html>