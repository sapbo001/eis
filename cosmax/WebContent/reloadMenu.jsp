<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page import="java.net.*"%>
<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<jsp:useBean id="conJCO" class="com.jco.ConnectionJCO" scope="application"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	Logger logger = Logger.getLogger(this.getClass());

	MenuService menu = null;

	if(session.getAttribute("userInfo") == null) {
		logger.debug("세션이 없어짐");
		response.sendRedirect("logoutPrc.jsp?closeYN=Y_P&msg=" + URLEncoder.encode("세션이 종료되었습니다. 재접속 해주십시오.","UTF-8"));
	} else {
		String INFOVIEW_URL = (String)session.getAttribute("INFOVIEW_URL");
		String logonToken = (String)session.getAttribute("logonToken");
		String serSes = (String)session.getAttribute("serSes");

	    String userid = (session.getAttribute("ZEIS_USER_ID") == null) ? "" : session.getAttribute("ZEIS_USER_ID").toString();
		String langu = (session.getAttribute("ZDEFALUT_LANGU") == null) ? "" : session.getAttribute("ZDEFALUT_LANGU").toString();
		String sabun = (session.getAttribute("ZSABUN") == null) ? "" : session.getAttribute("ZSABUN").toString();
		String zurl = (String)request.getParameter("zurl");
		String zbookmark = "X";
		
				
		logger.debug("userid: " + userid);
		logger.debug("langu: " + langu);
		logger.debug("sabun: " + sabun);
		
		menu = new MenuService();
		
		// 메뉴 조회.
		Vector<MenuInfo> vlist = menu.getMenu(conJCO, userid, langu, sabun, zurl, zbookmark);
		
%>
		<script type="text/javascript">
			var url = "main.jsp";
			var display_size = <%=EisUtil.null2Blank(request.getParameter("display_size"))%>
			url = url + "?display_size=" + display_size;
	        
			window.location.href = url;		
		</script>
<%
	}
%>
</body>
</html>