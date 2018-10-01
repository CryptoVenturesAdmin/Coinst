<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-09
  Time: 오후 7:31
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/header.jsp"%>
<html>
<%@include file="/WEB-INF/views/comHeader.jsp"%>
<script>
    $(function(){
    })
    function moveCoinDetail(id,state){
        var url = "/coin/coinDetail";
        if(state == '1'){
            url = "/ico/icoDetail";
        }
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.addParam('state',state);
        comForm.setUrl(url);
        comForm.submit();
    }
    function moveCompanyDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/company/companyDetail');
        comForm.submit();
    }
</script>

<body>
    <div class="container">
        <div class="header">
            <div id="header">
                <nav>
                    <div class="container">
                        <div class="logo_warp"><a href="/"><div class="logo"></div></a></div>
                        <button type="button" class="btn_menu"><span>menu</span></button><!-- 수정 - 모바일 버튼 추가 -->
                        <div class="sub">
                            <div class="gnb">
                                <ul>
                                    <li class="<c:if test="${pageName == '/coin'}">on</c:if>"><a href="/">상장된 코인</a></li>
                                    <li class="<c:if test="${pageName == '/ico'}">on</c:if>"><a href="/ico">ICO</a></li>
                                    <li class="<c:if test="${pageName == '/event'}">on</c:if>"><a href="/event">코인별 이벤트</a></li>
                                    <%--<li class="<c:if test="${pageName == '/company'}">on</c:if>"><a href="/company">투자사</a></li>--%>
                                    <li class="<c:if test="${pageName == '/reviewer'}">on</c:if>"><a href="/reviewer">리뷰어</a></li>
                                    <li class="<c:if test="${pageName == '/market'}">on</c:if>"><a href="/market">시세</a></li>
                                </ul>
                            </div>
                            <div class="bookmark"><a href="/bookmark"><p>북마크한코인</p></a></div>
                        </div>

                        <div class="search_header">
                            <input type="text" class="search_name" name="search_name" id="search_name"  onkeyup="if(event.keyCode==13){searchCoin();}else{searchCoinAjax();}">
                            <button type="button" onclick="searchCoin()"><img src="${CTX}/resources/image/search-white.png"></button>
                            <div class="search_coin">
                                <nav class="search_coin_result" id="search_coin_result">
                                    <ul>
                                    </ul>
                                    <ul>
                                    </ul>
                                    <ul>
                                    </ul>
                                    <ul>
                                    </ul>
                                </nav>
                            </div>
                        </div>

                        <c:if test="${excList != null}">
                            <div class="ExcName">
                                <select class="toExcName" name="exc_name" id="exc_name" onchange="changeRate(paramMap);">
                                    <c:forEach var="excList" items="${excList}">
                                        <option value="${excList.exc_id}">${excList.exc_name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:if>

                        <c:if test="${excInfo != null}">
                            <div class="exchange_rate "><p>1 USD = ${excInfo.exc_rate} ${excInfo.exc_name}</p></div>
                        </c:if>
                    </div>
                </nav>

            </div>
        </div>
        <div class="headerPush"></div>
        <div class="content">
            <!---header.css에서수정가능---->
            <%--<div class="clip_top">
                <a href="#"><img src="${CTX}/resources/image/ad/top_banner.jpg" alt="광고"/></a>
            </div>--%>



            <!---header.css에서수정가능---->
            <div class="clip_warp">
                <div class="clip_bg" id="divMenu">
                    <div class="clip_right">
                        <%--<a href="#"><img src="${CTX}/resources/image/ad/left_banner.jpg" alt="광고"></a>--%>
                    </div>
                </div>
            </div>
            <div class="companyWarp">
                <div class="titlewarp">
                    <div class="listtitle">투자사리스트</div> <div class="companynum">${fn:length(companyList)}</div>
                </div>
                <table class="coin_table">
                    <colgroup>
                        <col width="60%"/>
                        <%--<col width="*"/>--%>
                        <col width="*"/>
                    </colgroup>
                    <tr>
                        <th>이름</th>
                        <%--<th>투자한 코인</th>--%>
                        <th>웹사이트</th>
                    </tr>
                    <c:choose>
                        <c:when test="${!empty companyList}">
                            <c:forEach var="companyList" items="${companyList}">
                                <c:if test="${!empty companyList.investCoinList}">
                                    <tr>
                                        <td class="left">
                                            <button type="button" class="button_none" onclick="moveCompanyDetail('${companyList.company_id}');">
                                                <img src="${CTX}/resources/image/company/${companyList.company_image}"> <p>${companyList.company_name}</p>
                                            </button>
                                        </td>
                                        <%--<td class="center">
                                            <c:choose>
                                                <c:when test="${!empty companyList.investCoinList}">
                                                    <c:forEach var="investCoinList" items="${companyList.investCoinList}" varStatus="status">
                                                        <button type="button" class="button_none" onclick="moveCoinDetail('${investCoinList.ico_id}','${investCoinList.ico_state}')">
                                                                ${investCoinList.ico_name}
                                                        </button>
                                                        <c:if test="${!status.last}">,  </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    투자한 코인이 없습니다.
                                                </c:otherwise>
                                            </c:choose>
                                        </td>--%>
                                        <td class="center linkText"><a href="${companyList.company_web_site}" class="button_none" target="_blank">${companyList.company_web_site}</a></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3">검색된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>

                </table>
            </div>
            <div class="push"></div>
        </div>
    </div>
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>
