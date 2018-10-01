<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-08-09
  Time: 오후 2:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/header.jsp"%>
<html>
<%@include file="/WEB-INF/views/comHeader.jsp"%>
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

            <div class="notice">
                <h3>면책사항</h3>
                <p>coinst 에서 제공하는 모든 정보는 투자, 또는 금융에 대한 조언이 아니며, 이 이외에 그 어떤 것에 관한 조언도 아닙니다. 위의 정보는 모두 시장정보에 따라 수시로 에고없이 바뀔 수 있으며,  코인스트리트는 잘못되거나 기재되지 않은 정보에 대한 그 어떠한 책임도 지지 않습니다. 모든 정보는 그 당시의 정보를 기준으로 하며, 위의 정보를 토대로 투자하는것에 대한 책임은 모두 본인에게 있습니다. 코인에 투자하기전에는 꼭 전문가와 함께 하시기를 추천합니다.</p>

                <p>이벤트<br>모든 이벤트는 회사의 공식 트위터나 미디움, 로드맵에 작성된 정보를 토대로 만들어졌습니다.</p>
                <%--<p>투자사<br>모든 투자사 포트폴리오는 투자사들의 공식 웹사이트에서 가져온 정보입니다.</p>--%>
                <p>리뷰어<br>리뷰어들의 타율은, 리뷰어들이 A평점 이상. 즉 90점이상 점수를 준 코인에 한해서 계산됩니다.</p>
            </div>
        </div>
        <div class="push"></div>
    </div>

    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>