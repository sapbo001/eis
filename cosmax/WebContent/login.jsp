<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Logger logger = Logger.getLogger(this.getClass());
		
	String msg = URLDecoder.decode(EisUtil.null2Blank(request.getParameter("msg")),"UTF-8");
// 	logger.debug("msg: " + msg);
// 	logger.debug("request msg: " + request.getParameter("msg"));

	String langu = EisUtil.null2Blank(request.getParameter("langu"));
	if(EisUtil.isBlank(langu)) 
		langu = "3"; //값이 없는 경우 한국어로 세팅
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Cosmax EIS</title>    
	<link rel="stylesheet" href="css/style.css" />
	<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/lnb.js"></script>
	<script src="js/tree2_cookie.js" type="text/javascript"></script>
	<script src="js/tree2_treeview.js" type="text/javascript"></script>
	<script src="js/tree2_demo.js" type="text/javascript"></script>
	<script src="js/jquery-ui.js"></script>	
    <script type="text/javascript">
    	//화면 로딩시 호출
    	function fn_load() {
//     		alert("fn_load");
<%
			if(EisUtil.isNotBlank(msg)) {
				out.print("alert('" + msg + "')");
			}					
%>			
			$("#passwd").focus(); // input박스 아이콘 표시유무 체크
			$("#userid").focus(); // input박스 아이콘 표시유무 체크				
    	}
    	
    	//로그인 처리페이지로 이동
        function fn_login(){
            var userid = $("#userid").val();
            var passwd = $("#passwd").val();            
            if(userid == "") {
            	alert("아이디를 입력해 주세요.");
            	$("#userid").focus();            	
            }
            else if(passwd == "") {
            	alert("비밀번호를 입력해 주세요.");
            	$("#passwd").focus();
            	return;
            } else {
	            //var f = document.getElementById("frm");
	            //f.action = "loginPrc.jsp"
	            //f.submit();
	            
	            // 팝업 방식으로 수정
        		var popUrl = "loginPrc.jsp";
          		popUrl = popUrl + "?userid=" + userid + "&passwd=" + passwd;
        		var left = 0;
        		var top = 0;
        		var lv_with = 1280 - 4;
        		var lv_height = 768 - 4;
        		
        		//var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=no,scrollbars=no,status=no,menubear=no,location=no,toolbar=no;";    //팝업창 옵션(optoin)
        		var popOption = "top="+top+",left="+left+",width="+lv_with+", height="+lv_height+",resizable=yes,scrollbars=no,status=no,menubear=no,location=yes,toolbar=no;";    //팝업창 옵션(optoin)
        		
        		window.open(popUrl,"",popOption);	     
				window.open("","_self", ""); // 경고창없이 닫히게 하기위함
				window.close();				 // 경고창없이 닫히게 하기위함		        		
            }    	    
    	}    	
    </script>
</head>
<body class="login" onload="javascript:fn_load();">
	<div id="login">
		<div class="top_logo">
			<span class="top_logo_red">EIS</span> Login
		</div>
		<form id="frm" name="frm" method="post">
			<ul>
				<li>
					<input type="text" tabindex="1" id="userid" name="userid" maxlenght="20" value="CBO_BO1"
					style="background:#FFF url('images/left_id.png') no-repeat left;font-size:16px;line-height:45px;"  
					onfocus="this.style.backgroundImage='url(none)';" 
					onblur="if(this.value.length==0){this.style.backgroundImage='url(images/left_id.png)'}else{this.style.backgroundImage='url(none)'}"
					/>
				</li>
				<li>
					<input type="password" tabindex="2" name="passwd" id="passwd"  maxlenght="20" value="123123" 
					onkeyup="if(window.event.keyCode=='13'){fn_login();}"
					style="background:#FFF url('images/left_pw.png') no-repeat left;font-size:16px;line-height:45px;"  
					onfocus="this.style.backgroundImage='url(none)';" 
					onblur="if(this.value.length==0){this.style.backgroundImage='url(images/left_pw.png)'}else{this.style.backgroundImage='url(none)'}"
					/>
				</li>
		    </ul>
	    </form>
	    <div class="btn_log">
			<a href="javascript:fn_login();">Login</a>
		</div>
	    <div class="login_notice">
			사번정보가 아닌 EIS 통합계정 정보를 입력하셔야 합니다.
			<br/>
			(계정정보는 EIS 시스템 담당자에게 문의 부탁드립니다.)
		</div>    
	</div>
</form>
</body>
</html>