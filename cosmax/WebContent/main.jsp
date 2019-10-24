<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page import="com.crystaldecisions.sdk.occa.security.IUserInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="conJCO" class="com.jco.ConnectionJCO" scope="application"/>
<%
	Logger logger = Logger.getLogger(this.getClass());

	MenuService menu = null;
	
	String logonToken = "";

	if(session.getAttribute("userInfo") == null) {
		logger.debug("세션이 없어짐");
		response.sendRedirect("logoutPrc.jsp?closeYN=Y&msg=" + URLEncoder.encode("세션이 종료되었습니다. 재접속 해주십시오.","UTF-8"));
	} else {			
	    String userid = (session.getAttribute("ZEIS_USER_ID") == null) ? "" : session.getAttribute("ZEIS_USER_ID").toString();
		String langu = (session.getAttribute("ZDEFALUT_LANGU") == null) ? "" : session.getAttribute("ZDEFALUT_LANGU").toString();
				
		logger.debug("userid: " + userid);
		logger.debug("langu: " + langu);
		
		menu = new MenuService();
		
		// 메뉴 조회.
		Vector<MenuInfo> vlist = menu.getMenu(conJCO, userid, langu);	
		// Sub메뉴 객체
		Vector<MenuInfo> slist = new Vector<MenuInfo>();	
		
		//시작화면 세팅
		MenuInfo startMInfo = menu.getStartMenu(vlist);
		
		session.setAttribute("vlist", vlist);
		session.setAttribute("startMInfo", startMInfo);
		logger.debug("vlist-session: " + session.getAttribute("vlist"));
		
		MenuInfo MInfo = null;
		MenuInfo SMInfo = null;
		
		int lv_llv_size = 0;
		int lv_llv_sub_size = 0;
		
		logger.debug("vlist.size() : " + vlist.size());
	
		
		// 전체 메뉴에서 1Lv 갯수. 2Lv, 3Lv의 메뉴 다른 Vector에 담는다. + 초기화면 세팅
		for(int i = 0 ; i < vlist.size() ; i++) {
			MInfo = (MenuInfo)vlist.elementAt(i);
			
			// lLv의 갯수 조회.		
			if( MInfo.getZLEVEL2().equals("00") && MInfo.getZLEVEL3().equals("00")) {			
	// 		if( MInfo.getZLEVEL2().equals("00") && MInfo.getZLEVEL3().equals("00") && MInfo.getZNODE_TYPE().equals("F")) {
				lv_llv_size++;
			} else { // 서브의 갯수 조회.	
				lv_llv_sub_size++;
			}
			
			// 2Lv, 3Lv의 메뉴를 sublist에 담는다.
			if( (!MInfo.getZLEVEL2().equals("00") || !MInfo.getZLEVEL3().equals("00")) ) {
				slist.addElement(MInfo);
			}												
		}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head> 
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> --> 
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> -->
<title>Cosmax EIS</title>
<link rel="stylesheet" href="css/style.css" />
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/lnb.js"></script>
<script src="js/tree2_cookie.js" type="text/javascript"></script>
<script src="js/tree2_treeview.js" type="text/javascript"></script>
<script src="js/tree2_demo.js" type="text/javascript"></script>
<script src="js/jquery-ui.js"></script>
<style type="text/css">
body {
	margin-left: 0px;
	margin-top: 0px;
}
</style>

<script type="text/javascript">
	var init = ""; // 페이지 초기여부 변수
	var selectTopMenuId = ""; //1~10 (1~9는 한자리수임)
	
	/**
	* 상단 메뉴 선택 시 호출	
	* - 선택 메뉴의 이미지 활성화	
	* - 선택된 메뉴에 해당되는 좌측 메뉴 보이게 변경(그외는 숨김)	
	*/
	function fn_div_display(id) {
		selectTopMenuId = id;
		fn_left_display("left");		
		var lv_div_id = ""; // div tag ID
		var lv_li_id = "";  // li tag ID
		var lv_img_id = ""; // li tag Bg Img ID

		//for(var i = 1 ; i <= <%=lv_llv_size%> ; i++) {
		for(var i = 2 ; i <= <%=lv_llv_size + 1%> ; i++) { // 메인페이지때문에 순번이 2부터 시작함
			
			// 각레벨별 메뉴ID가 2자리이므로 for문의 한자리수를 2자리로 padding처리(ex: '1' -> '01')
			if(i<10) { 
				lv_div_id = "div_0" + i;
				lv_li_id = "0" + i;
				lv_img_id = "0" + i;
			} else {
				lv_div_id = "div_" + i;
				lv_li_id = i;
				lv_img_id = i;
			}	
		
			// 선택한 메뉴인 경우
			if(i == Number(id)) {																
				$("#li_"+lv_li_id).addClass('active'); // 헤더 메뉴 선택 시 강조					
				$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+i+"_off"); // 헤더 메뉴 Bg이미지 변경(어두운 이미지)
				$("#li_"+lv_li_id).addClass("top_menu_bgimg"+i+"_on");     // 헤더 메뉴 Bg이미지 변경(밝은 이미지)				
				$("div[id^='"+lv_div_id+"']").css("display", "block");     // 좌측 메뉴 lv_div_id로 시작되는 div는 보이게 하기
				
			// 선택한 메뉴가 아닌 경우				
			} else {				
				$("#li_"+lv_li_id).removeClass('active'); // 헤더 메뉴 선택 시 강조 제거		
				$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+i+"_on"); // 헤더 메뉴 Bg이미지 변경(밝은 이미지)
				$("#li_"+lv_li_id).addClass("top_menu_bgimg"+i+"_off");   // 헤더 메뉴 Bg이미지 변경(어두운 이미지)
				$("div[id^='"+lv_div_id+"']").css("display", "none");     // 좌측 메뉴 lv_div_id로 시작되는 div는 숨김
			}			
		}
	}
		
	/**
	* 상단 메뉴에 마우스 over 및 out	
	* - 선택 메뉴의 이미지 활성화	
	* - 기존에 클릭해서 활성화된 메뉴는 계속 활성화되게 유지	
	*/		
	function fn_div_mouseover(onoff, id) {
		var lv_li_id = "";
		
		// 각레벨별 메뉴ID가 2자리이므로 for문의 한자리수를 2자리로 padding처리(ex: '1' -> '01')
		if(id < 10) {					
			lv_li_id = "0" + id;					
		} else {					
			lv_li_id = id;
		}		
		
		//마우스 오버인 경우
		if(onoff == 1) {		
			$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+id+"_off"); // 헤더 메뉴 Bg이미지 변경(어두운 이미지)
			$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+id+"_on");  // 헤더 메뉴 Bg이미지 변경(밝은 이미지)
			$("#li_"+lv_li_id).addClass("top_menu_bgimg"+id+"_on");	    // 헤더 메뉴 Bg이미지 변경(밝은 이미지)
			
	    //마우스아웃( 기존에 선택된 것은 그대로 보정 )
		} else if(onoff == 2 & selectTopMenuId != id) {
			
			$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+id+"_on");  // 헤더 메뉴 Bg이미지 변경(밝은 이미지)
			$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+id+"_off"); // 헤더 메뉴 Bg이미지 변경(어두운 이미지)
			$("#li_"+lv_li_id).addClass("top_menu_bgimg"+id+"_off");    // 헤더 메뉴 Bg이미지 변경(어두운 이미지)
		}
	}
	
	/**
	* 좌측 서브메뉴에서 폴더인 경우 클릭 시 하위 메뉴 접었다 펼치기	
	*/	
	function fn_sub_div_display(lv1, lv2) {

		//선택한 메뉴가 펼쳐져 있는 경우에서 접는 것으로 변경 -> 접는 이미지로 변경
		if ($("#div_"+lv1 + lv2).attr("class") == "left_btn_on") {
			$("#div_"+lv1 + lv2).removeClass('left_btn_on');
			$("#div_"+lv1 + lv2).addClass('left_btn_off');
		
		//선택한 메뉴가 접어 있는 경우에서 펼치는 것으로 변경 -> 펼치는 이미지로 변경			
		} else {
			$("#div_"+lv1 + lv2).removeClass('left_btn_off');
			$("#div_"+lv1 + lv2).addClass('left_btn_on');
		}
		
		var lv_m_1 = "";
		var lv_m_2 = "";
		var lv_m_3 = "";

<%
// 전메뉴 for문 실행
for(int i = 0 ; i < vlist.size() ; i++) {
	MInfo = (MenuInfo)vlist.elementAt(i);
	
	//3Lev이며 화면레벨인 경우
	if ("U".equals(MInfo.getZNODE_TYPE()) && !"00".equals(MInfo.getZLEVEL3())) {
%>
		lv_m_1 = "<%=MInfo.getZLEVEL1()%>";
		lv_m_2 = "<%=MInfo.getZLEVEL2()%>";
		lv_m_3 = "<%=MInfo.getZLEVEL3()%>";
		
		if(lv1 == lv_m_1 && lv2 == lv_m_2) {
			
			//선택한 메뉴가 펼쳐져 있는 경우에서 접는 것으로 변경 -> 하위메뉴 숨김
			if ($("#div_"+lv1 + lv2).attr("class") == "left_btn_on") {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).css("display", "none");   // 숨김.
				
				//선택한 메뉴가 접어 있는 경우에서 펼치는 것으로 변경 -> 하위메뉴 보이게 표시			
			} else {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).css("display", "block");   // 보이기
			}
		}
<%
	} //if문
} // for문
%>		
		
	}


	/**
	* 좌측 메뉴 보임, 숨김 처리
	* - 좌측 메뉴의 표시여부에 따라 iframe(Dashboard영역) 사이즈 조절
	*/		
	function fn_left_display(gubun) {	
		
		// 좌측메뉴가 숨김인 경우(초기화면이며 첫화면이 메인인 경우에 init값이 전송됨)
		if(gubun == "init") { 
			init = "init";
			fn_win_size("init", "fn_left_display if");          // 메인페이지 사이즈로 iframe설정
			$("div[id ='left']").css("display", "none");        // 좌측 메뉴 전부 숨김
			$("#div_dashboard").attr('class', 'main_content');  // iframe(Dashboard영역) css-class를 메인페이지용으로 변경
			
			var lv_li_id = "";
			//for(var i = 1 ; i <= <%=lv_llv_size%> ; i++) {
			for(var i = 2 ; i <= <%=lv_llv_size + 1%> ; i++) { // 메인페이지때문에 순번이 2부터 시작함		
				
				// 각레벨별 메뉴ID가 2자리이므로 for문의 한자리수를 2자리로 padding처리(ex: '1' -> '01')
				if(i<10) {					
					lv_li_id = "0" + i;	
				} else {					
					lv_li_id = i;
				}

				$("#li_"+lv_li_id).removeClass('active'); 					// 상단 메뉴 강조 전부 비활성화		
				$("#li_"+lv_li_id).removeClass("top_menu_bgimg"+i+"_on");   // 상단 메뉴 Bg이미지 전부 어두운것으로 변경		
				$("#li_"+lv_li_id).addClass("top_menu_bgimg"+i+"_off");     // 상단 메뉴 Bg이미지 전부 어두운것으로 변경	
			}
			
        // 좌측 메뉴가 표시되는 경우			
		} else {
			init = "subPage";
			fn_win_size("subPage", "fn_left_display else"); // 서브페이지 사이즈로 iframe설정
			$("div[id ='left']").css("display", "block");   // 좌측메뉴 보이게 표시	
			$("#div_dashboard").attr('class', 'content');   // iframe(Dashboard영역) css-class를 서브페이지용으로 변경 
		}
	}
	
	/**
	* 화면로딩시 자동실행하는 함수
	* - 첫시작화면이 MAIN인 경우에는 메인페이지로 화면을 구성하고 그외는 서브페이지로 구성
	*/	
	function fn_init() {		
		selectTopMenuId = ""; // 메뉴 초기화
		
		var lv1 = '<%=startMInfo.getZLEVEL1()%>';		
		var lv2 = '<%=startMInfo.getZLEVEL2()%>';
		var lv3 = '<%=startMInfo.getZLEVEL3()%>';	 
		var iDocID = '<%=startMInfo.getZPARAM()%>'; 
		var PMENUID = '<%=startMInfo.getZURL()%>';  
		var PDATE = '<%=startMInfo.getZEIS_DATE()%>';
		var PLANGU = '<%=langu%>';
		var url = "goPage.jsp?iDocID=" + iDocID;
		
		
		// 메인화면인 경우
		if (PMENUID == 'MAIN') {
			fn_left_display("init");
			fn_gopage(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU);
			
		// 서브화면인 경우
		} else {
			fn_div_display(lv1);
			fn_gopage(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU);				
		}
	}
	
	/**
	* iframe(Dashboard)영역의 URL 변경
	* - 선택된 메뉴의 좌측메뉴 하이라이트 및 보이게 하기
	*/	
	function fn_gopage(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU) {

		// 메인이 아닌 경우
		if (PMENUID != "MAIN") { 
			fn_menuChange(lv1, lv2, lv3); // 좌측 선택된것 보이기
		}
 		
		// iframe(Dashboard)영역의 URL 변경
		var url = "goPage.jsp?iDocID="+iDocID+"&PMENUID="+encodeURI(encodeURIComponent((PMENUID)))+"&PDATE="+PDATE+"&PLANGU="+PLANGU;
 		$('#dashboard').attr('src', url);
	}
	
	/**
	* 선택된 메뉴의 좌측메뉴 하이라이트 및 보이게 하기
	*/	
	function fn_menuChange(lv1, lv2, lv3) {		
		var lv_id_1 = "div_"+lv1;
		var lv_id_2 = "div_"+lv1+lv2;
		var lv_id_3 = "div_"+lv1+lv2+lv3;
		
		var lv_m_1 = "";
		var lv_m_2 = "";
		var lv_m_3 = "";

<%
// 전체 메뉴 for문
for(int i = 0 ; i < vlist.size() ; i++) {
	MInfo = (MenuInfo)vlist.elementAt(i);
	
	// 화면레벨인 경우
	if ("U".equals(MInfo.getZNODE_TYPE())) {
%>
		lv_m_1 = "<%=MInfo.getZLEVEL1()%>";
		lv_m_2 = "<%=MInfo.getZLEVEL2()%>";
		lv_m_3 = "<%=MInfo.getZLEVEL3()%>";
		
		//선택된 메뉴와 일치하는 경우
		if(lv1 == lv_m_1 && lv2 == lv_m_2 && lv3 == lv_m_3) {
			
			//2Level 화면의 경우
			if(lv3 == "00") {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).removeClass("left_btn_off_2lv"); // 해당 메뉴 활성화
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).addClass("left_btn_on_2lv");     // 해당 메뉴 활성화
			
			//3Level 화면의 경우
			} else {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).removeClass("left_btn_off_3lv"); // 해당 메뉴 활성화
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).addClass("left_btn_on_3lv");     // 해당 메뉴 활성화
			}
			
		//선택된 메뉴와 일치하지 않는 경우			
		} else {			
			
			//2Level 화면의 경우
			if(lv_m_3 == "00") {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).removeClass("left_btn_on_2lv"); // 해당 메뉴 비활성화
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).addClass("left_btn_off_2lv");   // 해당 메뉴 비활성화
				
				//3Level 화면의 경우
			} else {
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).removeClass("left_btn_on_3lv"); // 해당 메뉴 비활성화
				$("#div_"+lv_m_1+lv_m_2+lv_m_3).addClass("left_btn_off_3lv");   // 해당 메뉴 비활성화
			}					
		}		
<%
	} //if문
} // for문
%>
	} // fn_menuChange function 종료
	
	/**
	* DashBoard 내부에서 다른 메뉴로 이동시 이동한 메뉴에 하이라이트 및 보임 처리
	*/	
	function fn_menuChangeLink(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU) {

		// 이동하는 화면이 메인인 경우
		if (PMENUID == 'MAIN') {
			fn_left_display("init");
			fn_gopage(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU);

		// 이동하는 화면이 서브인 경우			
		} else {
			fn_div_display(lv1);
			fn_gopage(lv1, lv2, lv3, iDocID, PMENUID, PDATE, PLANGU);				
		}	
	}


	/**
	* 화면 사이즈 변경에 따라 계산하여 Iframe(DashBoard영역) 사이즈 변경
	* - 메인 및 서브 각각 사이즈 다르게 산정(좌측메뉴 영역 영향)
	* - 화면의 비율을 맞추기 위해 높이 기준으로 산정
	*/		
	function fn_win_size(init, callFunction) {
		//alert("fn_win_size - init / callFunction: " + init + " / " + callFunction);
		//alert("Number($(window).width()): " + Number($(window).width()));
		//alert("Number($(window).height()): " + Number($(window).height()));
		var fix_main_w = 1280; // 메인페이지 Iframe(DashBoard영역) 기본 width  <-- 비율 계산용
		var fix_main_h = 715;  // 메인페이지 Iframe(DashBoard영역) 기본 height <-- 비율 계산용
		
		var fix_sub_w = 1095; // 서브페이지 Iframe(DashBoard영역) 기본 width  <-- 비율 계산용
		var fix_sub_h = 715;  // 서브페이지 Iframe(DashBoard영역) 기본 height <-- 비율 계산용
		var fix_top = 53; // 상단 메뉴의 height
		var fix_left = 185; // 좌측 메뉴의 width
		
		var red_w = 0;
		var red_h = 0;
		
		var header_w = 0;
		//var header_w = Number($(window).width()) - fix_left;
		//var header_w = Number($(window).width());
		
		//red_h = parseInt($(window).height()) - 53;
		red_h = Number($(window).height()) - 53;	
		
		// 메인 페이지인 경우 width를 전부 이용
		if (init == "init") {		
			//red_w = parseInt($(window).width());
			//red_w = Number($(window).width());
			//red_w = red_h * fix_main_w / fix_main_h;
			//header_w = red_w;
			
			/* 서브페이지와 메뉴사이즈가 동일함(전체화면 기준으로 화면 상하에 공백이 발생 할 수 있음)*****/
			red_w = red_h * fix_sub_w / fix_sub_h;
			red_w = red_w + fix_left
			header_w = red_w;			
			/**********************************************************************************/
			
			/* 전체사이즈 기준 (메인화면과 서브화면의 헤더 사이즈가 상이함)****************************/
			/*
			red_w = red_h * fix_main_w / fix_main_h;
			//red_w = red_w + fix_left
			header_w = red_w;
			*/
			/**********************************************************************************/
			
			//rd_w = red_h * fix_sub_w / fix_sub_h;
			//header_w = red_w + fix_left;
			
		// 서브 페이지인 경우 서브페이지 비율에 따라 width 산정
		} else {
			red_w = red_h * fix_sub_w / fix_sub_h;
			header_w = red_w + fix_left;
		}		
				
		if (header_w < fix_main_w || Number($(window).width()) < fix_main_w) { //1280보다 헤더 사이즈가 작은거나 윈도우창이 1280보다 작은 경우
			header_w = 1280; // 헤더 사이즈가 1280보다 작으면 상단 메뉴 찌그러짐 방지
			window.document.body.scroll = "auto"; // 스크롤 생성
		} else {
			window.document.body.scroll = "no";   // 스크롤 제거			
		}
		
		$('#wrap').css('width', header_w + 'px');
		$('#header').css('width', header_w + 'px');	
		//alert("header_w: " + header_w);
		//alert("red_w + fix_left: " + red_w + fix_left);
		
		$('#dashboard').css('width', red_w + 'px');  //Iframe(DashBoard영역) width 세팅
	  	$('#dashboard').css('height', red_h + 'px'); //Iframe(DashBoard영역) width 세팅		  			
	}

	/**
	* 세로고침 방지
	*/
	$(document).keydown(function (e){	 
	 	//F5
	 	if(e.which == 116){
	  		if(typeof event == 'object'){
	   			event.keyCode = 0;
	  	}
	  	return false;
	 	}else if(e.which == 82 && e.ctrlKey){  //새로 고침 : ctrl+r
	  		return false;
	 	}else if(e.which == 78 && e.ctrlKey){  //새 창 : ctrl+n
	  		return false;
	 	}
	});

	/**
	* 화면 사이즈 변경시 호출
	*/	
	$(document).ready(function() {
				 
		$(window).resize(function() { // 브라우저 사이즈 변경 감지					
			fn_win_size(init, "resize");
		});   
	});

	/**
	* 상단 메뉴 마우스 오버시 하위에 해당 메뉴의 서브메뉴 Layer표시
	*/		
	$(function(){
	     $("ul.tsub").hide();
	     
		 $("ul.top_menu_R li").hover(function(){
					 	
		    $("ul:not(:animated)",this).slideDown("fast");
			},
			function(){			
			   $("ul",this).slideUp("fast");
			});
	  });	

	/**
	* 닫기 버튼 클릭 시 로그아웃(세션 삭제) 처리
	* - 숨겨진 iframe에서 logout.jsp 호출
	* - 크롬을 제외한 모든 브라우져에서 작동(IE기준으로 개발됨)
	*/	  
	$(window).bind(
		"beforeunload",
 		function() {
			//alert("event.clientX: " + event.clientX);
			//alert("event.clientY: " + event.clientY);
			//alert("event.pageX: " + event.pageX);
			//alert("event.pageY: " + event.pageY);
			//alert("event.screenX: " + event.screenX);
			//alert("event.screenY: " + event.screenY);
			  
			//if(event.clientX < 0 && event.clientY < 0) {
			if(event.clientY < 0 || event.pageY < 0 || event.screenY < 0) {				

	<%
			logger.debug("session-LinkYN (1): " + session.getAttribute("LinkYN"));
			
			// DashBoard에서 다른 메뉴로 화면 이동시 해당 function이 호출되어 페이지이동 처리하는 화면에서 LinkYN값을 "Y"로 전달하여 로그아웃 방지
			if(session.getAttribute("LinkYN") == null) {	
	%>
				//숨겨진 iframe에서 logout.jsp 호출
				$("#closeForm").attr("target", "closeIframe").attr("method", "post").attr("action", "logoutPrc.jsp").submit();			  				 		
				alert("로그아웃 하셨습니다.");
	<%
			}
			session.removeAttribute("LinkYN");
			logger.debug("session-LinkYN (2): " + session.getAttribute("LinkYN"));
	%>
			} // if
	}); // $(window).bind(
	 
</script>
</head>
<body onload= "fn_init();">
<div id="wrap">	                                  
   	<!-- 상단메뉴 start -->
	<div id="header">
       	<div id="toplogo"><a href ="javascript:fn_init();"><img src="images/logo.png"/></a></div>
		<div id="topmenu_box">
        	<div class="top_menu">
           		<ul class="top_menu_R">
<%	
	String MInfoZLEVEL1 = "";
	String MInfoZLEVEL2 = "";
	String MInfoZLEVEL3 = "";
	String MInfoZPARAM = "";
	String MInfoZURL = "";
	String MInfoZEIS_DATE = "";
	for(int i = 0 ; i < vlist.size() ; i++) {
		MInfo = (MenuInfo)vlist.elementAt(i);

		if(MInfo.getZLEVEL2().equals("00") && MInfo.getZLEVEL3().equals("00") && MInfo.getZNODE_TYPE().equals("F")) {
			MInfoZLEVEL1 = "";
			MInfoZLEVEL2 = "";
			MInfoZLEVEL3 = "";
			MInfoZPARAM = "";
			MInfoZURL = "";
			MInfoZEIS_DATE = "";

			for(int a = 0 ; a < slist.size() ; a++) { 
				SMInfo = (MenuInfo)slist.elementAt(a);
				if(MInfo.getZLEVEL1().equals(SMInfo.getZLEVEL1()) & !SMInfo.getZNODE_TYPE().equals("F")) {
					MInfoZLEVEL1 = SMInfo.getZLEVEL1();
					MInfoZLEVEL2 = SMInfo.getZLEVEL2();
					MInfoZLEVEL3 = SMInfo.getZLEVEL3();
					MInfoZPARAM = SMInfo.getZPARAM();
					MInfoZURL = SMInfo.getZURL();
					MInfoZEIS_DATE = SMInfo.getZEIS_DATE();
									
					break;					
				}
			} // for문
			if (EisUtil.isNotBlank(MInfoZPARAM)) { // 하위에 1개라도 등록된 페이지가 있는 경우에는 가장 상단의 페이지 호출
%>
					<li id = "li_<%=MInfo.getZLEVEL1()%>" onmouseover="javascript:fn_div_mouseover(1, '<%=MInfo.getZLEVEL1()%>');" class="top_menu_bgimg<%=MInfo.getZLEVEL1()%>_off"  onmouseout="javascript:fn_div_mouseover(2, '<%=MInfo.getZLEVEL1()%>');">
						<a href="javascript:fn_div_display('<%=MInfo.getZLEVEL1()%>');fn_gopage('<%=MInfoZLEVEL1%>', '<%=MInfoZLEVEL2%>', '<%=MInfoZLEVEL3%>', '<%=MInfoZPARAM%>', '<%=MInfoZURL%>', '<%=MInfoZEIS_DATE%>', '<%=langu%>');" >
							<%=MInfo.getZTEXT()%>
						</a>
						<div class="layer_menu">
							<ul class="tsub">		
								<li>
<%								
				for(int a = 0 ; a < slist.size() ; a++) { 
					SMInfo = (MenuInfo)slist.elementAt(a); 
	 				if(MInfo.getZLEVEL1().equals(SMInfo.getZLEVEL1())) { 
						//if(SMInfo.getZLEVEL3().equals("00")) { // 2Lv
						if(SMInfo.getZNODE_TYPE().equals("F")) { // 2Lv
%>

									<a href="#" class="tsub_on" >								
										<%=SMInfo.getZTEXT()%>
									</a>
						
<%					
						} else if(SMInfo.getZLEVEL3().equals("00")) { // 2Lv에 바로 화면이 나오는 경우
%>
									<span>
										<a href="#" onclick="javascript: fn_div_display('<%=MInfo.getZLEVEL1()%>'); fn_gopage('<%=MInfo.getZLEVEL1()%>','<%=SMInfo.getZLEVEL2()%>','<%=SMInfo.getZLEVEL3()%>',  '<%=SMInfo.getZPARAM()%>', '<%=SMInfo.getZURL()%>', '<%=SMInfo.getZEIS_DATE()%>', '<%=langu%>')">						
											<%=SMInfo.getZTEXT()%>						
										</a>
									</span>
<%						
						} else {
%>
									<span>
										<a href="#" onclick="javascript:fn_div_display('<%=MInfo.getZLEVEL1()%>'); fn_gopage('<%=MInfo.getZLEVEL1()%>','<%=SMInfo.getZLEVEL2()%>','<%=SMInfo.getZLEVEL3()%>',  '<%=SMInfo.getZPARAM()%>', '<%=SMInfo.getZURL()%>', '<%=SMInfo.getZEIS_DATE()%>', '<%=langu%>')">						
											- <%=SMInfo.getZTEXT()%>						
										</a>
									</span>
<%
						} // end if
 					} // end if
				} // end for
 					
%> 				
									
								</li>		
							</ul>
						</div>
					</li>					
<%			} else { %>
					<li id = "li_<%=MInfo.getZLEVEL1()%>" class="top_menu_bgimg<%=MInfo.getZLEVEL1() %>_off" >
						<a href="javascript:fn_div_display('<%=MInfo.getZLEVEL1()%>');" ><%=MInfo.getZTEXT()%></a>
					</li>
<%					
			}
		} 
	} // for문
%>
            	</ul>
        	</div>
		</div>
    </div>      
	<!-- 상단메뉴 end -->


    <!-- 외쪽메뉴 start -->      
    <div id="left">
    	<section id="snb">
    		<nav id="snb2">
<%
	for(int i = 0 ; i < vlist.size() ; i++) { 
		MInfo = (MenuInfo)vlist.elementAt(i); 
		if( MInfo.getZLEVEL2().equals("00") && MInfo.getZLEVEL3().equals("00") 
				& MInfo.getZNODE_TYPE().equals("F") ) { 

			for(int a = 0 ; a < slist.size() ; a++) { 
				SMInfo = (MenuInfo)slist.elementAt(a); 
 				if(MInfo.getZLEVEL1().equals(SMInfo.getZLEVEL1())) {
 				//if(MInfo.getZLEVEL1().equals(SMInfo.getZLEVEL1()) && !SMInfo.getZLEVEL1().equals("2")) {	
					//if(SMInfo.getZLEVEL3().equals("00")) { // 2Lv
					if(SMInfo.getZNODE_TYPE().equals("F")) { // 2Lv
%>

					
					<div id = "div_<%=MInfo.getZLEVEL1()%><%=SMInfo.getZLEVEL2()%>"  class="left_btn_off" onclick="javascript:fn_sub_div_display('<%=MInfo.getZLEVEL1()%>','<%=SMInfo.getZLEVEL2()%>')">
						<%=SMInfo.getZTEXT()%>
					</div>					
<%					
					} else if(SMInfo.getZLEVEL3().equals("00")) { // 2Lv에 바로 화면이 나오는 경우
%>
					<a href="#" onclick="javascript:fn_gopage('<%=MInfo.getZLEVEL1()%>','<%=SMInfo.getZLEVEL2()%>','<%=SMInfo.getZLEVEL3()%>',  '<%=SMInfo.getZPARAM()%>', '<%=SMInfo.getZURL()%>', '<%=SMInfo.getZEIS_DATE()%>', '<%=langu%>')">
						<div id ="div_<%=MInfo.getZLEVEL1()%><%=SMInfo.getZLEVEL2()%><%=SMInfo.getZLEVEL3()%>" class="left_btn_off_2lv">
							<%=SMInfo.getZTEXT()%>
						</div>
					</a>
<%						
					} else {
%>
					<a href="#" onclick="javascript:fn_gopage('<%=MInfo.getZLEVEL1()%>','<%=SMInfo.getZLEVEL2()%>','<%=SMInfo.getZLEVEL3()%>',  '<%=SMInfo.getZPARAM()%>', '<%=SMInfo.getZURL()%>', '<%=SMInfo.getZEIS_DATE()%>', '<%=langu%>')">
						<div id ="div_<%=MInfo.getZLEVEL1()%><%=SMInfo.getZLEVEL2()%><%=SMInfo.getZLEVEL3()%>" class="left_btn_off_3lv">
							- <%=SMInfo.getZTEXT()%>
						</div>
					</a>
<%
					} // end if
 				} // end if
 			} // end for
		} // end if
	} // end for
%>		
     		</nav>
  		</section>
	</div>     
    <!-- 왼쪽메뉴 end -->  

	<!-- 콘텐츠박스 start  -->
                 
	<div id="div_dashboard" class = "content" >
<%   
		//<iframe src = "" id = "dashboard" width = "85.55%"  height ="93.5%" frameboard = "0" scrolling = "no" frameborder="0" cellpadding="0" cellspacing="0" align="left"></iframe>			
%>
		<iframe src = "" id = "dashboard" width = "100%"  height ="100%" frameboard = "0" scrolling = "no" frameborder="0" cellpadding="0" cellspacing="0" align="left"></iframe>
	</div>
		  		
	<!-- 콘텐츠박스 end -->
</div>  
</body>
</html>
<%
	} // if(session.getAttribute("userInfo") == null) {
%>
<form id="closeForm"></form>
<iframe src="" id="closeIframe" name="closeIframe" width="0" height="0"></iframe> 
