package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface EventMapper {
    public HashMap<String,Object> selectEventCount(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectEventList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectEventSearchYearList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectEventSearchMonthList(HashMap<String, Object> paramMap);
}
