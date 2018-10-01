package controller;

import javafx.beans.property.IntegerPropertyBase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.CoinService;
import service.IcoService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class IcoController extends MainController{
    private String path = "/ico";
    @Autowired private CoinService coinService;
    @Autowired private IcoService icoService;

    @RequestMapping(value = "/ico")
    public String ico(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        if(paramMap.get("type") == null){
            paramMap.put("type",0);
        }
        if(Integer.parseInt(paramMap.get("type").toString()) == 3){
            paramMap.put("ico_state",1);
        }else{
            paramMap.put("ico_state",2);
        }
        List<HashMap<String,Object>> icoList = new ArrayList<HashMap<String, Object>>();
        List<HashMap<String,Object>> typeList = coinService.selectCoinTypeList(paramMap);
        List<HashMap<String,Object>> bookmarkList = coinService.selectBookmarkList(request);


        HashMap<String,Object> countMap = icoService.selectIcoCount(paramMap);
        int totalRow = Integer.parseInt(countMap.get("count").toString());
        String pageInfo = pageUtil.pageNavigation(100,totalRow,paramMap);
        if(paramMap.get("type").toString().equals("0")){
            icoList = icoService.selectIcoUpcommingList(paramMap);
        }else if(paramMap.get("type").toString().equals("1")){
            icoList = icoService.selectIcoActiveList(paramMap);
        }else if(paramMap.get("type").toString().equals("2")){
            icoList = icoService.selectIcoEndedList(paramMap);
        }else if(paramMap.get("type").toString().equals("3")){
            icoList = icoService.selectIcoToCoinList(paramMap);
        }

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("icoList",icoList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("bookmarkList",bookmarkList);
        request.setAttribute("pageInfo",pageInfo);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);

        return path+"/icoList";
    }
    @RequestMapping(value = "/ico/icoDetail")
    public String icoDetail(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        if(paramMap.get("id") == null){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/ico");
        }
        if(paramMap.get("id").toString().equals("")){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/ico");
        }
        HashMap<String,Object> icoInfo = icoService.selectIcoInfo(paramMap);
        List<HashMap<String,Object>> linkList = coinService.selectCoinlinkList(paramMap);
        List<HashMap<String,Object>> reviewList = coinService.selectCoinReviewList(paramMap);
        List<HashMap<String,Object>> companyList = coinService.selectCoinCompanyList(paramMap);
        List<HashMap<String,Object>> bookmarkList = coinService.selectBookmarkList(request);

        String today = dateUtil.dateEx(null,0,0,0,0,0,0,"yyyy-MM-01 00:00:01");
        paramMap.put("today",today);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("icoInfo",icoInfo);
        request.setAttribute("linkList",linkList);
        request.setAttribute("bookmarkList",bookmarkList);
        request.setAttribute("reviewList",reviewList);
        request.setAttribute("companyList",companyList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/icoDetail";
    }
}
