package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface IcoMapper {
    public List<HashMap<String,Object>> selectIcoList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectIcoUpcommingList(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectIcoCount(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectIcoActiveList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectIcoEndedList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectIcoToCoinList(HashMap<String,Object> paramMap);
    public HashMap<String,Object> selectIcoInfo(HashMap<String, Object> paramMap);
}
