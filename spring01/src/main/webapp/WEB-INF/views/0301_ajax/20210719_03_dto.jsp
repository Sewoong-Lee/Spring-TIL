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
		$('#btn').click(function() {
			var userid = $('#userid').val();
			console.log(userid);
			
			$.ajax({
				url:'/my/ajax/03_dto',
				type:'get',
				data:{userid},
				dataType:'json', //리턴받는 값이 json형태
				success:function(data){
					console.log(data);
					console.log(data.userid);
					//alert(data);
					
					$('#info').html('<li>'+data.userid+'</li>'); //기존에 있던거 없애기위해 html
					$('#info').append('<li>'+data.name+'</li>');
					$('#info').append('<li>'+data.passwd+'</li>');
				},
				error:function(err){
					console.log(err);
					alert('실패');
				}
			});
			
		});
	});

</script>
</head>
<body>
	<h2>ajax 비동기 방식 (dto 데이터 전송)</h2>
	아이디 <input type="text" id="userid">
	<button id="btn">조회</button>
	<hr>
	<div id="info">
	</div>
	
</body>
</html>