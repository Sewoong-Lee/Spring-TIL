<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<title>지도</title>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7b432eae714388479ae3357175dbadc8&libraries=services,clusterer,drawing"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.js"></script>
	
<%@ include file="kakaoCss.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		
		//지도 위도, 경도
		var mapContainer = document.getElementById('map');
		var mapOption = {  
			center: new kakao.maps.LatLng(33.450701, 126.570667),//위도 경도 셋팅
			level: 3 //확대값 세팅
		};
		//지도 생성
		var map = new kakao.maps.Map(mapContainer, mapOption); 
		//var map = new kakao.maps.Map(container, options);
		
		
		function resizeMap() {
		    var mapContainer = document.getElementById('map');
		    mapContainer.style.width = '650px';
		    mapContainer.style.height = '650px'; 
		}
		
		//지도 다시 불러오기 함수
		function relayout() {    
		    
		    // 지도를 표시하는 div 크기를 변경한 이후 지도가 정상적으로 표출되지 않을 수도 있습니다
		    // 크기를 변경한 이후에는 반드시  map.relayout 함수를 호출해야 합니다 
		    // window의 resize 이벤트에 의한 크기변경은 map.relayout 함수가 자동으로 호출됩니다
		    map.relayout();
		}
		
		
		//마커 생성
		// 마커 위치
		var markerPosition  = new kakao.maps.LatLng(33.450701, 126.570667); 
		
		//마커 생성
		// 지도를 클릭한 위치에 표출할 마커입니다
		var marker = new kakao.maps.Marker({
			 // 지도 중심좌표에 마커를 생성합니다 
		    position: markerPosition
		});
		// 지도에 마커를 표시합니다
		marker.setMap(map);
		
		//마커 찍기
		var marker2 = new kakao.maps.Marker({ 
		    // 지도 중심좌표에 마커를 생성합니다 
		    position: map.getCenter() 
		}); 
		
		// 지도에 마커를 표시합니다
		marker2.setMap(map);
		
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
		    
		    // 클릭한 위도, 경도 정보를 가져옵니다 
		    var latlng = mouseEvent.latLng; 
		    
		    // 마커 위치를 클릭한 위치로 옮깁니다
		    marker2.setPosition(latlng);
		    
		    var message = '위도: ' + latlng.getLat() +'<br>';
		    message += '경도: ' + latlng.getLng();
		    
		    console.log(latlng.getLat());
		    
		    var resultDiv = document.getElementById('clickLatlng'); 
		    resultDiv.innerHTML = message;
		    
		});
		
		//인포위도우2
		var iwContent = '<div style="padding:5px;">카카오지도</div>', 
		    iwRemoveable = true; 
		
		var infowindow = new kakao.maps.InfoWindow({
			content : iwContent,
		    removable : iwRemoveable
		});
		
		// 마커에 클릭이벤트를 등록합니다
		kakao.maps.event.addListener(marker, 'click', function() {
		      // 마커 위에 인포윈도우를 표시합니다
		      infowindow.open(map, marker);  
		});
		
		
		//지도 이동
		function setCenter() {            
		var moveLatLon = new kakao.maps.LatLng(33.450701, 126.570667);
		map.setCenter(moveLatLon);
		}
		
		function panTo() {
			$('#floatDiv').hide();
			
			//위드 초기화
			$('.map_wrap').css('width','100%');
			
			//지도 초기화
			map.relayout();
			
			var moveLatLon = new kakao.maps.LatLng(33.450701, 126.570667);
			map.panTo(moveLatLon);
			
		}
		
		//지도 초기화 버튼 누르면
		$('#panTo').click(function() {
			panTo();
		});

		
		//엔터로 주소 검색
		$("#keyword").keypress(function(event){
		  if (event.which == '13') {
		      event.preventDefault();
		      serch();
		    }
		});
		
		//검색버튼 누르면
		$('#container').on('click','#btn',function(e) {
			e.preventDefault();
			serch();
		 });
		
		function serch() {
			
			
			var keyword = $('#keyword').val();
			var select1 = $('#select1').val();
			var select2 = $('#select2').val();
			console.log(select1 +' '+ select2 +' '+ keyword);
			
			if(select1 === '시 지역' || select2 === '구 지역'){
				alert('구역 선택 오류');
				return;
			}
			
			$.ajax({
				url:'/my/map/mapSerch',
				type:'get',  //메소드 방식
				data:{keyword, select1, select2},
				success:function(data){
					console.log(data[0]);
					$('#testDIV').html('<h2>' + data[0].BRAND_NAME+ '</h2>' + data[0].BRAND_NAME + data[0].BRAND_NAME);
					
					mar(data);
					showDIV(data);
					
				},
				error:function(err){
					console.log(err);
					alert('실패');
				}
				
			});
		}
		
		
		//검색 데이터로 마커 표시와 인포윈도우 이벤트 생성
		function mar(data) {
			// 마커를 표시할 위치와 title 객체 배열입니다 
			var num = 0.001000;
			var x = 33.450705;
			var y = 126.570677;
			var positions = [];
			$.each(data, function(i){
			positions[i] = 
				    {
				        content: '<div style="width:300px;padding:6px 0;">' + 
				        '<div class="infoNameBox">'+'<a class="infoName1">'+'공공문화시반시설'+' > </a>'+'<a class="infoName1">'+'도서관'+' ></a><br>'+
				        '<a class="infoName2">'+data[i].BRAND_NAME+'</a>'+'</div><br> '+
				        '<a class="infoAddr">'+data[i].ADDRESS+'</a><br>'+
				        '<a class="infoTel">연락처: '+data[i].TEL+'</a><br><br>'+
				        '<div style="text-align:center;">'+
				        '<img alt="이미지" src="imgs/unnamed.jpg" width="250px" height="150px" ></div></div>',

				        latlng: new kakao.maps.LatLng(x + num, y + num)
				    }
			num += 0.001000;
			});
			console.log('positions');
			console.log(positions);
			
			for (var i = 0; i < positions.length; i ++) {
			    // 마커를 생성합니다
			    var marker = new kakao.maps.Marker({
			        map: map, // 마커를 표시할 지도
			        position: positions[i].latlng, // 마커의 위치
			        
			        clickable: true // **마커를 클릭했을 때 지도의 클릭 이벤트가 발생하지 않도록 설정합니다
			    });
							    
			    // 마커에 표시할 인포윈도우를 생성합니다 
			    var infowindow = new kakao.maps.InfoWindow({
			        content: positions[i].content, // 인포윈도우에 표시할 내용
			        
			        removable : true // **removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다
			    });

			    // 마커에 이벤트를 등록하는 함수 만들고 즉시 호출하여 클로저를 만듭니다
			    // 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			    (function(marker, infowindow) {
			        // 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다 
			        kakao.maps.event.addListener(marker, 'click', function() {
			            infowindow.open(map, marker);
			            console.log('클릭');
			        });

			    })(marker, infowindow);
			}
			//해당 좌표로 이동
	     	var coords = new kakao.maps.LatLng(x + num, y + num);
	     	map.setCenter(coords);
		}
		
		//옆의 div를 보이게 변경
		function showDIV(data) {
			//옆의 div 보이게
			$('#floatDiv').show();
			//맵 위의 div 보이게
			$('#mapOnDiv').show();
			/* $('#mapDiv').css('width', '70%'); */
			$('.map_wrap').css('width', '73%');
			
			var listName = ['서울숲', '골목 빵집', '태종에게 화살을', '한성 교통', '복합 문화공간', '서울 무형']; 
			var listContent = '내용 공간';
			 
			var	itemStr = '<div><a id="itemStrTitle">지역 문화 콘텐츠</a>&nbsp;&nbsp;<a id="itemStrNum">'+data.length+'개</a></div>';
			
			for(var i=0;i<data.length;i++){
				itemStr += '<div class="outer" style="height:100px;"><div class="inner">'+
							'<div class="first"><img alt="이미지" src="'+'imgs/'+i+'.webp'+'" width="80px"></div>'+
							'<div class="innerDiv"><div class="second">'+ data[i].BRAND_NAME + '</div>'+
							'<div class="third">'+data[i].INTRO+'</div></div>'+
							'</div></div><hr>';
			};
			$("#listDiv").html(itemStr);
			$("#DIV1").html(data.length);
			$("#DIV2").html(data.length);
			
			//지도 다시 불러오기
			map.relayout();
		}
		
		//셀렉트 박스 옵션 변경
		var optStr = '<option>';
		$("#select1").change(function() {
			console.log($(this).val());
			
			 if($(this).val() == '서울시'){
				 optStr += '강남구'+'</option>' + '<option> 익선동 </option>';
            }else if($(this).val() == '부천시'){
            	optStr += '고강동'+'</option>' + '<option> 원종동 </option>';
            }
			$("#select2").append(optStr);
		});
		
	});
	</script>

</head>
<body>
<div id="container">
	<div id="searchDiv">
	<form action="" name="frm" id="frm" >
	<div style="display: flex; align-items: center;">
		<img alt="logo" src="imgs/캡처.PNG" style="margin-right: 10px;">

	    	<select id="select1" name="select1">
    			<option>시 지역</option>
    			<option>서울시</option>
    			<option>부천시</option>
	    	</select>
	    	<select id="select2" style="margin-right: 10px;" name="select2">
	    		<option>구 지역</option>
	    	</select>

	        <input type="text" value="성동문화재단" id="keyword" size="15" style="margin-right: 10px;" name="keyword">
	        <button id="btn" type="button" style="margin-right: 10px;">검색하기</button>
	        <input type="checkbox" id="checkbox" style="margin-right: 10px;"> 화면 내에서 검색하기
	        <button type="button" id="panTo" >지도 리셋</button>
	</div>
	    </form>
	</div>
	<br>
	
	<div id="mapDiv">
<div class="map_wrap">
    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
	    <div id="mapOnDiv" style="display:none;">
	    	<div style="margin: 5px;">
	    		<div style="display: flex;">
			    	<div><a id="mapOnDivTitle">서울특별시 성동구</a></div>
			    	<div id="mapOnDiv_Div">성동 문화원</div>
		    	</div>
		    	<div style="display: flex; margin-top: 3px;">
			    	<div>지역 문화 이야기 <a class="mapOnDiv_A" id="DIV1"></a>건  | </div>
			    	<div>지역 문화 정보 <a class="mapOnDiv_A" id="DIV2"></a>건</div>
		    	</div>
	    	</div>
	    </div>
	</div>
</div>

	<div id="floatDiv" style="display:none;">
	    <div id="listDiv"></div>
	</div>
	
	<div id="clickLatlng"></div>

</div>

	<div id="testDIV"></div>

</body>
</html>
