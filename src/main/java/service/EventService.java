package service;

import mapper.EventMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service
public class EventService {
    @Resource private EventMapper eventMapper;

    public HashMap<String,Object> selectEventCount(HashMap<String,Object> paramMap){
        return eventMapper.selectEventCount(paramMap);
    }
    public List<HashMap<String,Object>> selectEventList(HashMap<String,Object> paramMap){
        return eventMapper.selectEventList(paramMap);
    }
    public List<HashMap<String,Object>> selectEventSearchYearList(HashMap<String,Object> paramMap){
        return eventMapper.selectEventSearchYearList(paramMap);
    }
    public List<HashMap<String,Object>> selectEventSearchMonthList(HashMap<String,Object> paramMap){
        return eventMapper.selectEventSearchMonthList(paramMap);
    }
}
