package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface CoinMapper {
    public List<HashMap<String,Object>> selectCoinAjaxList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinList(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectCoinCount(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinTypeList(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectCoinInfo(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinlinkList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinGraphDataList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinEventList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinReviewList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinCompanyList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCoinSymbolForMarketData();
    public List<HashMap<String,Object>> selectExchangeList(HashMap<String,Object> paramMap);
    public HashMap<String,Object> selectExchangeInfo(HashMap<String,Object> paramMap);
}
