<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.js"></script>
<script type="text/javascript">
	$(function() {
		$('#btnajax').click(function() {
			//alert('에이젝스');
			//비동기 방식으로 text전송
			var usarid = $('#userid').val();
			var age = $('#age').val();
			$.ajax({
				url:'/my/ajax/01_text', //매핑 url
				type:'get', //전송방식(겟,포스트...)
				data:'userid='+ usarid +'&age='+age, //서버로 전송할 데이터
				contentType:'application/x-www-form-urlencoded; charset=UTF-8',  //보낼 데이터의 타입(기본 생략 가능)
				dataType:'text', //서버에서 받아올 데이터의 형식 (html,xml,json,text...)
				success:function(data){//성공했을때 실현할 펑션
					alert(data);
				},
				error:function(e){
					alert('실패');
				}
			});
			
			
			
		});
		
		
	});

</script>
</head>
<body>
	<h2> ajax 비동기 방식 (text 데이터 전송) </h2>
	아이디 <input type="text" id="userid"> <br>
	나이 <input type="number" id="age"> <br>
	<button id="btnajax">ajax테스트</button>

	
	
	
	
	
	
</body>
</html>