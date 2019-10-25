<%@page import="java.util.*"%>
<%@page import="com.menu.*"%>
<%@page import="com.util.*"%>
<%@ page import="java.net.*"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Logger logger = Logger.getLogger(this.getClass());
		
	String msg = URLDecoder.decode(EisUtil.null2Blank(request.getParameter("msg")),"UTF-8");
// 	String prcYN = EisUtil.null2Blank(request.getParameter("prcYN"));
// 	logger.debug("msg: " + msg);
// 	logger.debug("request msg: " + request.getParameter("msg"));
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
        function fn_pwdchg_prc(){
            var userid = $("#userid").val();
            var passwd_old = $("#passwd_old").val();
            var passwd_new = $("#passwd_new").val();
            var passwd_new_confirm = $("#passwd_new_confirm").val();
            if(userid == "") {
            	alert("[아이디]를 입력해 주세요.");
            	$("#userid").focus();            	
            }
            else if(passwd_old == "") {
            	alert("[현재 비밀번호]를 입력해 주세요.");
            	$("#passwd_old").focus();
            	return;            	            
            } else if(passwd_new == "") {
            	alert("[새 비밀번호]를 입력해 주세요.");
            	$("#passwd_new").focus();
            	return;            	            
            } else if(passwd_new_confirm == "") {
            	alert("[새 비밀번호 확인]을 입력해 주세요.");
            	$("#passwd_new_confirm").focus();
            	return;            	            
            } else if(passwd_new != passwd_new_confirm) {
            	alert("[새 비밀번호]와 [새 비밀번호 확인]란에 입력한 값이 일치하지 않습니다.");
            	$("#passwd_new_confirm").focus();
            	return;
            } else if (userid == passwd_new) {
				alert("[아이디]와 [새 비밀번호]가 동일합니다.");     
				$("#passwd_new").focus();
            } else {

	            var f = document.getElementById("frm");
	            f.action = "pwdchgPrc.jsp"
	            f.submit();            		       
            }    	    
    	}    	
    </script>
</head>`
<body class="password">
	<div id="password">
	<div class="top_password"><span class="top_password_red">EIS</span> 비밀번호 변경</div>	
		<form id="frm" name="frm" method="post">
		<ul>
				<li>
					<input type="text" tabindex="1" id="userid" name="userid" maxlenght="20" value="" 
					       style="background:#FFF url('images/img_20160517_03.png') no-repeat left; font-size:16px;line-height:45px;"  
   							onfocus="this.style.backgroundImage='url(none)';" onblur="if(this.value.length==0){this.style.backgroundImage='url(images/img_20160517_03.png)'}else{this.style.backgroundImage='url(none)'}"/>
				</li>
				<li>
					<input type="password" tabindex="1" id="passwd_old" name="passwd_old" maxlenght="20" value="" 
					              style="background:#FFF url('images/img_20160517_04.png') no-repeat left; font-size:16px;line-height:45px;"  
                                  onfocus="this.style.backgroundImage='url(none)';" onblur="if(this.value.length==0){this.style.backgroundImage='url(images/img_20160517_04.png)'}else{this.style.backgroundImage='url(none)'}"/>
				</li>
    	</ul>
    	<ul class="input_top_password">				
				<li>
					<input type="password" tabindex="1" id="passwd_new" name="passwd_new" maxlenght="20" value="" 
					              style="background:#FFF url('images/img_20160517_05.png') no-repeat left; font-size:16px;line-height:45px;"  
                                  onfocus="this.style.backgroundImage='url(none)';" onblur="if(this.value.length==0){this.style.backgroundImage='url(images/img_20160517_05.png)'}else{this.style.backgroundImage='url(none)'}"/>
				</li>
												<li>
					<input type="password" tabindex="1" id="passwd_new_confirm" name="passwd_new_confirm" maxlenght="20" value="" 
					                onkeyup="if(window.event.keyCode=='13'){fn_pwdchg_prc();}"
					                style="background:#FFF url('images/img_20160517_06.png') no-repeat left; font-size:16px;line-height:45px;"  
                                    onfocus="this.style.backgroundImage='url(none)';" onblur="if(this.value.length==0){this.style.backgroundImage='url(images/img_20160517_06.png)'}else{this.style.backgroundImage='url(none)'}"/>
				</li>
		    </ul>
	    </form>
	    <div class="btn_log">
			<a href="javascript:fn_pwdchg_prc();">비밀번호 변경</a>
		</div>
	    <div class="login_notice">
			아이디 및 비밀번호 모두 대소문자를 구별합니다.
			<br/>			
			<br/>
			<br/>
		</div>		
	</div>
			
</form>
</body>
</html>