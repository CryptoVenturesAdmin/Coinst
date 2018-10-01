package service;

import mapper.IcoMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service
public class IcoService {
    @Resource private IcoMapper icoMapper;

    public List<HashMap<String,Object>> selectIcoList(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoList(paramMap);
    }
    public List<HashMap<String,Object>> selectIcoUpcommingList(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoUpcommingList(paramMap);
    }
    public HashMap<String,Object> selectIcoCount(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoCount(paramMap);
    }
    public List<HashMap<String,Object>> selectIcoActiveList(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoActiveList(paramMap);
    }
    public List<HashMap<String,Object>> selectIcoEndedList(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoEndedList(paramMap);
    }
    public List<HashMap<String,Object>> selectIcoToCoinList(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoToCoinList(paramMap);
    }
    public HashMap<String,Object> selectIcoInfo(HashMap<String,Object> paramMap){
        return icoMapper.selectIcoInfo(paramMap);
    }

}
