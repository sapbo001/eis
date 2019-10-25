<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="com.jco.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="conJCO" class="com.jco.ConnectionJCO" scope="application"/>
<%
	Logger logger = Logger.getLogger(this.getClass());

	logger.debug("Start > Before Revmove > Live Session List ****************");
	Enumeration enum_app = session.getAttributeNames();	
	String ls_name = "";
	String ls_value = "";
	while(enum_app.hasMoreElements()) {
		ls_name = enum_app.nextElement().toString();
		ls_value = session.getAttribute(ls_name).toString();
	
		logger.debug("session Name/value: "+ls_name + "/" + ls_value); 
	}
	logger.debug("End > Before Revmove > Live Session List ****************");

	logger.info("logout Procees Start ***********");		
	try{
		if (session.getAttribute("enterpriseSession") != null) {
		    IEnterpriseSession enterpriseSession = (IEnterpriseSession) session.getAttribute("enterpriseSession");;		    
		    if(enterpriseSession != null){	
		    	if (session.getAttribute("logonToken") != null) { 
			    	try {
			    		logger.debug("session.getAttribute(logonToken): " + session.getAttribute("logonToken"));
			    		enterpriseSession.getLogonTokenMgr().releaseToken(session.getAttribute("logonToken").toString());
// 			    		enterpriseSession.getLogonTokenMgr().releaseToken((String)session.getAttribute("logonToken"));
// 			    		enterpriseSession.getLogonTokenMgr().releaseToken(java.net.URLEncoder.encode(((String)session.getAttribute("logonToken")),"UTF-8"));
			    	} catch (Exception e) {
			    		logger.error(e);
			    	}
		    	}		    			       		    			    	
		    	
				enterpriseSession.logoff();
				enterpriseSession = null;
				logger.info("BO Log Off");				        
		    }		  
		}	    
		session.removeAttribute("ZSABUN");
		session.removeAttribute("userInfo");
	 	session.removeAttribute("enterpriseSession");
	 	session.removeAttribute("logonToken");
// 	 	session.removeAttribute("serSes");
	 	session.removeAttribute("ZEIS_USER_ID");
	 	session.removeAttribute("ZEIS_USER_NM");
	 	session.removeAttribute("ZSTART_MENU_CD");
	 	session.removeAttribute("ZDEFALUT_LANGU");	
	 	session.removeAttribute("vlist");
	 	session.removeAttribute("startMInfo");
	 	session.removeAttribute("INFOVIEW_URL");
	 	
	 	//session.invalidate(); // JCO까지 세션이 날라감
	}catch(Exception e){
		logger.error(e);
	}
	
	logger.info("logout Procees End ***********");
	
	logger.debug("Start > After Revmove > Live Session List ****************");
	Enumeration enum_app1 = session.getAttributeNames();	
	String ls_name1 = "";
	String ls_value1 = "";
	while(enum_app1.hasMoreElements()){
		ls_name1 = enum_app1.nextElement().toString();
		ls_value1 = session.getAttribute(ls_name1).toString();
	
		logger.debug("session Name/value: "+ls_name1 + "/" + ls_value1);
	}
	logger.debug("End > After Revmove > Live Session List ****************");	
	
	/**로그아웃시 해당화면 Closing으로 변경**/
// 	String sendURL = EisUtil.null2Blank(request.getParameter("sendURL"));
// 	if(EisUtil.isBlank(sendURL)) {
// 		sendURL = "login.jsp";
// 	}    
//     response.sendRedirect(sendURL);
	/************************************/

	String msg = URLDecoder.decode(EisUtil.null2Blank(request.getParameter("msg")),"UTF-8");
	String closeYN = EisUtil.null2Blank(request.getParameter("closeYN"));
	
	logger.debug("msg: " + msg);
	logger.debug("closeYN: " + closeYN);
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Cosmax EIS</title>
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
	<script type="text/javascript">
<% if(EisUtil.isNotBlank(msg)) { %>		
		alert('<%=msg%>');
<% } %>
<% if(closeYN.equals("Y")) { %>
		window.close();
<% } else if(closeYN.equals("Y_P")) { %>
		parent.close();
<% } %>
	</script>
</body>
</html>
