package service;


import mapper.ApiMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service
public class ApiService {
    @Resource private ApiMapper apiMapper;

    public HashMap<String,Object> selectCoinMarketCalCheck(HashMap<String,Object> paramMap) throws Exception{
        return apiMapper.selectCoinMarketCalCheck(paramMap);
    }
    public HashMap<String,Object> selectCoinMarketCalEventCheck(HashMap<String,Object> paramMap) throws Exception{
        return apiMapper.selectCoinMarketCalEventCheck(paramMap);
    }

    public void updateCoinMarketCalEventInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.updateCoinMarketCalEventInfo(paramMap);}

    public void insertCoinMarketCalEventInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.insertCoinMarketCalEventInfo(paramMap);}

    public void updateCoinMarketCapInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.updateCoinMarketCapInfo(paramMap);}

    public void insertCoinMarketCapInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.insertCoinMarketCapInfo(paramMap);}

    public void insertCoinMarketCapList(HashMap<String,Object> paramMap) throws Exception{apiMapper.insertCoinMarketCapList(paramMap);}

    public List<HashMap<String,Object>>selectCoin(HashMap<String,Object> paramMap) throws Exception{
        return apiMapper.selectCoin(paramMap);
    }

    public void insertCoinMarketCapHistoryInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.insertCoinMarketCapHistoryInfo(paramMap);}

    public HashMap<String,Object> selectCoinMarketCapLinkCheck(HashMap<String,Object> paramMap) throws Exception{
        return apiMapper.selectCoinMarketCapLinkCheck(paramMap);
    }

    public void insertCoinMarketCapLinkInfo(HashMap<String,Object> paramMap) throws Exception{apiMapper.insertCoinMarketCapLinkInfo(paramMap);}
}
