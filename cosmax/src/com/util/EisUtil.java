package com.util;

public class EisUtil {
	
    /**
     * str의 값이 null이거나 ""이면 true을 리턴하고, null이거나 ""이 아니면 false를 리턴한다.
     * @param str 체크str
     * @return String - 값의 존재유무(true, false)     
     */
    public static boolean isBlank(String str)
    {
        if(str == null || str.length() == 0)
            return true;
        else if ("".equals(str.trim())) return true;
        else return false;
    }
        
    /**
     * str의 값이 null이거나 ""이면 false을 리턴하고, null이거나 ""이 아니면 true를 리턴한다.
     * @param str 체크str
     * @return String - 값의 존재유무(true, false)s  
     */
    public static boolean isNotBlank(String str)
    {
    	if(str == null || str.length() == 0)
            return false;
        else if ("".equals(str.trim())) return false;
        else return true;
    }
    
    /**
     * str의 값이 null이면 ""을 리턴하고, null 이 아니면 str를 리턴한다.
     * @param str 바꿀string
     * @return String
     *         str == null? "":str
     */
    public static String null2Blank(String str) {
        return (str == null? "": str);
    }
	

}
