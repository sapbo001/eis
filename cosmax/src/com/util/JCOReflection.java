package com.util;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

public class JCOReflection {
	private Logger logger = Logger.getLogger(this.getClass());

	/*
	 * Reflect object field to JCO Parameter List
	 */
	public static void importJCOParam(JCoParameterList importParam, Object object)
			throws IllegalArgumentException, IllegalAccessException {
		Class<?> c = object.getClass();
		Field[] fields = c.getDeclaredFields();
		for (Field field : fields) {
			field.setAccessible(true);
			if (field.getType() == String.class) {
				importParam.setValue(field.getName(), field.get(object));
			}
		}
	}

	/*
	 * Reflect JCO Parameter List to Object
	 */
	public static Object exportJCOParam(JCoParameterList exportParam, Object object)
			throws IllegalArgumentException, IllegalAccessException {
		Class<?> c = object.getClass();
		Field[] fields = c.getDeclaredFields();
		for (Field field : fields) {
			if (field.getType() == String.class) {
				field.setAccessible(true);
				field.set(object, exportParam.getValue(field.getName()));
			}
		}
		return object;
	}

	/*
	 * Reflect JCO Table to Object List
	 */
	public static List<?> exportJCOTable(JCoTable table, Class<?> clazz)
			throws InstantiationException, IllegalAccessException {
		List<Object> list = new ArrayList<Object>();
		Field[] fields = clazz.getDeclaredFields();

		for (int i = 0; i < table.getNumRows(); i++) {
			table.setRow(i);
			Object object = clazz.newInstance();
			for (Field field : fields) {
				if (field.getType() == String.class) {
					field.setAccessible(true);
					field.set(object, table.getString(field.getName()));
				}
			}
			list.add(object);
		}
		return list;
	}

	/*
	 * Relect Object List to JCO Table
	 */
	public static void importJCOTable(JCoTable table, List<?> list)
			throws IllegalArgumentException, IllegalAccessException {

		for (int i = 0; i < list.size(); i++) {
			table.insertRow(i);
			Object object = list.get(i);
			Field[] fields = object.getClass().getDeclaredFields();
			for (Field field : fields) {
				if (field.getType() == String.class) {
					field.setAccessible(true);
					table.setValue(field.getName(), field.get(object));
				}
			}
		}
	}

	public static void main(String[] args) throws IllegalArgumentException, IllegalAccessException {

	}

}
