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
		
		$('#btnAjaxTest').click(function() {
			//alert('ajax 테스트');
			var userid = $('#userid').val();
			var age = $('#age').val();
			console.log(userid);
			console.log(age);
			//비동기 방식으로 text전송
			$.ajax({
				url:'/my/ajax/02_json', //매핑url
				type: 'post',//전송방식(get,post....)
				data:JSON.stringify({userid,age}), //제이슨 객체로 변경 //서버로 전송할 데이터 {userid:userid,age:age} 생략 가능
				contentType : 'application/json;charset=UTF-8',  //보낼 데이터 형태를 제이슨으로 변경
				dataType:'text', //서버에서 받아올 데이터의 형식 지정(html, xml , json, text)
				success:function(data){
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
	<h2> ajax 비동기 방식 (json데이터 전송)</h2>
	아이디:<input type="text" id="userid"> <br>
	나이:<input type="number" id="age"> <br>
	
	<button id="btnAjaxTest">ajax테스트</button>
</body>
</html>