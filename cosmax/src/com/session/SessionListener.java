package com.session;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import com.crystaldecisions.sdk.framework.IEnterpriseSession;

/**
 * 세션 종료시 BO에 접속중인 Connection 종료
 * - UI레벨에서 종료이벤트를 주었지만
 *   브라우져 프로세스 강제 종료 및 크롬의 경우 UI이벤트 미작동
 * - 서버에 리스너를 두어서 종료되는 세션에 대해서는 강제로 처리
 *
 */
public class SessionListener implements HttpSessionListener {
	
	private Logger logger = Logger.getLogger(this.getClass());
	

	private static int activeSessions = 0;
	
	public SessionListener() {
		logger.info("SessionListener Class Call ####################");
	}
	
	public void sessionCreated(HttpSessionEvent se) {
		logger.info("sessionCreated Method Call ####################");
	}
	
	public void sessionDestroyed(HttpSessionEvent se) {
		
		Date date = null;
		SimpleDateFormat formatter = null;
		HttpSession session = null;	
				
		logger.info("logout Procees Start ***********");		
		try{
			logger.info("sessionDestroyed Method Call ####################");
			
			date = new Date();
			formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			session = se.getSession();				
			date.setTime(session.getLastAccessedTime());
			
			logger.info("session.getId(): " + session.getId());
			logger.info("session.getLastAccessedTime(): " + formatter.format(date));
			
			if (session.getAttribute("enterpriseSession") != null) {
			    IEnterpriseSession enterpriseSession = (IEnterpriseSession) session.getAttribute("enterpriseSession");;		    
			    if(enterpriseSession != null){	
			    	if (session.getAttribute("logonToken") != null) { 
				    	try {
				    		logger.debug("session.getAttribute(logonToken): " + session.getAttribute("logonToken"));
				    		enterpriseSession.getLogonTokenMgr().releaseToken(session.getAttribute("logonToken").toString());
//	 			    		enterpriseSession.getLogonTokenMgr().releaseToken((String)session.getAttribute("logonToken"));
//	 			    		enterpriseSession.getLogonTokenMgr().releaseToken(java.net.URLEncoder.encode(((String)session.getAttribute("logonToken")),"UTF-8"));
				    	} catch (Exception e) {
				    		logger.error(e);
				    	}
			    	}		    			       		    			    	
			    	
					enterpriseSession.logoff();
					enterpriseSession = null;
					logger.info("BO Log Off");				        
			    }		  
			}	    
		}catch(Exception e){
			logger.error(e);
		}
		
		logger.info("logout Procees End ***********");			
	}	
}