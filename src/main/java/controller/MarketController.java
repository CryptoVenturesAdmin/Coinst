package controller;

import common.init.MarketDataSingleton;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import service.CoinService;
import service.IcoService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
public class MarketController extends MainController {
    private String path = "/market";

    @Autowired private CoinService coinService;
    @Autowired private IcoService icoService;

    @RequestMapping(value = "/market")
    public String bookmark(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();
        List<HashMap<String,Object>> symbolList = marketDataSingleton.coinList;
        List<HashMap<String,Object>> marketList = new ArrayList<HashMap<String,Object>>();
        List<String> list = new ArrayList<String>();
        list.add("Bitfinex");
        list.add("Binance");
        list.add("Bithumb");
        list.add("Upbit");
        list.add("Coinone");
        for(String str : list) {
            HashMap<String, Object> temp = new HashMap<String, Object>();
            temp.put("name", str);
            marketList.add(temp);
        }

        request.setAttribute("pageName",path);
        request.setAttribute("symbolList",symbolList);
        request.setAttribute("marketList",marketList);
        return path+"/market";
    }
    @RequestMapping(value = "/marketDataAjax")
    public @ResponseBody List<HashMap<String,HashMap<String,Object>>> marketDataAjax(@RequestParam HashMap<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response){
        MarketDataSingleton marketDataSingleton = MarketDataSingleton.getInstance();
        List<HashMap<String,HashMap<String,Object>>> rtnList = new ArrayList<HashMap<String,HashMap<String,Object>>>();
        rtnList.add(commonUtil.marketDataInput(marketDataSingleton.bitfinexDataMap));
        rtnList.add(commonUtil.marketDataInput(marketDataSingleton.binanceDataMap));
        rtnList.add(commonUtil.marketDataInput(marketDataSingleton.bithumbDataMap));
        rtnList.add(commonUtil.marketDataInput(marketDataSingleton.upbitDataMap));
        rtnList.add(commonUtil.marketDataInput(marketDataSingleton.coinoneDataMap));
        return rtnList;
    }
}
