package com.menu;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Vector;
import java.util.Locale;

import com.crystaldecisions.sdk.framework.CrystalEnterprise;
import com.crystaldecisions.sdk.framework.IEnterpriseSession;
import com.jco.ConnectionJCO;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoTable;
import com.util.EisUtil;
import com.util.ReadProperties;

import org.apache.log4j.Logger;

/**
 * EIS Menu & User Service Class
 */
public class MenuService {
	private Logger logger = Logger.getLogger(this.getClass());
	
	public MenuInfo menuInfo = null;
	public UserInfo userInfo = null;
	public IEnterpriseSession enterpriseSession = null;

	/**
	 * SAP의 User테이블 조회하는 Fuction을 호출 후 리턴값 세팅
	 * User Table Data: ZBWT001/ZBWT002 
	 * Fuction: ZBW_EIS_USER
	 * - 그룹웨어에서 접속한 경우: 사번만 들어오고 유저ID 및 비번은 빈값으로 넘어옴
	 * - 포탈 로그인페이지에서 접속한 경우: 유저ID와 비번 만 들어옴 
	 * @param conJCO JCO Connection Object
	 * @param sabun 사번
	 * @param userid 유저ID
	 * @param passwd 유저비번
	 * @return UserInfo 유저정보
	 */
	public UserInfo getUser(ConnectionJCO conJCO, String sabun, String userid, String passwd) {
		
		JCoFunction function = null;
		JCoTable table = null;
		int tableRows = 0;
		try {			
			function = conJCO.getFunction("ZBW_EIS_USER");
				                     			
			function.getImportParameterList().setValue("I_SABUN", sabun); // (RFC 변수명, 값)-사번(그룹웨어에서 접속한 경우)
			function.getImportParameterList().setValue("I_USERID", userid); // (RFC 변수명, 값)-EIS 대표계정(로그인페이지 접속)
			function.getImportParameterList().setValue("I_USERPWD", passwd); // (RFC 변수명, 값)-EIS 유저PASSWORD(로그인페이지 접속)

			conJCO.execute(function);
			table = function.getTableParameterList().getTable("T_DATA");
			userInfo = null;
			if (table != null) {
				tableRows = table.getNumRows();				
			}
			if (tableRows > 0) {
				userInfo = new UserInfo();

				userInfo.setZEIS_USER_ID(EisUtil.null2Blank(table.getString("ZEIS_USER_ID")));
				userInfo.setZEIS_USER_PW(EisUtil.null2Blank(table.getString("ZEIS_USER_PW")));
				userInfo.setZEIS_USER_NM(EisUtil.null2Blank(table.getString("ZEIS_USER_NM")));
			}
			logger.debug("tableRows: " + tableRows);
		} catch (Exception e) {
			logger.error(e);
		}
		return userInfo;
	}	
	
	/**
	 * SAP의 PFCG에 등록된 메뉴정보를 조회하는 Fuction을 호출 후 리턴값 세팅
	 * PFCG-ROLE: ZEIS_M_TOTAL
	 * Fuction: ZBW_EIS_MENU
	 * @param conJCO JCO Connection Object
	 * @param userid 유저ID
	 * @param langu 언어 <-- BO에 해당 User로 세팅되어 있는 로케일값을 이용
	 * @return Vector<MenuInfo> 메뉴정보 리스트
	 */	
	public Vector<MenuInfo> getMenu(ConnectionJCO conJCO, String userid, String langu) {
		Vector<MenuInfo> list = new Vector<MenuInfo>();

		try {
						
			JCoFunction function = conJCO.getFunction("ZBW_EIS_MENU");
			
//			function.getImportParameterList().setValue("I_USERID", "CBO_BO1"); // 테스트계정 (RFC 변수명, 값)
			function.getImportParameterList().setValue("I_USERID", userid); // (RFC 변수명, 값) - EIS 대표계정
			function.getImportParameterList().setValue("I_LANGU", langu); // (RFC 변수명, 값) - 3:한국어,E:영어,1:중국어,J:일본어

			conJCO.execute(function);

			JCoTable table = function.getTableParameterList().getTable("T_DATA");			

			menuInfo = null;

			if (table.getNumRows() > 0) {
				for (int i = 0; i < table.getNumRows(); i++) {
					menuInfo = new MenuInfo();

					menuInfo.setZLEVEL1(EisUtil.null2Blank(table.getString("ZLEVEL1")));
					menuInfo.setZLEVEL2(EisUtil.null2Blank(table.getString("ZLEVEL2")));
					menuInfo.setZLEVEL3(EisUtil.null2Blank(table.getString("ZLEVEL3")));
					menuInfo.setZTEXT(EisUtil.null2Blank(table.getString("ZTEXT")));
					menuInfo.setZTEMP_ID(EisUtil.null2Blank(table.getString("ZTEMP_ID")));
					menuInfo.setZURL(EisUtil.null2Blank(table.getString("ZURL")));
					menuInfo.setZNODE_TYPE(EisUtil.null2Blank(table.getString("ZNODE_TYPE")));
					menuInfo.setZPARAM(EisUtil.null2Blank(table.getString("ZPARAM")));
					menuInfo.setZTEXT_LANG(EisUtil.null2Blank(table.getString("ZTEXT_LANG")));
					menuInfo.setZEIS_DATE(EisUtil.null2Blank(table.getString("ZEIS_DATE")));
					menuInfo.setZSTART_MENU_YN(EisUtil.null2Blank(table.getString("ZSTART_MENU_YN")));

					list.addElement(menuInfo);
				
					table.nextRow();
				}
			}
		} catch (Exception e) {
			logger.error(e);
		}
		return list;
	}
	
	
	/**
	 * SAP의 메뉴중 초기화면으로 세팅되어 있는 화면에 대한 정보를 조회
	 * - 세팅되어 있는 화면이 없거나 해당 메뉴가 PFCG와 일치하지 않는 경우에는 첫번째 화면을 초기화면으로 세팅
	 * @param vlist 메뉴정보 리스트
	 * @return MenuInfo 메뉴정보 리스트
	 */
	public MenuInfo getStartMenu(Vector<MenuInfo> vlist) {
		Vector<MenuInfo> list = new Vector<MenuInfo>();
		MenuInfo menuInfo = new MenuInfo();
		MenuInfo menuInfoTemp = null;

		try {
			if (vlist != null) 
				list = vlist;
			
			int screen_index = 0;
			for(int i = 0 ; i < list.size() ; i++) {
				menuInfoTemp = (MenuInfo)list.elementAt(i);
				if(menuInfoTemp.getZNODE_TYPE().equals("U")) { //화면 레벨인 것만 가져오기
					
					if( screen_index == 0) { // 초기화면 미설정시에는 첫번째 화면으로 초기화면값 세팅
						menuInfo.setZLEVEL1(EisUtil.null2Blank(menuInfoTemp.getZLEVEL1()));
						menuInfo.setZLEVEL2(EisUtil.null2Blank(menuInfoTemp.getZLEVEL2()));
						menuInfo.setZLEVEL3(EisUtil.null2Blank(menuInfoTemp.getZLEVEL3()));
						menuInfo.setZTEXT(EisUtil.null2Blank(menuInfoTemp.getZTEXT()));
						menuInfo.setZTEMP_ID(EisUtil.null2Blank(menuInfoTemp.getZTEMP_ID()));
						menuInfo.setZURL(EisUtil.null2Blank(menuInfoTemp.getZURL()));
						menuInfo.setZNODE_TYPE(EisUtil.null2Blank(menuInfoTemp.getZNODE_TYPE()));
						menuInfo.setZPARAM(EisUtil.null2Blank(menuInfoTemp.getZPARAM()));
						menuInfo.setZTEXT_LANG(EisUtil.null2Blank(menuInfoTemp.getZTEXT_LANG()));
						menuInfo.setZEIS_DATE(EisUtil.null2Blank(menuInfoTemp.getZEIS_DATE()));
						menuInfo.setZSTART_MENU_YN(EisUtil.null2Blank(menuInfoTemp.getZSTART_MENU_YN()));
						
					} else if(menuInfoTemp.getZSTART_MENU_YN().equals("X")) { // 초기화면이 설정되어 있는 경우에는 해당 화면으로 초기화면값 세팅
						menuInfo.setZLEVEL1(EisUtil.null2Blank(menuInfoTemp.getZLEVEL1()));
						menuInfo.setZLEVEL2(EisUtil.null2Blank(menuInfoTemp.getZLEVEL2()));
						menuInfo.setZLEVEL3(EisUtil.null2Blank(menuInfoTemp.getZLEVEL3()));
						menuInfo.setZTEXT(EisUtil.null2Blank(menuInfoTemp.getZTEXT()));
						menuInfo.setZTEMP_ID(EisUtil.null2Blank(menuInfoTemp.getZTEMP_ID()));
						menuInfo.setZURL(EisUtil.null2Blank(menuInfoTemp.getZURL()));
						menuInfo.setZNODE_TYPE(EisUtil.null2Blank(menuInfoTemp.getZNODE_TYPE()));
						menuInfo.setZPARAM(EisUtil.null2Blank(menuInfoTemp.getZPARAM()));
						menuInfo.setZTEXT_LANG(EisUtil.null2Blank(menuInfoTemp.getZTEXT_LANG()));
						menuInfo.setZEIS_DATE(EisUtil.null2Blank(menuInfoTemp.getZEIS_DATE()));
						menuInfo.setZSTART_MENU_YN(EisUtil.null2Blank(menuInfoTemp.getZSTART_MENU_YN()));								
						
					}
					screen_index++;	// 화면레벨 인덱스 증가			
				}
			}
		
		} catch (Exception e) {
			logger.error(e);
		}
		return menuInfo;
	}	
	
	

	/**
	 * 해당 유저정보(ID&Password)를 가지고 BO에 로그인
	 * - /config/bo_conf.properties: BO접속정보를 가지고 있는 설정파일
	 * @param userInfo 유저정보
	 * @return IEnterpriseSession BO 세션객체
	 */
	public IEnterpriseSession setSession(UserInfo userInfo) {
		String fileName = "/config/bo_conf.properties";

		try {

			ReadProperties rp = new ReadProperties();

			String hostName = rp.getProperty(fileName, "bo.hostName");
			String BO_CMS_NAME = hostName + ":6400";
			String BO_AUTH_TYPE = rp.getProperty(fileName, "bo.authtype");
			String BO_USERNAME = rp.getProperty(fileName, "bo.prefixUser") + userInfo.getZEIS_USER_ID();//userInfo			
			String BO_PASSWORD = userInfo.getZEIS_USER_PW();
			logger.debug("BO_AUTH_TYPE : " + BO_AUTH_TYPE);
			logger.debug("BO_USERNAME : " + BO_USERNAME);
			logger.debug("BO_PASSWORD : " + BO_PASSWORD);
						
			enterpriseSession = CrystalEnterprise.getSessionMgr().logon(BO_USERNAME, BO_PASSWORD,
					BO_CMS_NAME, BO_AUTH_TYPE);												
							
		} catch (Exception e) {
			logger.error(e);
		}
		return enterpriseSession;
	}

}
