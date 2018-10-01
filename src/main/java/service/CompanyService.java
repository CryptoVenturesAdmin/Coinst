package service;

import mapper.CompanyMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service
public class CompanyService {
    @Resource private CompanyMapper companyMapper;

    public List<HashMap<String,Object>> selectCompanyAjaxList(HashMap<String,Object> paramMap){
        return companyMapper.selectCompanyAjaxList(paramMap);
    }
    public List<HashMap<String,Object>> selectCompanyList(HashMap<String,Object> paramMap){
        return companyMapper.selectCompanyList(paramMap);
    }
    public List<HashMap<String,Object>> selectInvestCoinList(HashMap<String,Object> paramMap){
        return companyMapper.selectInvestCoinList(paramMap);
    }
    public HashMap<String,Object> selectInvestInfo(HashMap<String,Object> paramMap){
        return companyMapper.selectInvestInfo(paramMap);
    }
    public List<HashMap<String,Object>> selectInvestCoinDetailList(HashMap<String,Object> paramMap){
        return companyMapper.selectInvestCoinDetailList(paramMap);
    }

}
