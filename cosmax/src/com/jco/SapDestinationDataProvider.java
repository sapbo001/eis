package com.jco;

import java.util.Properties;

import javax.print.attribute.standard.Destination;

import org.apache.log4j.Logger;

import com.sap.conn.jco.ext.DestinationDataEventListener;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class SapDestinationDataProvider implements DestinationDataProvider {
	private Logger logger = Logger.getLogger(this.getClass());
	
	static String SAP_SERVER = "SAP_SERVER";
	private DestinationDataEventListener eventListener;
	private Properties ABAP_AS_properties;

	public Properties getDestinationProperties(String art0) {
		return ABAP_AS_properties;
	}

	public void setDestinationDataEventListener(Destination DataEventListenereventListener) {
		this.eventListener = eventListener;
	}

	public boolean supportsEvents() {
		return true;
	}

	public void changePropertiesForABAP_AS(Properties properties) {
		if (properties == null) {
			eventListener.deleted("SAP_SERVER");
			ABAP_AS_properties = null;
		}

		else {
			if (ABAP_AS_properties != null && !ABAP_AS_properties.equals(properties))
				eventListener.updated("SAP_SERVER");
			ABAP_AS_properties = properties;
		}
	}

	@Override
	public void setDestinationDataEventListener(DestinationDataEventListener arg0) {
		// TODO Auto-generated method stub
		
	}

}
