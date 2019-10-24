package com.util;

import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

public class ReadProperties {
	private Logger logger = Logger.getLogger(this.getClass());
	
	String propertyValue = "";

	public ReadProperties() {

	}

	public String getProperty(String fileName, String propertyName) {

		if (fileName == null) {
			fileName = "/config/bo_conf.properties";
		}

		try {
			InputStream is = getClass().getResourceAsStream(fileName);
			Properties properties = new Properties();
			properties.load(is);

			propertyValue = properties.getProperty(propertyName);

		} catch (Exception e) {
			logger.error(e);
		}

		return propertyValue;
	}

}
