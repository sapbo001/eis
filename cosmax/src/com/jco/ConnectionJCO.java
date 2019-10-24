package com.jco;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRepository;

/**
 * EIS JCO Service Class
 */
public class ConnectionJCO {
	private Logger logger = Logger.getLogger(this.getClass());
	
	static String SAP_SERVER = "SAP_SERVER";
	private JCoRepository repos;
	private JCoDestination dest;
	
	
	/**
	 * JCO Connection을 생성
	 * - Jsp에서 Scope를 'Application' 레벨로 세팅하여 중복 생성 방지
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public ConnectionJCO() throws FileNotFoundException, IOException {

		logger.info("ConnectionJCO 객체생성 시작****************");
		
		InputStream is = getClass().getResourceAsStream("/config/sap_conf.properties");
		Properties properties = new Properties();
		properties.load(is);

		SapDestinationDataProvider myProvider = new SapDestinationDataProvider();
		myProvider.changePropertiesForABAP_AS(properties);

		com.sap.conn.jco.ext.Environment.registerDestinationDataProvider(myProvider);

		try {
			dest = JCoDestinationManager.getDestination(SAP_SERVER);
			repos = dest.getRepository();
		} catch (JCoException e) {
			logger.fatal(e);
			throw new RuntimeException(e);
		}
		logger.info("ConnectionJCO 객체생성 종료****************");
	}

	public JCoFunction getFunction(String functionStr) {
		JCoFunction function = null;
		try {
			function = repos.getFunction(functionStr);
		} catch (Exception e) {
			logger.error(e);
			throw new RuntimeException("Problem retrievingJCO.Function object.");
		}

		if (function == null) {
			logger.error("Not possible toreceive function.");
			throw new RuntimeException("Not possible toreceive function."); 
		}
		return function;
	}

	public void execute(JCoFunction function) {
		try {
			JCoContext.begin(dest);
			function.execute(dest);
			JCoContext.end(dest);
		} catch (JCoException e) {
			logger.error(e);
		}
	}

}
