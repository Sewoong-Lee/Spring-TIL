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
		//파일 추가버튼
		$('#btnfileadd').click(function(e) {
			//alert('추가');
			e.preventDefault();  //버튼의 기본기능 제거
			$('#filelist').append('<li><input type="file" name="files" class="files"><button class="btnfileremove">삭제</button></li>');
			
		});
		
		//파일 삭제버튼
		//폼이 완료된 이후 생선되 애들은 이벤트를 달아줄 수 없다.
		//동적으로 생성된 버튼에 이벤트 달기
		$('#filelist').on('click', '.btnfileremove', function(e) {
			e.preventDefault();
			//alert('삭제');
			
			//선택한 자신의 부모 단위를 삭제
			$(this).parent().remove();
			
		});
		
		//저장전 유효성 체크
		$('#btnupdate').click(function(e) {
			e.preventDefault();
			
			if($('#userid').val() == ''){
				alert('로그인을 해요.');
			}else if($('#subject').val() == ''){
				alert('제목 입력');
			}else if($('#content').val() == ''){
				alert('내용 입력');
			}else{
				modifyform.submit();
			}
				
		});
		
		
	});
	
</script>
</head>
<body>
	<h2>게시물 수정</h2>
	<form action="${path}/board/modify" method="post" name="modifyform" enctype="multipart/form-data">
	<table>
		<tr>
			<th>번호</th>
			<td> <input name="bnum" type="text" value="${bfmap.board.bnum}" readonly> </td>
		</tr>
		<tr>
			<th>작성자</th>
			<td> <input name="userid" type="text" value="${bfmap.board.userid}" id="userid" readonly> </td>
		</tr>
		<tr>
			<th>제목</th>
			<td> <input name="subject" type="text" value="${bfmap.board.subject}" id="subject" > </td>
		</tr>
		<tr>
			<th>내용</th>
			<td> <textarea name="content" id="content"  rows="5" cols="20">${bfmap.board.content}</textarea> </td>
		</tr>
		<tr>
			<th>기존 파일</th>
			<td> <c:forEach var="bflist" items="${bfmap.bflist}">
					<img alt="사진" src="${path}/uploadimg/${bflist.filename}" width="100">
					<input type="checkbox" name="filedelete" value="${bflist.fnum}">삭제
				</c:forEach> 
			</td>
		</tr>
		<tr>
			<th>파일 수정</th>
			<td>
			<div><button id="btnfileadd">파일 추가</button></div>
			<ol id="filelist">
				<li><input type="file" name="files" class="files"><button class="btnfileremove">삭제</button></li>
			</ol>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"> <button id="btnupdate">수정</button> </td>
		</tr>
	
	</table>
	</form>	
	
	
</body>
</html>