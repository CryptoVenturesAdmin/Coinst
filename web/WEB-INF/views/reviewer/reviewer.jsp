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
    function moveReviewerDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/reviewer/reviewerDetail');
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
                        <button type="button" class="btn_menu"><span>menu</span></button>
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
                <a href="#"><img src="/resources/image/ad/top_banner.jpg" alt="광고"/></a>
            </div>--%>

            <!---header.css에서수정가능---->
            <div class="clip_warp">
                <div class="clip_bg" id="divMenu">
                    <div class="clip_right">
                        <%--<a href="#"><img src="/resources/image/ad/left_banner.jpg" alt="광고"></a>--%>
                    </div>
                </div>
            </div>
            <div class="titlewarp">
                <div class="listtitle">리뷰어리스트</div>  <div class="companynum">${fn:length(reviewerList)}</div>
            </div>
            <div class="reviewer_table_wrp">
                <table class="coin_table reviewer_table">
                    <colgroup>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="40%"/>
                    </colgroup>
                    <tr>
                        <th>이름</th>
                        <th>리뷰 갯수</th>
                        <th>타율</th>
                        <th>추정 수익률</th>
                        <th>상세정보</th>
                    </tr>
                    <c:choose>
                        <c:when test="${!empty reviewerList}">
                            <c:forEach var="reviewerList" items="${reviewerList}">
                                <tr>
                                    <td class="left">
                                        <%--<button type="button" class="button_none" onclick="moveReviewerDetail('${reviewerList.reviewer_id}');"><p>${reviewerList.reviewer_name}</p></button>--%>
                                        <a class="button_none" href="/reviewer/reviewerDetail?id=${reviewerList.reviewer_id}"><p>${reviewerList.reviewer_name}</p></a>
                                    </td>
                                    <td class="center">${reviewerList.review_count}</td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${reviewerList.review_coin_count != 0}">
                                                <fmt:formatNumber pattern="#,##0.0%">${reviewerList.review_up_count / reviewerList.review_coin_count}</fmt:formatNumber>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber pattern="#,##0.0%">0</fmt:formatNumber>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${reviewerList.roi != null}">
                                                    <span class="<c:choose><c:when test="${reviewerList.roi > 0}">font_green</c:when><c:when test="${reviewerList.roi < 0}">font_red</c:when></c:choose>">
                                                        <fmt:formatNumber minFractionDigits="2">${reviewerList.roi}</fmt:formatNumber>%
                                                    </span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose></td>
                                    <td class="center linkText"><a href="${reviewerList.reviewer_link}" class="button_none" target="_blank">${reviewerList.reviewer_link}</a></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="2">검색된 데이터가 없습니다.</td>
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
