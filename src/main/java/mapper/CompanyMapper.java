package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface CompanyMapper {
    public List<HashMap<String,Object>> selectCompanyAjaxList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectCompanyList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectInvestCoinList(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectInvestInfo(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectInvestCoinDetailList(HashMap<String, Object> paramMap);
}
