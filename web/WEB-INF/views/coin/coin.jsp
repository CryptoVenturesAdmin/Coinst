<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-09
  Time: 오후 7:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/header.jsp"%>
<html>
<%@include file="/WEB-INF/views/comHeader.jsp"%>
<script>
    $(function(){
        common_init();
        $('#ico_type').val("${paramMap.ico_type}").attr("selected","selected");
    })
    function moveDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id)
        comForm.setUrl('/coin/coinDetail');
        comForm.submit();
    }
    function selectCoinType(){
        var ico_type = $('#ico_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('ico_type',ico_type);
        comForm.addParam('exc_id','${excInfo.exc_id}');
        comForm.submit();
    }
    function movePage(currPage){
        var ico_type = $('#ico_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('currPage',currPage);
        comForm.addParam('ico_type',ico_type);
        comForm.addParam('exc_id','${excInfo.exc_id}');
        comForm.submit();
    }
</script>
<body>
    <!--업로드 시 주석 풀어줄 것!-->
    <%--<amp-auto-ads type="adsense"
                  data-ad-client="ca-pub-6206196082536417">
    </amp-auto-ads>--%>
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

                        <!--
                      <div class="sel sel--superman">
                        <select name="select-superpower" id="select-superpower">
                          <option value="" disabled>환율</option>
                                      <option value="USD">USD</option>
                                      <option value="KRW">KRW</option>
                        </select>
                        </div>

                        <!--
                        <span class="sel__placeholder sel__placeholder--black-panther">Placeholder Text</span>
                        <div class="sel__box sel__box--black-panther">
                          <span data-option="option_1" class="sel__box__options sel__box__options--black-panther">Option 1</span>
                          <span data-option="option_2" class="sel__box__options sel__box__options--black-panther">Option 2</span>
                          <span data-option="option_3" class="sel__box__options sel__box__options--black-panther">Option 3</span>
                          <span data-option="option_4" class="sel__box__options sel__box__options--black-panther">Option 4</span>
                          <span data-option="option_5" class="sel__box__options sel__box__options--black-panther">Option 5</span>
                        </div>
                      -->

                        <!--
                          .not-active.selected = hide
                          .active.selected = show
                        -->

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
            <div class="coin_table_wrp">
                <table class="coin_table coin">
                    <colgroup>
                        <col width="8%"/>
                        <col width="7%"/>
                        <col width="25%"/>
                        <col width="10%"/>
                        <col width="*%"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="10%"/>
                    </colgroup>
                    <tr>
                        <th>랭킹</th>
                        <th>랭킹변동<br><span>(1달)</span></th>
                        <th>이름</th>
                        <th>
                            <div class="scroll-parent">
                                <select class="sort_box coin_type" name="ico_type" id="ico_type" onchange="selectCoinType();">
                                    <option value="">구분</option>
                                    <c:forEach var="typeList" items="${typeList}">
                                        <option value="${typeList.ico_type}">${typeList.ico_type}</option>
                                    </c:forEach>
                                </select>
                            </div>

                        </th>
                        <th>시가총액</th>
                        <th>현재가격</th>
                        <th>가격변동<br><span>(24시간)</span></th>
                        <th>가격변동<br><span>(7일)</span></th>
                        <th>북마크</th>
                    </tr>
                    <%--<c:forEach var="number" begin="1" end="100">
                      <tr>
                        <td><span id="RANK_${number}"></span></td>
                        <td><span id="NAME_${number}"></span></td>
                        <td><span id="SYMBOL_${number}"></span></td>
                        <td><span id="PRICE_USD_${number}"></span></td>
                      </tr>
                    </c:forEach>--%>
                    <c:choose>
                        <c:when test="${!empty coinList}">
                            <c:forEach var="list" items="${coinList}">
                                <tr>
                                    <td class="center">${list.rank}</td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${list.before_1m_rank != 0}">
                                                <c:choose>
                                                    <c:when test="${list.before_1m_rank-list.rank > 0}">
                                                        <strong class="font_red">↑${list.before_1m_rank-list.rank}</strong>
                                                    </c:when>
                                                    <c:when test="${list.before_1m_rank-list.rank < 0}">
                                                        <strong class="font_blue">↓${list.rank-list.before_1m_rank}</strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <strong>0</strong>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <strong>0</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <%--<button type="button" class="button_none" onclick="moveDetail('${list.ico_id}');">
                                            <img src="${CTX}/resources/image/coin/${list.ico_image}" onerror="imgError(this,'${CTX}');"> <p>${list.coin_name}</p> <span>(${list.coin_symbol})</span>
                                        </button>--%>
                                        <a class="button_none" href="/coin/coinDetail?id=${list.ico_id}">
                                            <%--<img src="${CTX}/resources/image/coin/${list.ico_image}" onerror="imgError(this,'${CTX}');"> <p>${list.coin_name}</p> <span>(${list.coin_symbol})</span>--%>
                                            <img src="https://s2.coinmarketcap.com/static/img/coins/64x64/${list.coin_id}.png" onerror="imgError(this,'${CTX}');"> <p>${list.coin_name}</p> <span>(${list.coin_symbol})</span>
                                        </a>
                                    </td>
                                    <td class="center">
                                        <span>
                                            <c:choose>
                                                <c:when test="${list.ico_type != null}">
                                                    ${list.ico_type}
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${list.market_cap_usd != 0}">
                                                ${currency}<fmt:formatNumber pattern="#,##0">${list.market_cap_usd * excInfo.exc_rate}</fmt:formatNumber>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <span class="prefixZeroDot">
                                            <c:choose>
                                                <c:when test="${list.price_usd != 0}">
                                                    <c:choose>
                                                        <c:when test="${list.price_usd < 1}">
                                                            ${currency}<fmt:formatNumber pattern="#,##0" minFractionDigits="6">${list.price_usd * excInfo.exc_rate}</fmt:formatNumber>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${currency}<fmt:formatNumber pattern="#,##0" minFractionDigits="2">${list.price_usd * excInfo.exc_rate}</fmt:formatNumber>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${list.percent_change_24h_usd > 0}">
                                                <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${list.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                            </c:when>
                                            <c:when test="${list.percent_change_24h_usd < 0}">
                                                <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${list.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span><fmt:formatNumber pattern="#,##0.00">${list.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${list.percent_change_7d_usd > 0}">
                                                <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${list.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                            </c:when>
                                            <c:when test="${list.percent_change_7d_usd < 0}">
                                                <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${list.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span><fmt:formatNumber pattern="#,##0.00">${list.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">
                                        <span class="h3">
                                            <button type="button" class="button_none" onclick="setBookmark('${list.ico_id}');">
                                                <c:set var="existBookmark" value="false"></c:set>
                                                <c:choose>
                                                    <c:when test="${!empty bookmarkList}">
                                                        <c:forEach var="bookmarkList" items="${bookmarkList}">
                                                            <c:if test="${list.ico_id == bookmarkList.ico_id}">
                                                                <c:set var="existBookmark" value="true"></c:set>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="existBookmark" value="false"></c:set>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${existBookmark}">
                                                        <img class="bookmark" src="${CTX}/resources/image/bookmark_on.png" alt="bookmark_on">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img class="bookmark" src="${CTX}/resources/image/bookmark.png" alt="bookmark">
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9">검색된 결과가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </table>
            </div>
            <div class="pageWarp">
                <div class="pageNavigation">
                        ${pageInfo}
                </div>
            </div>
            <div class="push"></div>
        </div>
    </div>
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>
