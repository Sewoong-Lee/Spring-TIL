<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 댓글 리스트 템플릿 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
<!-- 댓글 탬플릿 소스 -->
<script id="replylist_template" type="text/x-handlebars-template">
	{{#each .}}
     <table>
		<hr>
		<table border="1" id="rep{{RNUM}}">
		<tr>
			<td colspan="2">
				라이크구분:<input type="text" class="likegubun" id="likegubun{{RNUM}}"value="{{likegubun}}">
				<button class="btnreplike" id="btnreplike{{RNUM}}" value="{{RNUM}}">좋아요</button> : <span class="replikecnt" id="replikecnt{{RNUM}}">{{LIKECNT}}</span>
				<button class="btnreptislike">싫어요</button> : <span class="repdislikecnt">{{DISLIKECNT}}</span>
			</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><input type="text" class="repuserid" readonly value="{{USERID}}"></td>
		</tr>
		<tr>
			<th>내용</th>
			<td><textarea rows="3" cols="20" id="repcontent{{RNUM}}">{{CONTENT}}</textarea></td>
		</tr>
		<tr>
			<th>등록일자</th>
			<td>{{REGDATE}}</td>
		</tr>
		<tr>
			<th>수정일자</th>
			<td>{{MODIFYDATE}}</td>
		</tr>
		<tr>
			<td colspan="4" align="center"> 
				<input type="text" class="rnum" value="{{RNUM}}">
				<input type="hidden" class="restep" value="{{RESTEP}}">
				<input type="hidden" class="relevel" value="{{RELEVEL}}">
				
				{{#sessionCheck USERID}}				
				{{/sessionCheck}}
				<button class="btnrepadd">댓글</button>
			</td>
		</tr>
     </table>
     {{/each}}
</script>
<script type="text/javascript">
//헬퍼 작성(작성자만 수정 삭제 버튼 보이게)
//세션id와 작성자 id가 같은지 체크(같을때만 버튼을 리턴)
//sessionCheck : 헬퍼(함수)의 이름
//userid : 반복문 돌며 읽은 유저아이디
	Handlebars.registerHelper('sessionCheck', function(userid){
		var loginuserid = '${sessionScope.userid}';
		if (loginuserid == userid){
			//{{userid}} 로 넣으면 문자 자체로 인식해서 변수의 아이디를 넣음
			return '<button class ="btnrepupdate" value="'+userid+'">수정</button> ' +
					'<button class="btnrepdelete" value="'+userid+'">삭제</button>';
		}
		return '';

		
	});
	
/* 	//댓글의 날짜 형식 교체
	Handlebars.registerHelper('formatDate', function(date) {
		return new Date(date).toString('yyyy-MM-dd');
	}); */
</script>

<script type="text/javascript">
//좋아요 싫어요 버튼 제어 및 텍스트 변경
var likegubun = '${bfmap.board.likegubun}';
var sessionuserid = '${sessionScope.userid}';

function statechange() {
	if(likegubun == '0'){
		$('#btnlike').text('좋아요');
		$('#btntislike').text('싫어요');
	}else if(likegubun == '1'){ // 좋아요 선택
		$('#btnlike').text('좋아요 취소');
		$('#btntislike').text('싫어요');
	}else if(likegubun == '2'){
		$('#btnlike').text('좋아요');
		$('#btntislike').text('싫어요 취소');
	};
}

//댓글 삭제 수정 버튼 제어 (나중에...)
function buttonchange(userid) {
	if(sessionuserid == userid){
		$('.btnrepdelete').hide();
		$('.btnrepupdate').hide();
	}else{
		$('.btnrepdelete').show();
		$('.btnrepupdate').show();
	}

}


$(function() {
	//게시물 처리
	//좋아요 버튼을 클릭 했다면
	$('#btnlike').click(function() {
		alert(likegubun);
		if(likegubun == '0'){ //조회 상태일때만 좋아요/싫어요 가능
			//좋아요 처리
			//alert('좋아요');
			var bnum = '${bfmap.board.bnum}';
			console.log(bnum);
			
			$.ajax({
				url: '${path}/board/like/'+bnum,
				type: 'get',
				dataType: 'text',
				success: function(data){
					likegubun = '1'; //좋아요 상태로 변경
					//alert(data);
					statechange(); //버튼상태 변경
					//좋아요 +1
					$('#likecnt').text(parseInt($('#likecnt').text()) + 1); 
				},
				error: function(err){
					console.log(err);
					alert('실패');
				}
			});
		}else if(likegubun == '1'){ //좋아요 상태일때
			//좋아요 취소 처리
			//좋아요 취소 처리
			var bnum = '${bfmap.board.bnum}';
			console.log(bnum);
			$.ajax({
				url:'${path}/board/likecancel/'+bnum,
				type:'get',
				dataType:'text',
				success : function(data){
					state = '0'; //좋아요 상태
					statechange(); //버튼상태 변경
					//좋아요 수 - 1
					$('#likecnt').text(parseInt($('#likecnt').text()) - 1); 
					
				},
				error:function(err){
					console.log(err);
					alert('실패');
				}
			});
			
		}else if(likegubun == '2'){ //싫어요 취소 진행 메세지
			alert('싫어요 취소 후 가능');
		}
	});
	
	//싫어요 버튼을 눌렀을때
	$('#btntislike').click(function() {
		alert('싫어요');
		if(likegubun == '0'){
			//싫어요 처리
			var bnum = '${bfmap.board.bnum}';
			console.log(bnum);
			
			$.ajax({
				url: '${path}/board/dislike/'+bnum,
				type: 'get',
				dataType: 'text',
				success: function(data){
					likegubun = '2'; //싫어요 상태로 변경
					//alert(data);
					statechange(); //버튼상태 변경
					//싫어요 +1
					$('#dislikecnt').text(parseInt($('#dislikecnt').text()) + 1); 
				},
				error: function(err){
					console.log(err);
					alert('실패');
				}
			});
		}else if(likegubun == '2'){ //싫어요 상태일때
			//싫어요 취소 처리
			var bnum = '${bfmap.board.bnum}';
			console.log(bnum);
			$.ajax({
				url:'${path}/board/dislikecancel/'+bnum,
				type:'get',
				dataType:'text',
				success : function(data){
					state = '0'; //조회 상태
					statechange(); //버튼상태 변경
					//싫어요 수 - 1
					$('#dislikecnt').text(parseInt($('#dislikecnt').text()) - 1); 
					
				},
				error:function(err){
					console.log(err);
					alert('실패');
				}
			});
		}else if(likegubun == '1'){ //싫어요 취소 진행 메세지
			alert('좋아요 취소 후 가능');
		}
	});
	
	//원본글 삭제 버튼을 클릭 했을때
	$('#btndelete').click(function() {
		var userid = '${bfmap.board.userid}';
		//삭제 권한 체크
		if('${sessionScope.userid}' != userid){
			alert('삭제 권한 없음');
			return;
		};
		// 삭제 처리
		location.href='${path}/board/delete?bnum=${bfmap.board.bnum}';	
	});
	
	//게시물 수정
	//원본글의 수정 버튼을 클릭 했을때
	$('#btnupdateform').click(function() {
		var userid = '${bfmap.board.userid}';
		//삭제 권한 체크
		if('${sessionScope.userid}' != userid){
			alert('삭제 권한 없음');
			return;
		};
		// 삭제 처리
		location.href='${path}/board/modify?bnum=${bfmap.board.bnum}';	
	});
	
	//(리스트로 가즈아 버튼 클릭시) 조회폼으로 이동
	$('#btnlistmove').click(function() {
		location.href='${path}/board/list';	
	});
	
	
	//***************************************************************************************
	
//댓글 처리
//댓글 저장
//댓글 추가버튼을 클릭 했을때
$('#btnrepsave').click(function() {
	var bnum = ${bfmap.board.bnum};
	var content = $('#repcontent').val();
	var restep = $('#restep').val();
	var relevel = $('#relevel').val();
	console.log(bnum+'  '+repcontent+'  '+restep+'  '+relevel);
	
	//댓글 div를 이동 (댓글 리스트를 뿌릴때 댓글창은 사라짐)
	$('#replyadd').insertAfter('#rep0');
	$('#replyadd').hide();
	
	$.ajax({
		url:'${path}/reply/',  //restfull하게 설계
		type:'post',  //메소드 방식
		contentType:'application/json',  //보내는 데이터 타입
		data:JSON.stringify({bnum,content,restep,relevel}),  //보낼 데이터
		//dataType:'json', //서버에서 받는 타입
		dataType:'text', //서버에서 받는 타입
		success:function(data){
			console.log(data);
			//댓글 리스트 조회(아래 댓글리스트 조회 템플릿 펑션)
			//템플릿 소스 가져오기
			replylist();
			
		},
		error:function(err){
			console.log(err);
			alert('실패');
		}
		
	});
});
//댓글리스트 조회
function replylist() {

	var bnum = ${bfmap.board.bnum};
	
	$.ajax({
		url:'${path}/reply/list/'+bnum,  //restfull하게 설계
		type:'get',  //메소드 방식
		dataType:'json', //서버에서 받는 타입
		success:function(data){
			console.log(data);
			//댓글리스트 탬플릿을 이용해서 추가
			var source = $('#replylist_template').html();
			var template = Handlebars.compile(source);
	        $('#replist').html(template(data));
		},
		error:function(err){
			console.log(err);
			alert('실패');
		}
	});
};
//댓글 추가 이동
function repymove(restep, relevel, eleId) {
	$('#replyadd').show(); //댓글 폼 보이게
	$('#restep').val(restep);
	$('#relevel').val(relevel);
	$('#repcontent').val('');
	//댓글 추가 이동
	$('#replyadd').insertAfter(eleId);  //댓글 폼 이동 위치 받고 이동
};


//댓글 버튼을 클릭 했을때
//동적으로 생성된 엘리멘트에 이벤트 달기
$('#replist').on('click','.btnrepadd',function(){
	//alert('댓글 클');
	var restep = $(this).parent().find('.restep').val();
	var relevel = $(this).parent().find('.relevel').val();
	var rnum = $(this).parent().find('.rnum').val();
	console.log(rnum);
	
	$('#restep').val(restep);
	$('#relevel').val(relevel);
	
	//댓글 추가 이동
	//alert(restep +' '+ relevel +' '+ 'rep'+rnum);
	repymove(restep, relevel, '#rep'+rnum);
});

//원본의 댓글을 클릭 했을때 (0,0 으로 고정)
$('#btnrepadd').click(function(){
	//$('#restep').val(0);
	//$('#relevel').val(0);
	repymove(0, 0, "#rep0");
});

//댓글의 취소 버튼을 클릭했을때 하이드 하기
$('#btnrepreset').click(function () {
	$('#replyadd').hide();
});

//댓글 수정
$('#replist').on('click','.btnrepupdate',function(){
	//var content = $(this).parent().parent().parent().find('.repcontent').val();
	var userid = $(this).val();
	//alert(userid);
	//권한 체그
	if('${sessionScope.userid}' != userid){
		alert('작성자와 달라요');
		return;
	};
	var rnum = $(this).parent().find('.rnum').val();
	var content = $('#repcontent'+rnum).val();
	//alert(content);
	$.ajax({
		url:'${path}/reply/'+rnum,  //restfull하게 설계
		type:'put',  //메소드 방식 (수정은 put)
		contentType:'application/json',  //보내는 데이터 타입
		data:JSON.stringify({rnum, content}),  //보낼 데이터
		//dataType:'json', //서버에서 받는 타입
		dataType:'text', //서버에서 받는 타입
		success:function(data){
			console.log(data);
			alert(data);
		},
		error:function(err){
			console.log(err);
			alert('실패');
		}
	});
});

//댓글 삭제 버튼 클릭 했을때
$('#replist').on('click','.btnrepdelete',function(){
	//var content = $(this).parent().parent().parent().find('.repcontent').val();
	var userid = $(this).val();
	//alert(userid);
	//삭제 권한 체크
	if('${sessionScope.userid}' != userid){
		alert('작성자와 달라요');
		return;
	};
	var rnum = $(this).parent().find('.rnum').val();
	//alert(rnum);
	$.ajax({
		url:'${path}/reply/'+rnum,  //restfull하게 설계
		type:'DELETE',  //삭제 메소드 방식
		//contentType:'application/json',  //보내는 데이터 타입
		//data:JSON.stringify({rnum, content}),  //보낼 데이터
		dataType:'text', //서버에서 받는 타입
		success:function(data){
			//console.log(data);
			alert(data);
			replylist();
		},
		error:function(err){
			console.log(err);
			alert('실패');
		}
	});
});

//댓글의 좋아요 버튼 클릭했을때(나중에)
$('#replist').on('click','.btnreplike',function(){
	alert('댓글 조아여');
	var rnum = $(this).val();
	var likegubun = $('#likegubun'+rnum).val();
	alert(rnum + ' '+ likegubun);
	
	if(likegubun == '0'){ //조회 상태일때만 좋아요/싫어요 가능
		
		$.ajax({
			url: '${path}/reply/like/'+rnum,
			type: 'get',
			dataType: 'text',
			success: function(data){
				$('#likegubun'+rnum).val(1); //좋아요 상태
				$('#btnreplike'+rnum).html(like);
				//좋아요 + 1
				//alert(data);
				statechange(); //버튼상태 변경
				//좋아요 +1
				$('#replikecnt').text(parseInt($('#replikecnt').text()) + 1); 
			},
			error: function(err){
				console.log(err);
				alert('실패');
			}
		});
	}else if(likegubun == '1'){ //좋아요 상태일때
		//좋아요 취소 처리
		//좋아요 취소 처리
		var bnum = '${bfmap.board.bnum}';
		console.log(bnum);
		$.ajax({
			url:'${path}/board/likecancel/'+bnum,
			type:'get',
			dataType:'text',
			success : function(data){
				state = '0'; //좋아요 상태
				statechange(); //버튼상태 변경
				//좋아요 수 - 1
				$('#likecnt').text(parseInt($('#likecnt').text()) - 1); 
				
			},
			error:function(err){
				console.log(err);
				alert('실패');
			}
		});
		
	}else if(likegubun == '2'){ //싫어요 취소 진행 메세지
		alert('싫어요 취소 후 가능');
	}
});
//댓글의 싫어요 버튼 클릭했을때
$('#replist').on('click','.btnreptislike',function(){
	
});
//폼이 로딩이 완료된 후 ******************************************
replylist(); //댓글 리스트 불러오기
//buttonchange(userid); //세션 확인 후 삭제 수정버튼 제어

});


</script>
</head>
<body>

</body>
</html>