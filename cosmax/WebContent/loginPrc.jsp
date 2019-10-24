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
	
	String sabun = EisUtil.null2Blank(request.getParameter("sabun"));
	String userid = EisUtil.null2Blank(request.getParameter("userid"));
	String passwd = EisUtil.null2Blank(request.getParameter("passwd"));
	
	logger.debug("sabun: " + sabun.toString());
	logger.debug("userid: " + userid);
	logger.debug("passwd: " + passwd);
	

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
			session.removeAttribute("userInfo");
		 	session.removeAttribute("enterpriseSession");
		 	session.removeAttribute("logonToken");
		 	session.removeAttribute("ZEIS_USER_ID");
		 	session.removeAttribute("ZEIS_USER_NM");
		 	session.removeAttribute("ZSTART_MENU_CD");
		 	session.removeAttribute("ZDEFALUT_LANGU");	 
		 	session.removeAttribute("vlist");
		 	session.removeAttribute("startMInfo");
		 	
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
				response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("EIS사용자로 등록된 사번이 아닙니다.","UTF-8"));
				logger.debug("msg > " + URLEncoder.encode("등록된 EIS사용자가 아닙니다.","UTF-8"));
			} else {
				logger.debug("userid:" + userid + "인 유저정보가 없음");
// 				response.sendRedirect("login.jsp?langu=" + langu + "&msg=" + URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
				response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
				logger.debug("msg > " + URLEncoder.encode("입력한 사용자정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
			}
		} else {				
			menu = new MenuService();
						
			// bo 서버 연결 세션 처리.
		 	enterpriseSession = menu.setSession(userInfo);
		 	IUserInfo boUser = enterpriseSession.getUserInfo();
// 		 	logonToken = enterpriseSession.getLogonTokenMgr().getDefaultToken(); // 세션이 2개(OpenDocument 세션 별도로 생성됨!)
	 	 	
			// ""(빈값이면 어떤 컴퓨터에서도 접속 가능), 720분, 로그인하여 해당 토큰을 사용할 수 있는 세션 최대수, 100
			// 세션 클로징이 해당 방법만 잘됨.(다른것은 OpenDocument에서 생성한 세션이 destroy가 잘 안됨)
			logonToken = enterpriseSession.getLogonTokenMgr().createWCAToken("",720,500); 
		 	
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
						                                                   
	        response.sendRedirect("main.jsp");
		}
	} catch(Exception e) {
		e.printStackTrace();
		//response.sendRedirect("login.jsp?langu=" + langu + "msg=" + URLEncoder.encode("로그인 처리중 에러가 발생하였습니다.","UTF-8"));
		response.sendRedirect("login.jsp?msg=" + URLEncoder.encode("로그인 처리중 에러가 발생하였습니다.","UTF-8"));
	}
%> 