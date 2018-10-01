package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.CoinService;
import service.CompanyService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@Controller
public class CompanyController extends MainController{
    private String path = "/company";

    @Autowired private CoinService coinService;
    @Autowired private CompanyService companyService;

    @RequestMapping(value = "/company")
    public String company(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        List<HashMap<String,Object>> companyList = companyService.selectCompanyList(paramMap);
        if(companyList != null){
            for(HashMap<String,Object> tempMap : companyList){
                tempMap.put("investCoinList",companyService.selectInvestCoinList(tempMap));
            }
        }

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("companyList",companyList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/company";
    }

    @RequestMapping(value = "/company/companyDetail")
    public String companyDetail(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        if(paramMap.get("id") == null){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/company");
        }
        if(paramMap.get("id").toString().equals("")){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/company");
        }
        HashMap<String,Object> companyInfo = companyService.selectInvestInfo(paramMap);
        List<HashMap<String,Object>> investCoinList = companyService.selectInvestCoinDetailList(paramMap);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("companyInfo",companyInfo);
        request.setAttribute("investCoinList",investCoinList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/companyDetail";
    }

}
