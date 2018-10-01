package common.util;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import sun.net.www.protocol.http.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.sql.*;
import java.util.HashMap;
import java.util.List;

public class CommonUtil {

    public void setCookie(HashMap<String,Object> paramMap, HttpServletResponse response){
        Cookie cookie = new Cookie(paramMap.get("id").toString(),"true");
        cookie.setMaxAge(60*60*24);     //기간 하루로 설정
        cookie.setPath("/");            //모든 페이지에서 쿠키 리스트 볼 수 있게 설정
        response.addCookie(cookie);
    }
    public void removeCookie(HashMap<String,Object> paramMap, HttpServletResponse response){
        Cookie cookie = new Cookie(paramMap.get("id").toString(),null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
    public boolean existCookie(HashMap<String,Object> paramMap, HttpServletRequest request){
        boolean rtnBool = false;
        Cookie[] cookie = request.getCookies();
        if(cookie != null) {
            for (Cookie c : cookie) {
                if(!c.getName().equals("JSESSIONID")) {
                    if (paramMap.get("id").toString().equals(c.getName()) && "true".equals(c.getValue())) {
                        rtnBool = true;
                    }
                }
            }
        }
        return rtnBool;
    }
    public String errorMsg(int errorNum){
        String msg = "";
        if(errorNum == 400){
            msg = "잘못된 요청입니다.";
        }else if(errorNum == 403){
            msg = "접근이 금지되었습니다.";
        }else if(errorNum == 404){
            msg = "요청하신 페이지는 존재하지 않습니다.";
        }else if(errorNum == 405){
            msg = "요청된 메소드가 허용되지 않습니다. 관리자에게 문의하세요.";
        }else if(errorNum == 500){
            msg = "서버에 오류가 발생하였습니다. 관리자에게 문의하세요.";
        }else if(errorNum == 503){
            msg = "서비스를 사용할 수 없습니다. 관리자에게 문의하세요.";
        }else{
            msg = "예외가 발생했습니다. 관리자에게 문의하세요.";
        }
        return msg;
    }
    public HashMap<String,HashMap<String,Object>> marketDataInput(HashMap<String,HashMap<String,Object>> marketMap){
        HashMap<String,HashMap<String,Object>> rtnMap = new HashMap<String,HashMap<String,Object>>();
        while (true){
            if(marketMap.size() != 0){
                rtnMap.putAll(marketMap);
                break;
            }
        }
        return rtnMap;
    }

}
