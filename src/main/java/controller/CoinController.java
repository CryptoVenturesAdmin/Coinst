package controller;

import common.init.*;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import service.CoinService;
import service.CompanyService;
import service.ReviewerService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class CoinController extends MainController{

    private String path = "/coin";
    @Autowired private CoinService coinService;
    @Autowired private CompanyService companyService;
    @Autowired private ReviewerService reviewerService;


    @RequestMapping(value = {"/", "/coin"})
    public String main(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        paramMap.put("ico_state",0);

        HashMap<String,Object> countMap = coinService.selectCoinCount(paramMap);        //페이징을 위한 리스트 카운팅
        int totalRow = Integer.parseInt(countMap.get("count").toString());
        String pageInfo = pageUtil.pageNavigation(100,totalRow,paramMap);       //페이징
        List<HashMap<String,Object>> coinList =  coinService.selectCoinList(paramMap);  //상장된 코인 리스트

        List<HashMap<String,Object>> typeList = coinService.selectCoinTypeList(paramMap);       //코인 구분 리스트

        List<HashMap<String,Object>> bookmarkList = coinService.selectBookmarkList(request);    //북마크한 코인 리스트

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("coinList",coinList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("bookmarkList",bookmarkList);
        request.setAttribute("pageInfo",pageInfo);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);

        return path+"/coin";
    }

    @RequestMapping(value = "/coin/coinDetail")
    public String coinDetail(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        if(paramMap.get("id") == null){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/");
        }
        if(paramMap.get("id").toString().equals("")){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/");
        }

        HashMap<String,Object> coinInfo = coinService.selectCoinInfo(paramMap);
        if(coinInfo.get("coin_id") != null) {
            paramMap.put("coin_id", coinInfo.get("coin_id"));
        } else {
            redirectWithAlert(request,response,"더 이상 존재하지 않는 정보입니다.","/");
        }
        List<HashMap<String,Object>> eventList = coinService.selectCoinEventList(paramMap);
        List<HashMap<String,Object>> linkList = coinService.selectCoinlinkList(paramMap);
        List<HashMap<String,Object>> graphDataList = coinService.selectCoinGraphDataList(paramMap);
        List<HashMap<String,Object>> reviewList = coinService.selectCoinReviewList(paramMap);
        List<HashMap<String,Object>> companyList = coinService.selectCoinCompanyList(paramMap);
        List<HashMap<String,Object>> bookmarkList = coinService.selectBookmarkList(request);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("coinInfo",coinInfo);
        request.setAttribute("eventList",eventList);
        request.setAttribute("linkList",linkList);
        request.setAttribute("graphDataList",graphDataList);
        request.setAttribute("reviewList",reviewList);
        request.setAttribute("companyList",companyList);
        request.setAttribute("bookmarkList",bookmarkList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);

        return path+"/coinDetail";
    }

    @RequestMapping(value = "/coin/searchCoinAjax")
    public @ResponseBody List<HashMap<String,Object>> searchCoinAjax(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        List<HashMap<String,Object>> coinList = coinService.selectCoinAjaxList(paramMap);
        List<HashMap<String,Object>> companyList = companyService.selectCompanyAjaxList(paramMap);
        List<HashMap<String,Object>> reviewerList = reviewerService.selectReviewerAjaxList(paramMap);
        coinList.addAll(companyList);
        coinList.addAll(reviewerList);
        return coinList;
    }
    @RequestMapping(value = "/coin/setBookmarkAjax")
    public @ResponseBody HashMap<String,Object> setBookmarkAjax(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception{
        if(paramMap.get("id") == null){       //param name이 null값 일때 에러 문제
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/");
        }
        if(paramMap.get("id").toString().equals("")){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/");
        }

        if(commonUtil.existCookie(paramMap,request)){
            commonUtil.removeCookie(paramMap,response);
        }else{
            commonUtil.setCookie(paramMap,response);
        }
        paramMap.put("result",true);
        return paramMap;
    }

    @RequestMapping(value="/error")
    public String error(@RequestParam HashMap<String,Object> paramMap,HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        int errorNum = 0;
        if(paramMap.get("num") != null){
            errorNum = Integer.parseInt(paramMap.get("num").toString());
        }
        String msg = commonUtil.errorMsg(errorNum);

        request.setAttribute("errorNum",errorNum);
        request.setAttribute("msg",msg);

        return "error";
    }

    @RequestMapping(value = "/egalNotice")
    public String egalNotice(@RequestParam HashMap<String,Object> paramMap,HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return "egalNotice";
    }

    @RequestMapping(value="/isMobile")
    public String isMobile(@RequestParam HashMap<String,Object> paramMap,HttpServletRequest request, HttpServletResponse response){

        return "/isMobile";
    }

    /*@RequestMapping(value="/testing")
    public String testing(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception{
        MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();
        List<HashMap<String,Object>> symbolList = marketDataSingleton.coinList;
        List<HashMap<String,Object>> marketList = new ArrayList<HashMap<String,Object>>();
        List<String> list = new ArrayList<String>();
        list.add("Bithumb");
        list.add("Upbit");
        list.add("Coinone");
        list.add("Binance");
        list.add("Bitfinex");
        for(String str : list) {
            HashMap<String, Object> temp = new HashMap<String, Object>();
            temp.put("name", str);
            marketList.add(temp);
        }

        request.setAttribute("symbolList",symbolList);
        request.setAttribute("marketList",marketList);
        return "testing";
    }*/


}
