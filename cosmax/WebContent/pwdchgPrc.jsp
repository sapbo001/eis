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
		
	String userid = EisUtil.null2Blank(request.getParameter("userid"));
	String passwd_old = EisUtil.null2Blank(request.getParameter("passwd_old"));
	String passwd_new = EisUtil.null2Blank(request.getParameter("passwd_new"));
	
	logger.debug("userid: " + userid);
	logger.debug("passwd_old: " + passwd_old);
	logger.debug("passwd_new: " + passwd_new);
		
	MenuService menu =  null;
	UserInfo userInfo = null;

	try {				 		
				
		menu = new MenuService();
		userInfo = menu.getUser(conJCO, "", userid, passwd_old);
		
		if (userInfo == null) {
			
			logger.debug("userid:" + userid + "인 유저정보가 없음");
			out.print("<script> alert('입력한 정보와 일치하는 EIS사용자가 없습니다.'); history.go(-1);</script>");
			//response.sendRedirect("pwdchg.jsp?prcYN=N&msg=" + URLEncoder.encode("입력한 정보와 일치하는 EIS사용자가 없습니다.","UTF-8"));
		} else {			
							
			boolean rtn = menu.setUserChgPwd(conJCO, userid, passwd_new);
			
			if (rtn == false) {
				logger.debug("userid:" + userid + "인 유저의 비밀번호 변경에 실패하였습니다");
				out.print("<script> alert('비밀번호 변경에 실패하였습니다.'); history.go(-1);</script>");
				//response.sendRedirect("pwdchg.jsp?prcYN=N&msg=" + URLEncoder.encode("비밀번호 변경에 실패하였습니다.","UTF-8"));
			} else {
				out.print("<script> alert('비밀번호가 변경되었습니다.'); self.close();</script>");
// 	        	response.sendRedirect("pwdchg.jsp?prcYN=Y&msg=" + URLEncoder.encode("비밀번호가 변경되었습니다.","UTF-8"));
			}
		}
	} catch(Exception e) {
		logger.error(e);
		out.print("<script> alert('비밀번호 변경중 에러가 발생하였습니다.'); history.go(-1);</script>");
	}
%> 
</body>
</html>