<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@page import="com.crystaldecisions.sdk.framework.CrystalEnterprise" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> --> 
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<title>Cosmax EIS</title>
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/lnb.js"></script>
<script src="js/tree2_cookie.js" type="text/javascript"></script>
<script src="js/tree2_treeview.js" type="text/javascript"></script>
<script src="js/tree2_demo.js" type="text/javascript"></script>
<script src="js/jquery-ui.js"></script>
<style type="text/css">
html, body {
	margin-left: 0px;
	margin-top: 0px;
	width: 100%;
	height: 100%;
	overflow-y: scroll;
}
</style>	    
</head>	
<body>

<iframe src ="" id ="WEBI_IFRAME" width = "100%"  height ="100%" frameboard = "0" scrolling = "no" frameborder="0" cellpadding="0" cellspacing="0" align="left"></iframe>
<%
	/**
	 * DashBoard에서 WebI를 호출할때 이용되는 것(전달 받은 Parameter값들을 그대로 전달한다.)
	 * - 로컬에서 테스트시 BO서버로 session이 이동했다가 하나도 보니 포탈의 세션이 전부 없음
	 * - 테스트는 반드시 서버에서 테스트 해야함(포탈과 BO는 같은 서버에 있음)	 
	*/
	Logger logger = Logger.getLogger(this.getClass());

	Enumeration enumReqNames = request.getParameterNames();
	String reqName = "";
	
	IEnterpriseSession enterpriseSession = null;
	
	final String tokenParamName = "lsStoken";
	final String openDocTokenParamName = "token";	
	
	if (enumReqNames != null) {		
		
		String fileName = "/config/bo_conf.properties";		
		ReadProperties rp = new ReadProperties();		
		String INFOVIEW_URL = rp.getProperty(fileName, "bo.url");
		String openDocURL = INFOVIEW_URL;
		String lsStoken_param = "";
		String lsStoken_new = "";
		
		int index = 0;
		while(enumReqNames.hasMoreElements()){
			reqName = (String)enumReqNames.nextElement();					
			if (index == 0) { 
				openDocURL = openDocURL + "?" + reqName + "=" + request.getParameter(reqName);
				index++;
			} else if (!tokenParamName.equals(reqName)) {
				openDocURL = openDocURL + "&" + reqName + "=" + request.getParameter(reqName);
			}
			if (tokenParamName.equals(reqName)) 
				lsStoken_param = request.getParameter(reqName);
								
		 }	
		
		if (EisUtil.isNotBlank(lsStoken_param)) {
			try {
				logger.debug("Before - Session Create By token(lsStoken_param):" + lsStoken_param);
				enterpriseSession = CrystalEnterprise.getSessionMgr().logonWithToken(lsStoken_param);
				//lsStoken_new = enterpriseSession.getLogonTokenMgr().createWCAToken("",720,500);
				logger.debug("After - Session Create By token(lsStoken):" + lsStoken_new);
				
				openDocURL = openDocURL + "&" + openDocTokenParamName + "=" + lsStoken_param;
			} catch (Exception e) {
				logger.error(e);
			}
		}
// 		if (session.getAttribute("logonToken") != null) {
// 			if (index == 0) { 
// 				openDocURL = openDocURL + "?lsStoken" + session.getAttribute("logonToken").toString();
// 			} else {
// 				openDocURL = openDocURL + "&lsStoken" + session.getAttribute("logonToken").toString();
// 			}
// 		}
		logger.debug("openDocURL: " + openDocURL);
		
		if (index > 0) {
%>
			<script type="text/javascript">			
				var url = '<%=openDocURL%>';
				$('#WEBI_IFRAME').attr('src', url);
			</script>		
			
<%
		} else if(EisUtil.isBlank(lsStoken_new)) {
%>
			<script type="text/javascript">
			    alert("Invaild Create Token");
			    window.open("","_self", ""); // 경고창없이 닫히게 하기위함
				window.close();				 // 경고창없이 닫히게 하기위함
			</script>			

<%			
		} else {
%>
			<script type="text/javascript">
			    alert("Vaild Parameter Nothing");
			    window.open("","_self", ""); // 경고창없이 닫히게 하기위함
				window.close();				 // 경고창없이 닫히게 하기위함
			</script>			
<%			
		}
	} else {
		logger.debug("Prameter Nothing");
%>
		<script type="text/javascript">
		    alert("Prameter Nothing");
		    window.open("","_self", ""); // 경고창없이 닫히게 하기위함
			window.close();				 // 경고창없이 닫히게 하기위함
		</script>
<%		
	}
%>	
</body>
</html>	