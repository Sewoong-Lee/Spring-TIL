<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
<script id="template1" type="text/x-handlebars-template">
	<table>
		<tr>
		<th>상품코드</th>
		<th>상품이름</th>
		<th>가격</th>
		<th>등록일</th>
		</tr>

		 {{#each .}}
            <tr>
                <td>{{itemcode}}</td>
                <td>{{itemname}}</td>
                <td>{{price}}</td>
				<td>{{regdate}}</td>
            </tr>
         {{/each}}

	</table>
</script>
<script type="text/javascript">
	$(function() {
		$('#btn').click(function() {
			var itemcode = $('#itemcode').val();
			//alert(itemcode);
			
			$.ajax({
				url:'/my/ajax/04_list/'+itemcode,  //restfull한 설계
				type:'get', //get,post,put, delete
				//data:{itemcode},
				dataType:'json', //리턴받는 값이 json형태
				success:function(data){
					console.log(data);
					for(var i=0; i< data.length; i++){
						console.log(data[i].itemcode);
						console.log(data[i].itemname);
						console.log(data[i].price);
						console.log(data[i].regdate);
					};
					//템플릿 소스 가져오기
					 var source = $('#template1').html();
					 var template = Handlebars.compile(source);
		                //$('#itemlist').append(template(data));
		                $('div').html(template(data));

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
	<h2>상품 리스트 조회</h2>
	상품코드 <input type="text" id="itemcode">
	<button id="btn">조회</button>
	<div id="itemlist">
	
	
	</div>
</body>
</html>