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




    <div class="error">
        <div class="errorContent">
            <p><c:choose><c:when test="${errorNum == 0}">Exception</c:when><c:otherwise>${errorNum}</c:otherwise></c:choose></p>
            <span>${msg}</span>
        </div>
    </div>




    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>