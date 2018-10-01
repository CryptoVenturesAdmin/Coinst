package service;

import mapper.CoinMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

@Service
public class CoinService {
    @Resource private CoinMapper coinMapper;

    public List<HashMap<String,Object>> selectCoinAjaxList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinAjaxList(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinList(HashMap<String,Object> paramMap) {
        return coinMapper.selectCoinList(paramMap);
    }
    public HashMap<String,Object> selectCoinCount(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinCount(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinTypeList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinTypeList(paramMap);
    }
    public HashMap<String,Object> selectCoinInfo(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinInfo(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinlinkList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinlinkList(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinGraphDataList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinGraphDataList(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinEventList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinEventList(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinReviewList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinReviewList(paramMap);
    }
    public List<HashMap<String,Object>> selectCoinCompanyList(HashMap<String,Object> paramMap){
        return coinMapper.selectCoinCompanyList(paramMap);
    }
    public List<HashMap<String,Object>> selectBookmarkList(HttpServletRequest request){
        List<HashMap<String,Object>> bookmarkList = new ArrayList<HashMap<String, Object>>();
        Cookie[] cookie = request.getCookies();
        HashMap<String,Object> tempMap;
        if(cookie != null) {
            for (Cookie c : cookie) {
                if(!c.getName().equals("JSESSIONID")) {
                    tempMap = new HashMap<String, Object>();
                    if (c.getValue().equals("true")){
                        tempMap.put("ico_id", c.getName());
                    }
                    bookmarkList.add(tempMap);
                }
            }
        }
        return bookmarkList;
    }
    public List<HashMap<String,Object>> selectCoinSymbolForMarketData(){
        return coinMapper.selectCoinSymbolForMarketData();
    }
    public List<HashMap<String,Object>> selectExchangeList(HashMap<String,Object> paramMap){
        return coinMapper.selectExchangeList(paramMap);
    }
    public HashMap<String,Object> selectExchangeInfo(HashMap<String,Object> paramMap){
        return coinMapper.selectExchangeInfo(paramMap);
    }
}
