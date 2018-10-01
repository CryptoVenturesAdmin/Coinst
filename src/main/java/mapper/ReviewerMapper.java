package mapper;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface ReviewerMapper {
    public List<HashMap<String,Object>> selectReviewerAjaxList(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectReviewerList(HashMap<String, Object> paramMap);
    public HashMap<String,Object> selectReviewerInfo(HashMap<String, Object> paramMap);
    public List<HashMap<String,Object>> selectReviewCoinList(HashMap<String, Object> paramMap);
}
