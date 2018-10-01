package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface ApiMapper {
    //CoinMarketCalApi
    public HashMap<String,Object> selectCoinMarketCalCheck(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectCoinMarketCalEventCheck(HashMap<String, Object> paramMap);
    public void updateCoinMarketCalEventInfo(HashMap<String, Object> paramMap);
    public void insertCoinMarketCalEventInfo(HashMap<String, Object> paramMap);

    //CoinMarketCapApiMain
    public void updateCoinMarketCapInfo(HashMap<String, Object> paramMap);
    public void insertCoinMarketCapInfo(HashMap<String, Object> paramMap);
    public void insertCoinMarketCapList(HashMap<String, Object> paramMap);

    //GetCoinMarketCapHistory
    public List<HashMap<String,Object>> selectCoin(HashMap<String, Object> paramMap);
    public void insertCoinMarketCapHistoryInfo(HashMap<String, Object> paramMap);

    //GetCoinMarketCapLink
    public HashMap<String,Object> selectCoinMarketCapLinkCheck(HashMap<String, Object> paramMap);
    public void insertCoinMarketCapLinkInfo(HashMap<String, Object> paramMap);
}
