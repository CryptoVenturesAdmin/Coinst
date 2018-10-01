package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import service.CoinService;
import service.ReviewerService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@Controller
public class ReviewerController extends MainController{
    private String path = "/reviewer";
    @Autowired private CoinService coinService;
    @Autowired private ReviewerService reviewerService;

    @RequestMapping(value = "/reviewer")
    public String reviewer(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        List<HashMap<String,Object>> reviewerList = reviewerService.selectReviewerList(paramMap);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("reviewerList",reviewerList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/reviewer";
    }

    @RequestMapping(value = "/reviewer/reviewerDetail")
    public String reviewerDetail(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try{
            String dev = detectDevice(request,response);
            if(dev != null){
                return dev;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        if(paramMap.get("id") == null){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/reviewer");
        }
        if(paramMap.get("id").toString().equals("")){
            redirectWithAlert(request,response,"잘못된 페이지 접근입니다.","/reviewer");
        }
        HashMap<String,Object> reviewerInfo = reviewerService.selectReviewerInfo(paramMap);
        List<HashMap<String,Object>> reviewCoinList = reviewerService.selectReviewCoinList(paramMap);

        List<HashMap<String,Object>> excList = coinService.selectExchangeList(paramMap);
        HashMap<String,Object> excInfo = coinService.selectExchangeInfo(paramMap);

        request.setAttribute("pageName",path);
        request.setAttribute("reviewerInfo",reviewerInfo);
        request.setAttribute("reviewCoinList",reviewCoinList);
        request.setAttribute("excList",excList);
        request.setAttribute("excInfo",excInfo);
        request.setAttribute("paramMap",paramMap);
        return path+"/reviewerDetail";
    }
}
