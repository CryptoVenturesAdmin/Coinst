package controller;

import common.util.CommonUtil;
import common.util.DateUtil;
import common.util.PageUtil;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class MainController {
    public DateUtil dateUtil = new DateUtil();
    public PageUtil pageUtil = new PageUtil();
    public CommonUtil commonUtil = new CommonUtil();


    public String redirectWithAlert(HttpServletRequest request, HttpServletResponse response, String message, String redirectPath) throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('" + message + "'); location.href='" + redirectPath + "' </script>");
        out.flush();

        String referer = request.getHeader("Refer");
        return "redirect:"+referer;

    }

    public String detectDevice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Device device = DeviceUtils.getCurrentDevice(request);
        String url = "/";
        /*if(device != null){
            if(device.isNormal()){
                url = "/";
            }else if(device.isMobile() || device.isTablet()){
                url = "/isMobile";
                *//*response.setContentType("text/html; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>location.href='" + url + "' </script>");
                out.flush();

                String referer = request.getHeader("Refer");*//*
                return "redirect:"+url;
            }
        }*/
        return null;
    }

    /*@RequestMapping(value = "/mailAjax")
    public @ResponseBody HashMap<String,Object> sendMail(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        GmailSend mail = new GmailSend();
        HashMap<String,Object> returnMap = new HashMap<String, Object>();
        String user = paramMap.get("user").toString();
        System.out.println(user);
        String content = "TESTTEST<br>TESTTEST";
        mail.GmailSet(user, "Gmail 송신 TEST", content);
        returnMap.put("index",1);

        return returnMap;
    }*/
    /*@RequestMapping(value = "/testing")
    public String testing(@RequestParam HashMap<String,Object> paramMap,HttpServletRequest request, HttpServletResponse response){


        return "testing";
    }*/
}
