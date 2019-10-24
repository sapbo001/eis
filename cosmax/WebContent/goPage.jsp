<%@ page import="com.crystaldecisions.sdk.framework.IEnterpriseSession" %>
<%@ page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%

	Logger logger = Logger.getLogger(this.getClass());

	if(session.getAttribute("userInfo") == null) {
		logger.debug("세션이 없어짐");
		response.sendRedirect("logoutPrc.jsp?closeYN=Y_P&msg=" + URLEncoder.encode("세션이 종료되었습니다. 재접속 해주십시오.","UTF-8"));
	} else {	
		String fileName = "/config/bo_conf.properties";
	
		ReadProperties rp = new ReadProperties();
		
		String INFOVIEW_URL = rp.getProperty(fileName, "bo.url");
		String logonToken = (String)session.getAttribute("logonToken");
		String serSes = (String)session.getAttribute("serSes");
		String iDocID = request.getParameter("iDocID");
		String PMENUID = null;	
		if (EisUtil.isNotBlank(request.getParameter("PMENUID"))) {
			//byte[] b = request.getParameter("PMENUID").getBytes("iso-8859-1");
			//PMENUID = new String(b, "euc-kr"); 
			logger.debug("goPage.jsp > PMENUID : " + PMENUID);
			PMENUID = URLDecoder.decode(request.getParameter("PMENUID"),"UTF-8");		
		}
			
		String PDATE = request.getParameter("PDATE");
		String PLANGU = request.getParameter("PLANGU");
	
		if(EisUtil.isBlank(iDocID)) {
			iDocID = "Fgum6Fb9lQwA.WQAAAD3uK4C7LHXirOA"; //ZEIS_NOPAGE_001.xlf
		}
	
		
	// 	String openDocURL = INFOVIEW_URL + "?iDocID="+iDocID+"&serSes=" + serSes+"&sIDType=CUID&lsSsize=d&noDetailsPanel=true"; //serSes방식 
	// 	String openDocURL = INFOVIEW_URL + "?iDocID="+iDocID
	// 			+"&lsSPMENUID="+PMENUID+"&lsSPDATE="+PDATE+"&lsSPLANGU="+PLANGU
	// 			+"&serSes=" + serSes+ "&sIDType=CUID&lsSsize=d&noDetailsPanel=true";
	
		String openDocURL = INFOVIEW_URL + "?iDocID="+iDocID			
				+"&token=" + logonToken+"&sIDType=CUID&lsSsize=d&noDetailsPanel=true"; // DashBoard 및 WebI 필수 Parameter값(ex: CUID)
		openDocURL = openDocURL +"&lsSPMENUID="+PMENUID+"&lsSPDATE="+PDATE+"&lsSPLANGU="+PLANGU; // DashBoard 내부에서 사용되는 Parameter값
		openDocURL = openDocURL + "&wmode=transparent"; // 상단 onmouse시 레이어 보이게 하기 위함(BO내부 소스 /viw/view.jsp 소스참고)
		openDocURL = openDocURL + "&lsSPTOKEN=" + logonToken; // Portal과 DashBoard간 토큰 이동시 해당명으로 이용		
			
	 	logger.debug("openDocURL : " + openDocURL);
	
		response.sendRedirect(openDocURL);
	}		
%>