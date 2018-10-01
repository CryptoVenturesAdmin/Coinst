package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import service.CoinService;
import service.EventService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;

@Controller
public class EventController extends MainController{
    private String path = "/event";

    @Autowired private CoinService coinService;
    @Autowired private EventService eventService;

    @RequestMapping(value = "/event")
    public String event(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        String today = dateUtil.today(null);
        List<HashMap<String,Object>> yearList = eventService.selectEventSearchYearList(paramMap);
        if(paramMap.get("year") == null || paramMap.get("month") == null){
            paramMap.put("year",today.substring(0,4));
            paramMap.put("month",Integer.parseInt(today.substring(5,7).toString()));
        }
        int month = Integer.parseInt(paramMap.get("month").toString());
        if(month < 10){                    //월 앞에 0 붙는 거 처리
            paramMap.put("month","0"+month);
        }

        HashMap<String,Object> countMap = eventService.selectEventCount(paramMap);
        int totalRow = Integer.parseInt(countMap.get("count").toString());
        String pageInfo = pageUtil.pageNavigation(10,totalRow,paramMap);
//        List<HashMap<String,Object>> monthList = eventService.selectEventSearchMonthList(paramMap);

        List<HashMap<String,Object>> eventList = eventService.selectEventList(paramMap);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("eventList",eventList);
        request.setAttribute("yearList",yearList);
//        request.setAttribute("monthList",monthList);
        request.setAttribute("pageInfo",pageInfo);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/event";
    }

    @RequestMapping(value = "/event/yearSelectAjax")
    public @ResponseBody List<HashMap<String,Object>> yearSelectAjax(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){

        List<HashMap<String,Object>> monthList = eventService.selectEventSearchMonthList(paramMap);

        return monthList;
    }
}
