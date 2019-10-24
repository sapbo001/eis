<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Cosmax EIS</title>    
</head>	
<body>
<%
	/**
	 * DashBoard에서 다른 메뉴로 이동시 사용되는 페이지
	 * - 로컬에서 테스트시 BO서버로 session이 이동했다가 하나도 보니 포탈의 세션이 전부 없음
	 * - 테스트는 반드시 서버에서 테스트 해야함(포탈과 BO는 같은 서버에 있음)
	*/
	Logger logger = Logger.getLogger(this.getClass());

	//String iDocID = request.getParameter("iDocID");
	String PMENUID = EisUtil.null2Blank(request.getParameter("PMENUID"));
	session.setAttribute("LinkYN", "Y");
	
	logger.debug("PMENUID: " + PMENUID);
	logger.debug("vlist-session: " + session.getAttribute("vlist"));
	logger.debug("userInfo-session: " + session.getAttribute("userInfo"));
	
	if(session.getAttribute("vlist") != null) {
		Vector<MenuInfo> vlist = (Vector<MenuInfo>)session.getAttribute("vlist");
	 
		MenuInfo MInfo = null;
		String ZLEVEL1 = "";
		String ZLEVEL2 = "";
		String ZLEVEL3 = "";
		String ZPARAM = "";		
		String ZURL = "";
		String ZEIS_DATE = "";		
		String langu = (session.getAttribute("ZDEFALUT_LANGU") == null) ? "" : session.getAttribute("ZDEFALUT_LANGU").toString();
		//String 
		for(int i = 0 ; i < vlist.size() ; i++) {
			MInfo = (MenuInfo)vlist.elementAt(i);
			if (MInfo.getZNODE_TYPE().equals("U") && MInfo.getZURL().equals(PMENUID)) {			
				ZLEVEL1 = MInfo.getZLEVEL1();
				ZLEVEL2 = MInfo.getZLEVEL2();
				ZLEVEL3 = MInfo.getZLEVEL3();
				ZPARAM = MInfo.getZPARAM();
				ZURL = MInfo.getZURL();				
				ZEIS_DATE = MInfo.getZEIS_DATE();		
				
				break;	
			}
		
		}
		logger.debug("ZLEVEL1: " + ZLEVEL1);
		logger.debug("ZLEVEL2: " + ZLEVEL2);
		logger.debug("ZLEVEL3: " + ZLEVEL3);
		logger.debug("ZPARAM: " + ZPARAM);
		logger.debug("ZURL: " + ZURL);
		logger.debug("ZEIS_DATE: " + ZEIS_DATE);
		logger.debug("langu: " + langu);
		
		if(EisUtil.isBlank(ZURL)) {
%>
			<script type="text/javascript">
			    alert("Invaild Menu Id");
			</script>	
<%			
		} else {
%>
			<script type="text/javascript">
			     parent.fn_menuChangeLink('<%=ZLEVEL1%>', '<%=ZLEVEL2%>', '<%=ZLEVEL3%>', '<%=ZPARAM%>', '<%=ZURL%>', '<%=ZEIS_DATE%>', '<%=langu%>');
			</script>
<%			
		}
%>

	

<%		
	} else {
%>
		<script type="text/javascript">
		    alert("Session Close: Not Found Menu Object");
		</script>
	<%			
	}

%>	

<script type="text/javascript">
     parent.fn_menuChangeLink("<%=PMENUID%>");
</script>
</body>
</html>	