package com.util;

import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.ext.Environment;

public class RfcManager {
	private static Logger logger = Logger.getLogger(RfcManager.class);
	
	private static String ABAP_AS_POOLED = "ABAP_AS_POOLED";
	private static JCOProvider provider = null;
	private static JCoDestination destination = null;

	static {
		Properties properties = loadProperties();

		provider = new JCOProvider();

		// catch IllegalStateException if an instance is already registered
		try {
			Environment.registerDestinationDataProvider(provider);
		} catch (IllegalStateException e) {
			logger.error(e);
		}

		provider.changePropertiesForABAP_AS(ABAP_AS_POOLED, properties);
	}

	public static Properties loadProperties() {
		RfcManager manager = new RfcManager();
		Properties prop = new Properties();
		try {
			prop.load(manager.getClass().getResourceAsStream("/config/sap_conf.properties"));
		} catch (IOException e) {
			logger.error(e);
		}
		return prop;
	}

	public static JCoDestination getDestination() throws JCoException {
		if (destination == null) {
			destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
		}
		return destination;
	}

	public static JCoFunction getFunction(String functionName) {
		JCoFunction function = null;
		try {
			function = getDestination().getRepository().getFunctionTemplate(functionName)
					.getFunction();
		} catch (JCoException e) {
			logger.error(e);
		} catch (NullPointerException e) {
			logger.error(e);
		}
		return function;
	}

	public static void execute(JCoFunction function) {		
		logger.info("SAP Function Name : " + function.getName());
		JCoParameterList paramList = function.getImportParameterList();

		if (paramList != null) {		
			logger.info("Function Import Structure : " + paramList.toString());
		}

		try {
			function.execute(getDestination());
		} catch (JCoException e) {
			logger.error(e);
		}
		paramList = function.getExportParameterList();

		if (paramList != null) {
			logger.info("Function Export Structure : " + paramList.toString());
		}
	}

	/*
	 * SAP 연결 Ping 테스트
	 */
	public static String ping() {
		String msg = null;
		try {
			getDestination().ping();
			msg = "Destination " + ABAP_AS_POOLED + " works";
		} catch (JCoException ex) {
			// msg = StringUtil.getExceptionTrace(ex);
			logger.error(ex);
		}		
		logger.info(msg);
		return msg;
	}

	public static void main(String[] args) {
		RfcManager.ping();
	}
}
