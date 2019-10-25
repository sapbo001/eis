<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.math.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page import="com.crystaldecisions.sdk.occa.security.IUserInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="conJCO" class="com.jco.ConnectionJCO" scope="application"/>
<%
	Logger logger = Logger.getLogger(this.getClass());
	

	String sabun = EisUtil.null2Blank(request.getParameter("sabun"));
	String userid = EisUtil.null2Blank(request.getParameter("userid"));
	String passwd = EisUtil.null2Blank(request.getParameter("passwd"));
	
	logger.debug("sabun: " + sabun);
	logger.debug("userid: " + userid);
	logger.debug("passwd: " + passwd);

	/*
	<사번 암호화 - 코스맥스 그룹웨어에서 아래 규칙으로 암호화 후 값 전송>
	1. 암호화 : 사번에 127을 곱하고 13466917 을 더해서 전송
	2. 복호화 : 위 처리 방식 반대로 처리 후 로그인 인증
	*/
	// 코스맥스의 경우 사번의 경우 숫자로 이루어져 있다. 숫자인지 체크하고 숫자인 경우에만 암호화 처리
	long encodeSabun = 0;
	long decodeSabun = 0;
	logger.debug("EisUtil.isNumeric(sabun): " + EisUtil.isNumeric(sabun));
	if(EisUtil.isNotBlank(sabun) && EisUtil.isNumeric(sabun)) {
		try {
			encodeSabun = Long.parseLong(sabun);			
			decodeSabun = (encodeSabun - 13466917) / 127 ;
			sabun = String.valueOf(decodeSabun);
		} catch (Exception e){
			logger.error(e);
		}
	}
	logger.debug("encodeSabun: " + encodeSabun);
	logger.debug("decodeSabun: " + decodeSabun);
	
	IEnterpriseSession enterpriseSession = null;
	
	String logonToken = "";
	
	MenuService menu = null;
	UserInfo userInfo = null;
	
	String languBO = null;
	
	try {				 		
		
		logger.info("Session > logout Procees Start ***********");		
		try{
			if (session.getAttribute("enterpriseSession") != null) {
			    IEnterpriseSession enterpriseSession_garbage = (IEnterpriseSession) session.getAttribute("enterpriseSession");;		    
			    if(enterpriseSession_garbage != null){
			    	logger.info("Session > BO Log Off Start =====================");
			    	if (session.getAttribute("logonToken") != null) { 
				    	try {
				    		logger.debug("session.getAttribute(logonToken): " + session.getAttribute("logonToken"));
				    		enterpriseSession_garbage.getLogonTokenMgr().releaseToken(session.getAttribute("logonToken").toString());
// 				    		enterpriseSession_garbage.getLogonTokenMgr().releaseToken((String)session.getAttribute("logonToken"));
// 				    		enterpriseSession_garbage.getLogonTokenMgr().releaseToken(java.net.URLEncoder.encode(((String)session.getAttribute("logonToken")),"UTF-8"));
				    		
				    	} catch (Exception e) {
				    		logger.error(e);
				    	}
			    	}
			    	enterpriseSession_garbage.logoff();			    	
			    	enterpriseSession_garbage = null;
					logger.info("Session > BO Log Off End =====================");				        
			    }		  
			}	
			session.removeAttribute("ZSABUN");
			session.removeAttribute("userInfo");
		 	session.removeAttribute("enterpriseSession");
		 	session.removeAttribute("logonToken");
		 	session.removeAttribute("ZEIS_USER_ID");
		 	session.removeAttribute("ZEIS_USER_NM");
		 	session.removeAttribute("ZSTART_MENU_CD");
		 	session.removeAttribute("ZDEFALUT_LANGU");	 
		 	session.removeAttribute("vlist");
		 	session.removeAttribute("startMInfo");
		 	session.removeAttribute("INFOVIEW_URL");
		 	
		 	//session.invalidate();  // JCO까지 세션이 날라감
		} catch(Exception e){
			logger.error(e);
		}	
		logger.info("Sesssion > logout Procees End ***********");
		
		menu = new MenuService();
		userInfo = menu.getUser(conJCO, sabun, userid, passwd);
		session.removeAttribute("userInfo");
		session.setAttribute("userInfo", userInfo);		
		
		if (userInfo == null) {
			if(EisUtil.isNotBlank(sabun)) {
				logger.debug("sabun:" + sabun + "인 유저정보가 없음");
// 				response.sendRedirect("login.jsp?langu=" + langu + "&msg=" + URLEncoder.encode("EIS사용자로 등록된 사번이 아닙니다.","UTF-8"));
				//response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("EIS사용자로 등록된 사번이 아닙니다.","UTF-8"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Cosmax EIS</title> 
</head>
<body>
		<script type="text/javascript">
			alert("EIS사용자로 등록된 사번이 아닙니다.");
			window.close();
		</script>		
<%				
				logger.debug("msg > " + URLEncoder.encode("등록된 EIS사용자가 아닙니다.","UTF-8"));
			} else {
				logger.debug("userid:" + userid + "인 유저정보가 없음");
// 				response.sendRedirect("login.jsp?langu=" + langu + "&msg=" + URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
%>
		<script type="text/javascript">
			//alert("입력한 정보와 일치하는 EIS사용자가 없습니다.");
			document.location.href = "login.jsp?msg=<%=URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8")%>";
		</script>			
<%
				//response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
				logger.debug("msg > " + URLEncoder.encode("입력한 사용자정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
			}
		} else {				
			menu = new MenuService();
						
			// bo 서버 연결 세션 처리.
		 	enterpriseSession = menu.setSession(userInfo);
		 	IUserInfo boUser = enterpriseSession.getUserInfo();
// 		 	logonToken = enterpriseSession.getLogonTokenMgr().getDefaultToken(); // 세션이 2개(OpenDocument 세션 별도로 생성됨!)
	 	 	
			// ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 로그인하여 해당 토큰을 사용할 수 있는 세션 최대수, 500
			logonToken = enterpriseSession.getLogonTokenMgr().createWCAToken("",720,500);
// 			logonToken = enterpriseSession.getLogonTokenMgr().createLogonToken("",720,500);
		 	
		 	/*다른 토큰 생성 방법들(현재는 getDefaultToken을 이용)*/
//	 	 	logonToken = enterpriseSession.getLogonTokenMgr().createWCAToken("",720,1); // ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 최대 세션 1개 생성
// 			logonToken = enterpriseSession.getLogonTokenMgr().createLogonToken("",720,1); // ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 최대 세션 1개 생성
// 	 		logonToken = java.net.URLEncoder.encode(enterpriseSession.getLogonTokenMgr().createLogonToken("",720,1), "UTF-8");; // ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 최대 세션 1개 생성	 	
// 	 		logonToken = java.net.URLEncoder.encode(enterpriseSession.getLogonTokenMgr().createLogonToken("",720,100), "UTF-8");; // ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 최대 세션 1개 생성
// 		 	serSes = java.net.URLEncoder.encode(enterpriseSession.getSerializedSession(), "UTF-8");		
			
			logger.debug("before Setting - userInfo.getZDEFALUT_LANGU(): " + userInfo.getZDEFALUT_LANGU());				
		 			
			//ZDEFAULT_LANGU값이 세션에 있는 경우에는 해당 유저의 Default 언어를 해당 조건으로 변경
			try {
				//BO에서 Locale 미지정이면 BO내부 API에서 에러발생 ㅡㅡ;;
				if (enterpriseSession.getUserInfo().getPreferredViewingLocale() != null) {
						languBO = enterpriseSession.getUserInfo().getPreferredViewingLocale().toString();
	
				}
				if (EisUtil.isBlank(languBO)) {
					logger.debug("enterpriseSession.getUserInfo().getPreferredViewingLocale().toString()" + enterpriseSession.getUserInfo().getPreferredViewingLocale().toString());
					userInfo.setZDEFALUT_LANGU((String) session.getAttribute("ZDEFALUT_LANGU"));
				}				
			} catch (Exception e) {
				logger.debug(e);
			}

			if ("en_US".equals(languBO))
				userInfo.setZDEFALUT_LANGU("E"); // 영어
			else if ("zh_CN".equals(languBO))
				userInfo.setZDEFALUT_LANGU("1"); // 중국어	
			else 
				userInfo.setZDEFALUT_LANGU("3"); // 그외는 한국어
				
			logger.debug("after Setting - userInfo.getZDEFALUT_LANGU(): " + userInfo.getZDEFALUT_LANGU());	
																 	
		 	session.setAttribute("enterpriseSession", enterpriseSession);

	        session.setAttribute("logonToken", logonToken);
	        
	        session.setAttribute("ZEIS_USER_ID", userInfo.getZEIS_USER_ID());
	        session.setAttribute("ZEIS_USER_NM", userInfo.getZEIS_USER_NM());
	        session.setAttribute("ZDEFALUT_LANGU", userInfo.getZDEFALUT_LANGU());
	        	        	       
	        logger.debug("userInfo.getZEIS_USER_ID(): " + userInfo.getZEIS_USER_ID());
	        logger.debug("userInfo.getZEIS_USER_NM(): " + userInfo.getZEIS_USER_NM());
	        logger.debug("userInfo.getZDEFALUT_LANGU(): " + userInfo.getZDEFALUT_LANGU());	  
	        
			String fileName = "/config/bo_conf.properties";			
			ReadProperties rp = new ReadProperties();	
			String INFOVIEW_URL = rp.getProperty(fileName, "bo.url");	   
			session.setAttribute("INFOVIEW_URL", INFOVIEW_URL);
						                                                   	        
			/* 아이디저장 쿠키처리 로직 추가**********************************/
			if(EisUtil.isNotBlank(userid)) { // 로그인페이지에서 넘어온 경우만 아이디저장 처리
				logger.debug("로그인페이지에서 넘어와서 쿠키작업 시작 ==============");
				Cookie idCookie  = null;
		        Cookie[] cookies = request.getCookies();            //저장되어 있는 쿠키를 가져옮
		        if(cookies != null) {
		        	logger.debug("쿠키가 null이 아닌 경우");
		        	for(int j = 0; j < cookies.length; j++) {
		           		if(cookies[j].getName().equals("cookieUserId")) {	// 저장된 쿠키이름은 cookieUserId
		           			logger.debug("쿠키에 아이디가 있는 경우");
		            		idCookie = cookies[j];                          // idCookie에 전달
		            		break;
		           		} // if
		          	} // for
		        } // if
		        
		        String idsave = request.getParameter("idsave");		        
		        logger.debug("idsave: " + idsave);
		        logger.debug("userid: " + userid);		        
		        if("Y".equals(idsave)) { //아이디저장 체크박스가 체크되어 있는 경우		        	
		        	if(idCookie == null || idCookie.getValue().equals("") || !EisUtil.null2Blank(userid).equals(idCookie.getValue())) {
		        		logger.debug("쿠키아이디 생성 로직시작");
		        		Cookie creCookie = new Cookie("cookieUserId", userid);         
						//idCookie.setPath("/");             // 모든 경로에서 접근 가능하도록 
						creCookie.setMaxAge(60*60*24*365);  // 시간을 지정(365일)
						response.addCookie(creCookie);
						logger.debug("creCookie.getValue(): " + creCookie.getValue());
		        	}
		        } else {
		        	logger.debug("쿠키아이디 삭제 로직시작");
					Cookie delCookie = new Cookie("cookieUserId","");   // 쿠키이름이 userId인 값을 ""으로 			                                                                                
					//delCookie.setPath("/");                // 만듬 (2번에 걸쳐 삭제)		              
					delCookie.setMaxAge(-1);               // 시간을 -1로 만들어
					response.addCookie(delCookie);         // 다시 보냄		
					logger.debug("idCookie.getValue(): " + idCookie.getValue());
		        }
			}
			
			/*[로그인 접속로그 처리 Start]===========================================================*/	
			try {		
				if(EisUtil.isNotBlank(sabun)) {
					session.setAttribute("ZSABUN", sabun); //그룹웨어서 들어온 경우
				} else {
					session.setAttribute("ZSABUN", userid); //로그인페이지에서 들어온 경우
				}					 
				String ZUSER_IP = request.getRemoteAddr(); // 접속자 유저IP <-- 포털사이트연결시 아이피로 연결하면 클라이언트IP도 정상적으로 찍힘(localhost로 하면 안됨)
// 				logger.debug("request.getRemoteAddr(): " + request.getRemoteAddr());
// 				logger.debug("request.getRemoteHost(): " + request.getRemoteHost());
			 	/*
			 	insEisConLog(ConnectionJCO conJCO, String ZGUBUN_CONUSE
						, String ZSABUN, String ZEIS_USER_ID, String ZMENU_CD, String ZUSER_IP
						, String ZMENU_NM, String ZTOPMENU_NM)*/
				// EIS 로그구분(1:로그인, 2:메뉴클릭) <-- ZGUBUN_CONUSE
				menu.insEisConLog(conJCO, "1", 
						session.getAttribute("ZSABUN").toString(), 
						session.getAttribute("ZEIS_USER_ID").toString(),
						"", 
						ZUSER_IP, 
						"", 
						"");
			} catch(Exception e) { // 로그기록중 에러가 발생하더라도 정상접속되게 처리(예외사황 방지)
				logger.error("로그인 접속로그 처리시 에러발생=========");
				logger.error(e);
				logger.error("====================================");
			}
			/*[로그인 접속로그 처리 End]===========================================================*/
		        			       			  		
			/*************************************************************/
	        //response.sendRedirect("main.jsp");			
%>
		<script type="text/javascript">
	        // 팝업 방식으로 수정
			var popUrl = "main.jsp";
	        var display_size = <%=EisUtil.null2Blank(request.getParameter("display_size"))%>
	        popUrl = popUrl + "?display_size=" + display_size;
	        //alert("popUrl: " + popUrl);
			var left = 0;
			var top = 0;
			var lv_with = 1280 - 4;
			var lv_height = 768 - 4;
					
			var lv_user_with = (screen.width - 10);
			//var lv_user_height = (screen.height - 50);
			var lv_user_height = (screen.height - 60);
			
			if(lv_with < lv_user_with && lv_height < lv_user_height) {
				lv_with = lv_user_with;
				lv_height = lv_user_height;
			}										
			//var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=no,scrollbars=no,status=no,menubear=no,location=no,toolbar=no;";    //팝업창 옵션(optoin)
			//var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=yes,scrollbars=no,status=no,menubear=no,location=yes,toolbar=no;";    //팝업창 옵션(optoin)
			//var popOption = "top="+top+",left="+left+",fullscreen=yes,resizable=yes,scrollbars=no,status=no,menubar=no,location=no,toolbar=no,directories=no,channelmode=no,titlebar=yes"; //전체창
			
			var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=yes,scrollbars=no,status=no,menubear=no,location=no,toolbar=no;";    //팝업창 옵션<-- 주소창제거
			
			window.open(popUrl,"",popOption);
			window.open("","_self", ""); // 경고창없이 닫히게 하기위함
			window.close();				 // 경고창없이 닫히게 하기위함			
		</script>	
<%			
		}
	} catch(Exception e) {
		e.printStackTrace();
		//response.sendRedirect("login.jsp?langu=" + langu + "msg=" + URLEncoder.encode("로그인 처리중 에러가 발생하였습니다.","UTF-8"));
		response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("로그인 처리중 에러가 발생하였습니다.","UTF-8"));
	}	
%> 
	</body>
</html>