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
		
		
		
		/* //인포위도우
		var iwContent = '<div style="padding:5px;">카카오지도</div>', 
		    iwPosition = new kakao.maps.LatLng(33.450701, 126.570667),
		    iwRemoveable = true; 
		
		var infowindow = new kakao.maps.InfoWindow({
		    map: map, 
		    position : iwPosition, 
		    content : iwContent,
		    removable : iwRemoveable
		}); */
		
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

		
		//검색버튼 누르면 리스트 div 출력
		$('#container').on('click','#btn',function(e) {
			e.preventDefault();
			
			serch();
			
			showDIV();
/* 			serchJusoBtn();
			
			showDIV(); */
				
			
		 });
		
		
		function serch() {
			
			var juso = $('#keyword').val();
			
			$.ajax({
				url:'/my/map/mapSerch',
				type:'get',  //메소드 방식
				data:{juso},
				success:function(data){
					console.log(data[0]);
					$('#testDIV').html('<h2>' + data[0].BRAND_NAME+ '</h2>' + data[1].BRAND_NAME + data[2].BRAND_NAME);
					
					mar(data);
					
				},
				error:function(err){
					console.log(err);
					alert('실패');
				}
				
			});
		}
		
		
		function mar(data) {
			// 마커를 표시할 위치와 title 객체 배열입니다 
			var positions = [
			    {
			        content: '<div class="outer" style="height:100px;"><div class="inner">'+
								'<div class="first"><img alt="이미지" src="'+'imgs/.webp'+'" width="80px"></div>'+
								'<div class="innerDiv"><div class="second">'+ data[0].BRAND_NAME + '</div>'+
								'<div class="third">'+ data[0].INTRO +'</div></div>'+
								'</div></div><hr>', 
			        latlng: new kakao.maps.LatLng(33.450705, 126.570677)
			    },
			    {
			        content: '<div class="outer" style="height:100px;"><div class="inner">'+
			        			'<div class="first"><img alt="이미지" src="'+'imgs/.webp'+'" width="80px"></div>'+
								'<div class="innerDiv"><div class="second">'+ data[1].BRAND_NAME + '</div>'+
								'<div class="third">'+ data[1].INTRO +'</div></div>'+
								'</div></div><hr>', 
			        latlng: new kakao.maps.LatLng(33.450936, 126.569477)
			    },
			    {
			        content: '<div class="outer" style="height:100px;"><div class="inner">'+
			       				'<div class="first"><img alt="이미지" src="'+'imgs/.webp'+'" width="80px"></div>'+
								'<div class="innerDiv"><div class="second">'+ data[2].BRAND_NAME + '</div>'+
								'<div class="third">'+ data[2].INTRO +'</div></div>'+
								'</div></div><hr>', 
			        latlng: new kakao.maps.LatLng(33.450879, 126.569940)
			    },
			    {
			        content:  '<div class="outer" style="height:100px;"><div class="inner">'+
			        			'<div class="first"><img alt="이미지" src="'+'imgs/.webp'+'" width="80px"></div>'+
								'<div class="innerDiv"><div class="second">'+ data[1].BRAND_NAME + '</div>'+
								'<div class="third">'+ data[1].INTRO +'</div></div>'+
								'</div></div><hr>', 
			        latlng: new kakao.maps.LatLng(33.451393, 126.570738)
			    }
			];

			/* for (var i = 0; i < positions.length; i ++) {
			    // 마커를 생성합니다
			    var marker = new kakao.maps.Marker({
			        map: map, // 마커를 표시할 지도
			        position: positions[i].latlng // 마커의 위치
			    });

			    // 마커에 표시할 인포윈도우를 생성합니다 
			    var infowindow = new kakao.maps.InfoWindow({
			        content: positions[i].content // 인포윈도우에 표시할 내용
			    });

			    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
			    // 이벤트 리스너로는 클로저를 만들어 등록합니다 
			    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
			    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
			} */
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
			        });

			        // 마커에 mouseout 이벤트를 등록하고 마우스 아웃 시 인포윈도우를 닫습니다
			       /*  kakao.maps.event.addListener(marker, 'click', function() {
			            infowindow.close();
			        }); */
			    })(marker, infowindow);
			}
			//해당 좌표로 이동
	     	var coords = new kakao.maps.LatLng(33.450879, 126.569940);
	     	map.setCenter(coords);
		}
		
		function showDIV() {
			$('#floatDiv').show();
			/* $('#mapDiv').css('width', '70%'); */
			$('.map_wrap').css('width', '73%');
			
			var listName = ['서울숲', '골목 빵집', '태종에게 화살을', '한성 교통', '복합 문화공간', '서울 무형']; 
			var listContent = '내용 공간';
			 
			var	itemStr = '<div><a id="itemStrTitle">지역 문화 콘텐츠</a>&nbsp;&nbsp;<a id="itemStrNum">57개</a></div>';
			//$.each(results, function(i){};
			for(var i=0;i<listName.length;i++){
				/* itemStr += '<div>'+'<h4>' + '지역 이름'+i+'</h4>'+'</div>'+
				'<div>'+'<img alt="이미지" src="캡처.PNG">'+'</div>'+
				'<div>'+'설명'+'</div>'+'<hr>'; */
				
				itemStr += '<div class="outer" style="height:100px;"><div class="inner">'+
							'<div class="first"><img alt="이미지" src="'+'imgs/'+i+'.webp'+'" width="80px"></div>'+
							'<div class="innerDiv"><div class="second">'+ listName[i] + '</div>'+
							'<div class="third">'+listContent+'</div></div>'+
							'</div></div><hr>';
			};
			$("#listDiv").html(itemStr);
			
			//지도 다시 불러오기
			map.relayout();
		}
		
		//주소 검색 (단건)*********************************************************************
		// 주소-좌표 변환 객체를 생성합니다
		function serchJusoBtn() {			
			var geocoder = new kakao.maps.services.Geocoder();
			
			//주소 내용 가져오기
			var juso = $('#keyword').val();
			//alert(juso);
			console.log(juso);
			// 주소로 좌표를 검색합니다
			geocoder.addressSearch(juso, function(result, status) {
		
			    // 정상적으로 검색이 완료됐으면 
			     if (status === kakao.maps.services.Status.OK) {  //여기랑 아래 리줠트만 바꿔주면 될듯
		
			        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
				
			        // 결과값으로 받은 위치를 마커로 표시합니다
			        var marker = new kakao.maps.Marker({
			            map: map,
			            position: coords
			        });
		
			        // 인포윈도우로 장소에 대한 설명을 표시합니다
			        var infowindow = new kakao.maps.InfoWindow({
			            content: '<div style="width:300px;padding:6px 0;">' +
			            '<div class="infoNameBox">'+'<a class="infoName1">'+'공공문화시반시설'+' > </a>'+'<a class="infoName1">'+'도서관'+' ></a><br>'+
				        '<a class="infoName2">'+'공공도서관'+'</a>'+'</div><br> '+
				        '<a class="infoAddr">'+'서울특별시 성동구 왕십리광장로 17'+'</a><br>'+
				        '<a class="infoTel">연락처: '+'02-220-1357'+'</a><br><br>'+
				        '<div style="text-align:center;"><img alt="logo" src="'+'imgs/unnamed.jpg'+'" width="250px" height="150px" ></div></div>'
			        });
			        infowindow.open(map, marker);
		
			        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			        map.setCenter(coords);
			        //alert(coords);
			    }else{
			    	//결과가 안나오면 키워드 검색으로 이동
			    	SearchKeyword(juso);
			    	//alert('올바르지 않은 주소 입니다.');
			    } 
			});    
		}
		
		
		/* https://apis.map.kakao.com/web/sample/multipleMarkerEvent/ */
		//***키워드로 장소 검색
		// 장소 검색 객체를 생성합니다
		function SearchKeyword(juso) {
			var ps = new kakao.maps.services.Places(); 
			
			/* //주소 내용 가져오기
			var juso = $('#keyword').val();
			console.log('키워드 검색'+juso); */
			
			// 키워드로 장소를 검색합니다
			ps.keywordSearch(juso, placesSearchCB); 
			
			// 키워드 검색 완료 시 호출되는 콜백함수 입니다
			function placesSearchCB (data, status, pagination) {
			    if (status === kakao.maps.services.Status.OK) {
			
			        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
			        // LatLngBounds 객체에 좌표를 추가합니다
			        var bounds = new kakao.maps.LatLngBounds();
			
			        for (var i=0; i<data.length; i++) {
			            displayMarker(data[i]);    
			            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
			        }       
			
			        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
			        map.setBounds(bounds);
			    }else{
			    	alert('올바르지 않은 주소 입니다.');
			    } 
			}
			
			// 지도에 마커를 표시하는 함수입니다
			function displayMarker(place) {
			    
			    // 마커를 생성하고 지도에 표시합니다
			    var marker = new kakao.maps.Marker({
			        map: map,
			        position: new kakao.maps.LatLng(place.y, place.x) 
			    });
			    console.log("qqq");
			console.log(marker);
			    // 마커에 클릭이벤트를 등록합니다
			    kakao.maps.event.addListener(marker, 'click', function() {
			        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
			        /* infowindow.setContent('<div style="padding:5px;font-size:12px;">' +  */
			        infowindow.setContent('<div style="width:300px;padding:6px 0;">' + 
			        /* '<div class="infoName">'+place.place_name+'</div><br> '+ */
			        '<div class="infoNameBox">'+'<a class="infoName1">공공문화시반시설 > </a>'+'<a class="infoName1">도서관 ></a><br>'+
			        '<a class="infoName2">공공도서관</a>'+'</div><br> '+
			        '<a class="infoAddr">서울특별시 성동구 왕십리광장로 17</a><br>'+
			        '<a class="infoTel">연락처: 02-220-1357</a><br><br>'+
			        '<div style="text-align:center;"><img alt="logo" src="imgs/unnamed.jpg" width="250px" height="150px" ></div></div>');
			        
			        
			        infowindow.open(map, marker);
			    });
			}
		}
		
		//엔터로 주소 검색
		$("#keyword").keypress(function(event){
		  if (event.which == '13') {
		      event.preventDefault();
		      serchJusoBtn();
		    }
		});
		
		
		/* $("#keyword").keydown(function(key,e) {
			e.preventDefault;
			
		       if (key.keyCode == 13) {
		       	serchJusoBtn();
		       }
		}); */
			
		/* $(document).keypress(
		  function(event){
		    if (event.which == '13') {
		      event.preventDefault();
		    }
		}); */
		
		
		//셀렉트 박스 옵션 변경
		var optStr = '<option>';
		$("#select1").change(function() {
			console.log($(this).val());
			
			 if($(this).val() == '서울시'){
				 optStr += '강남구'+'</option>';
            }else if($(this).val() == '부천시'){
            	optStr += '고강동'+'</option>' + '<option> 원종동 </option>';
            }
			$("#select2").append(optStr);
		});
		
		
		
		//여러개의 마커에 이벤트 등록하기
		// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
		/* var positions = [
		    {
		        content: '<div>카카오</div>', 
		        latlng: new kakao.maps.LatLng(33.450705, 126.570677)
		    },
		    {
		        content: '<div>생태연못</div>', 
		        latlng: new kakao.maps.LatLng(33.450936, 126.569477)
		    },
		    {
		        content: '<div>텃밭</div>', 
		        latlng: new kakao.maps.LatLng(33.450879, 126.569940)
		    },
		    {
		        content: '<div>근린공원</div>',
		        latlng: new kakao.maps.LatLng(33.451393, 126.570738)
		    }
		];

		for (var i = 0; i < positions.length; i ++) {
		    // 마커를 생성합니다
		    var marker = new kakao.maps.Marker({
		        map: map, // 마커를 표시할 지도
		        position: positions[i].latlng // 마커의 위치
		    });

		    // 마커에 표시할 인포윈도우를 생성합니다 
		    var infowindow = new kakao.maps.InfoWindow({
		        content: positions[i].content // 인포윈도우에 표시할 내용
		    });

		    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
		    // 이벤트 리스너로는 클로저를 만들어 등록합니다 
		    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
		    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
		    kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
		}

		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
		    return function() {
		        infowindow.open(map, marker);
		    };
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
		    return function() {
		        infowindow.close();
		    };
		} */

		/* 아래와 같이도 할 수 있습니다 */
		/*
		for (var i = 0; i < positions.length; i ++) {
		    // 마커를 생성합니다
		    var marker = new kakao.maps.Marker({
		        map: map, // 마커를 표시할 지도
		        position: positions[i].latlng // 마커의 위치
		    });

		    // 마커에 표시할 인포윈도우를 생성합니다 
		    var infowindow = new kakao.maps.InfoWindow({
		        content: positions[i].content // 인포윈도우에 표시할 내용
		    });

		    // 마커에 이벤트를 등록하는 함수 만들고 즉시 호출하여 클로저를 만듭니다
		    // 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
		    (function(marker, infowindow) {
		        // 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다 
		        kakao.maps.event.addListener(marker, 'mouseover', function() {
		            infowindow.open(map, marker);
		        });

		        // 마커에 mouseout 이벤트를 등록하고 마우스 아웃 시 인포윈도우를 닫습니다
		        kakao.maps.event.addListener(marker, 'mouseout', function() {
		            infowindow.close();
		        });
		    })(marker, infowindow);
		}
		*/
		
		
		
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
	    <div id="mapOnDiv">
	    	<div style="margin: 5px;">
	    		<div style="display: flex;">
			    	<div><a id="mapOnDivTitle">서울특별시 성동구</a></div>
			    	<div id="mapOnDiv_Div">성동 문화원</div>
		    	</div>
		    	<div style="display: flex; margin-top: 3px;">
			    	<div>지역 문화 이야기 <a class="mapOnDiv_A">15</a>건  |</div>
			    	<div>지역 문화 정보 <a class="mapOnDiv_A">42</a>건</div>
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
	${listmap}
	<div id="testDIV"></div>

</body>
</html>
