package service;

import mapper.ReviewerMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service
public class ReviewerService {
    @Resource private ReviewerMapper reviewerMapper;

    public List<HashMap<String,Object>> selectReviewerAjaxList(HashMap<String,Object> paramMap){
        return reviewerMapper.selectReviewerAjaxList(paramMap);
    }
    public List<HashMap<String,Object>> selectReviewerList(HashMap<String,Object> paramMap){
        return reviewerMapper.selectReviewerList(paramMap);
    }
    public HashMap<String,Object> selectReviewerInfo(HashMap<String,Object> paramMap){
        return reviewerMapper.selectReviewerInfo(paramMap);
    }
    public List<HashMap<String,Object>> selectReviewCoinList(HashMap<String,Object> paramMap){
        return reviewerMapper.selectReviewCoinList(paramMap);
    }

}
