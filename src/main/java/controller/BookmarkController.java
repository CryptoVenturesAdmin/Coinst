package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.CoinService;
import service.IcoService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class BookmarkController extends MainController {
    private String path = "/bookmark";

    @Autowired private CoinService coinService;
    @Autowired private IcoService icoService;

    @RequestMapping(value = "/bookmark")
    public String bookmark(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        paramMap.put("isBook","Y");
        if(paramMap.get("type") == null){
            paramMap.put("type",0);
        }

        int type = Integer.parseInt(paramMap.get("type").toString());

        if(type == 0){
            paramMap.put("ico_state",0);
        }else {
            paramMap.put("ico_state",2);
        }

        List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
        List<HashMap<String,Object>> typeList = new ArrayList<HashMap<String, Object>>();
        List<HashMap<String,Object>> bookmarkList = coinService.selectBookmarkList(request);

        if(bookmarkList.size() > 0){
            String bookedCoin = "";
            for(HashMap<String,Object> temp : bookmarkList){
                if(temp.get("ico_id") != null) {
                    bookedCoin += temp.get("ico_id").toString() + ",";
                }
            }
            if(!bookedCoin.equals("")) {
                bookedCoin = bookedCoin.substring(0, bookedCoin.length() - 1);
                paramMap.put("bookedCoin", bookedCoin);
                typeList = coinService.selectCoinTypeList(paramMap);
            }
        }

        if(type == 0){
            list = coinService.selectCoinList(paramMap);
        }else{
            list = icoService.selectIcoList(paramMap);
        }

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("list",list);
        request.setAttribute("typeList",typeList);
        request.setAttribute("bookmarkList",bookmarkList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);

        return path+"/bookmark";
    }
}
