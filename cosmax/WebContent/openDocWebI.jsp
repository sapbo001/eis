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
</head>	
<body>

	<script type="text/javascript">
	    window.resizeBy(0, 0);				
	</script>
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
	
	String popupURL = "openDocWebIPopup.jsp";
	
	if (enumReqNames != null) {											
		int index = 0;
		while(enumReqNames.hasMoreElements()){
			reqName = (String)enumReqNames.nextElement();					
			if (index == 0) { 
				popupURL = popupURL + "?" + reqName + "=" + request.getParameter(reqName);
				index++;
			} else {
				popupURL = popupURL + "&" + reqName + "=" + request.getParameter(reqName);
			}							
		}			
		logger.debug("popupURL: " + popupURL);
		
		if (index > 0) {
%>
			<script type="text/javascript">
				var popUrl = "<%=popupURL%>";
				var left = 0;
				var top = 0;
				var lv_with = 1280 - 4;
				var lv_height = 768 - 4;
				
				//var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=no,scrollbars=no,status=no,menubear=no,location=no,toolbar=no;";    //팝업창 옵션(optoin)
				var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=yes,scrollbars=no,status=no,menubear=no,location=no,toolbar=no;";    //팝업창 옵션(optoin)			
				
				window.open(popUrl,"",popOption);				
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