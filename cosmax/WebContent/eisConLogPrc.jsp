<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page import="com.crystaldecisions.sdk.occa.security.IUserInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="conJCO" class="com.jco.ConnectionJCO" scope="application"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Cosmax EIS</title>   
</head>
<body>
<%
	Logger logger = Logger.getLogger(this.getClass());
		
	String ZMENU_CD = EisUtil.null2Blank(request.getParameter("ZMENU_CD"));
	String lv1 = EisUtil.null2Blank(request.getParameter("lv1"));
	String lv2 = EisUtil.null2Blank(request.getParameter("lv2"));
	String lv3 = EisUtil.null2Blank(request.getParameter("lv3"));
	
	logger.debug("ZMENU_CD: " + ZMENU_CD);
	logger.debug("lv1: " + lv1);
	logger.debug("lv2: " + lv2);
	logger.debug("lv3: " + lv3);
	
	String ZMENU_NM = "";
	String ZTOPMENU_NM = "";
			
	MenuService menu =  null;
	UserInfo userInfo = null;		
	
	Vector<MenuInfo> vlist = null;	
	MenuInfo MInfo = null;
				
	/*[메뉴별 접속로그 처리 Start]===========================================================*/	
	try {				 
		menu = new MenuService();		
		
		if(session.getAttribute("vlist") != null) {
			vlist = (Vector<MenuInfo>) session.getAttribute("vlist");
		}
		
		if(vlist != null) {
			for(int i = 0 ; i < vlist.size() ; i++) {
				MInfo = (MenuInfo)vlist.elementAt(i);
				
				//선택된 메뉴의 최상위 메뉴명
				if( MInfo.getZLEVEL1().equals(lv1) && MInfo.getZLEVEL2().equals("00") && MInfo.getZLEVEL3().equals("00")) {	
					ZTOPMENU_NM = MInfo.getZTEXT();
				}
				
				//선택된 메뉴명
				if( MInfo.getZLEVEL1().equals(lv1) && MInfo.getZLEVEL2().equals(lv2) && MInfo.getZLEVEL3().equals(lv3)) {	
					ZMENU_NM = MInfo.getZTEXT();
				}				
			}
		}
				
		
			
							
		String ZUSER_IP = request.getRemoteAddr(); // 접속자 유저IP <-- 포털사이트연결시 아이피로 연결하면 클라이언트IP도 정상적으로 찍힘(localhost로 하면 안됨)		 	
		// EIS 로그구분(1:로그인, 2:메뉴클릭) <-- ZGUBUN_CONUSE
		menu.insEisConLog(conJCO, "2", 
				session.getAttribute("ZSABUN").toString(), 
				session.getAttribute("ZEIS_USER_ID").toString(),
				ZMENU_CD, 
				ZUSER_IP, 
				ZMENU_NM, 
				ZTOPMENU_NM);
	} catch(Exception e) { // 로그기록중 에러가 발생하더라도 정상접속되게 처리(예외사황 방지)
		logger.error("메뉴별 접속로그 처리시 에러발생=========");
		logger.error(e);
		logger.error("====================================");
	}
	/*[메뉴별 접속로그 처리 End]===========================================================*/		
%> 
</body>
</html>