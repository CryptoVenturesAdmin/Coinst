package common.util;

import java.util.HashMap;

public class PageUtil {
    //페이지 유틸
    private int maxPage = 10;

    public String pageNavigation(int rowSize, int totalRow, HashMap<String,Object> paramMap){
        String rtnScript = "";

        if(paramMap.get("currPage") == null){
            paramMap.put("currPage",1);
        }

        int currPage = Integer.parseInt(paramMap.get("currPage").toString());
        int firstRow = (currPage * rowSize) - rowSize + 1;
        paramMap.put("firstRow",firstRow - 1);
        paramMap.put("rowSize",rowSize);
        int pageStart = (int)(Math.floor(currPage / (maxPage + 1)) * maxPage + 1);
        int perMaxPage = (int)(Math.floor(pageStart / (maxPage + 1)) + 1) * maxPage;
        int morePage = 0;
        if(totalRow % rowSize != 0){ morePage = 1; }
        int totalPage = (int)(Math.floor(totalRow / rowSize + morePage));
        int pageEnd = (perMaxPage > totalPage)? totalPage : perMaxPage;

        if(currPage > maxPage){
            rtnScript += "<div class='pagePre'>" +
                    "<button type='button' class='button_none' onclick='movePage(1)'>&lt;&lt;</button>"+
                    "<button type='button' class='button_none' onclick='movePage("+(pageStart-maxPage)+")'>이전</button>" +
                    "</div>";
        }
        rtnScript += "<div class='pageNum'>";
        for(int i = pageStart; i <= pageEnd; i++){
            if(currPage == i){
                rtnScript += "<button type='button' class='button_none on' onclick='movePage(" + i + ")'>" + i + "</button>";
            }else {
                rtnScript += "<button type='button' class='button_none' onclick='movePage(" + i + ")'>" + i + "</button>";
            }
        }
        rtnScript += "</div>";
        if(pageStart <= Math.floor(totalRow / rowSize) - maxPage){
            rtnScript += "<div class='pageNext'>" +
                    "<button type='button' class='button_none' onclick='movePage("+(pageStart+maxPage)+")'>다음</button>" +
                    "<button type='button' class='button_none' onclick='movePage("+totalPage+")'>&gt;&gt;</button>"+
                    "</div>";
        }
        return rtnScript;
    }
}
