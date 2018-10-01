<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-09
  Time: 오후 7:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/header.jsp"%>
<script>
    $(function(){
        $('#ico_type').val("${paramMap.ico_type}").attr("selected","selected");
        $('.active icotitle').css({"color": "#5D5D5D","background":"#f0f0f0"});
    })
    function moveDetail(id,state){
        var url = '/coin/coinDetail';
        if(state = 2){
            url = '/ico/icoDetail';
        }
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl(url);
        comForm.submit();
    }
    function selectCoinType(){
        var ico_type = $('#ico_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('ico_type',ico_type);
        comForm.addParam('type','${paramMap.type}');
        comForm.setUrl('/bookmark');
        comForm.submit();
    }
    function movePage(currPage){
        var coin_type = $('#coin_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('currPage',currPage);
        comForm.addParam('coin_type',coin_type);
        comForm.submit();
    }

    function selectType(type){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('type',type);
        comForm.setUrl('/bookmark');
        comForm.submit();
    }
</script>
<body>
    <div class="container">
        <div class="header">
            <%@include file="/WEB-INF/views/comHeader.jsp"%>
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
                </nav>

            </div>
        </div>
        <div class="headerPush"></div>
        <div class="content">
            <!---header.css에서수정가능---->
            <div class="clip_top">
                <%--<a href="#"><img src="/resources/image/ad/top_banner.jpg" alt="광고"/></a>--%>
            </div>



            <!---header.css에서수정가능---->
            <div class="clip_warp">
                <div class="clip_bg" id="divMenu">
                    <div class="clip_right">
                        <%--<a href="#"><img src="/resources/image/ad/left_banner.jpg" alt="광고"></a>--%>
                    </div>
                </div>
            </div>
            <div class="tabwarp icotab">
                <div class="tab_container">
                    <ul class="tabs">
                        <li class="<c:if test="${paramMap.type == 0}">active</c:if> icotitle" onclick="selectType(0);">상장된 코인</li>
                        <li class="<c:if test="${paramMap.type == 1}">active</c:if> icotitle" onclick="selectType(1);">ICO 코인</li>
                    </ul>
                </div>
            </div>
            <div class="tab_content" id="tab1">


                    <%--<c:forEach var="number" begin="1" end="100">
                      <tr>
                        <td><span id="RANK_${number}"></span></td>
                        <td><span id="NAME_${number}"></span></td>
                        <td><span id="SYMBOL_${number}"></span></td>
                        <td><span id="PRICE_USD_${number}"></span></td>
                      </tr>
                    </c:forEach>--%>
                <c:choose>
                    <c:when test="${paramMap.type == 0}">
                        <div class="coin_table_wrp">
                            <table class="coin_table">
                                <colgroup>
                                    <col width="8%"/>
                                    <col width="7%"/>
                                    <col width="25%"/>
                                    <col width="10%"/>
                                    <col width="*"/>
                                    <col width="*"/>
                                    <col width="*"/>
                                    <col width="*"/>
                                    <col width="10%"/>
                                </colgroup>
                                <tr>
                                    <th>랭킹</th>
                                    <th>랭킹변동<br>(1달)</th>
                                    <th class="left">이름</th>
                                    <th>
                                        <select class="sort_box coin_type" name="ico_type" id="ico_type" onchange="selectCoinType();">
                                            <option value="">구분</option>
                                            <c:forEach var="typeList" items="${typeList}">
                                                <option value="${typeList.ico_type}">${typeList.ico_type}</option>
                                            </c:forEach>
                                        </select>
                                    </th>
                                    <th>시가총액</th>
                                    <th>현재가격</th>
                                    <th>가격변동<br>(24시간)</th>
                                    <th>가격변동<br>(7일)</th>
                                    <th>북마크</th>
                                </tr>
                                <c:set var="book_existBookmark" value="false"></c:set>
                                <c:set var="booked_count" value="false"></c:set>
                                <c:choose>
                                    <c:when test="${!empty list}">
                                        <c:forEach var="book_coinList" items="${list}">
                                            <c:forEach var="book_bookmakrList" items="${bookmarkList}">
                                                <c:if test="${book_coinList.ico_id == book_bookmakrList.ico_id}">
                                                    <c:set var="book_existBookmark" value="true"></c:set>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${book_existBookmark}">
                                                <c:set var="booked_count" value="true"></c:set>
                                                <tr>
                                                    <td class="center">${book_coinList.rank}</td>
                                                    <td class="center">
                                                        <c:choose>
                                                            <c:when test="${book_coinList.before_1m_rank != 0}">
                                                                <c:choose>
                                                                    <c:when test="${book_coinList.before_1m_rank-book_coinList.rank > 0}">
                                                                        <strong class="font_red">↑${book_coinList.before_1m_rank-book_coinList.rank}</strong>
                                                                    </c:when>
                                                                    <c:when test="${book_coinList.before_1m_rank-book_coinList.rank < 0}">
                                                                        <strong class="font_blue">↓${book_coinList.rank-book_coinList.before_1m_rank}</strong>
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
                                                    <td class="left">
                                                        <button type="button" class="button_none" onclick="moveDetail('${book_coinList.ico_id}','${paramMap.ico_state}');">
                                                            <img src="https://s2.coinmarketcap.com/static/img/coins/64x64/${book_coinList.coin_id}.png" onerror="imgError(this,'${CTX}');" alt="${book_coinList.coin_name}"> <p>${book_coinList.coin_name}</p> <span>(${book_coinList.coin_symbol})</span>
                                                        </button>
                                                    </td>
                                                    <td class="center">
                                                        <c:choose>
                                                            <c:when test="${book_coinList.ico_type != null}">
                                                                ${book_coinList.ico_type}
                                                            </c:when>
                                                            <c:otherwise>
                                                                -
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="center">${currency}<fmt:formatNumber pattern="#,##0">${book_coinList.market_cap_usd * excInfo.exc_rate}</fmt:formatNumber></td>
                                                    <td class="center">${currency}<fmt:formatNumber pattern="#,##0.0">${book_coinList.price_usd * excInfo.exc_rate}</fmt:formatNumber></td>
                                                    <td class="center">
                                                        <c:choose>
                                                            <c:when test="${book_coinList.percent_change_24h_usd > 0}">
                                                                <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                                            </c:when>
                                                            <c:when test="${book_coinList.percent_change_24h_usd < 0}">
                                                                <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="center">
                                                        <c:choose>
                                                            <c:when test="${book_coinList.percent_change_7d_usd > 0}">
                                                                <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                                            </c:when>
                                                            <c:when test="${book_coinList.percent_change_7d_usd < 0}">
                                                                <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span><fmt:formatNumber pattern="#,##0.00">${book_coinList.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="center">
                                                        <span class="h3">
                                                            <button type="button" class="button_none" onclick="setBookmark('${book_coinList.ico_id}');">
                                                                <img src="${CTX}/resources/image/bookmark_on.png" class="bookmark" alt="bookmark_on">
                                                            </button>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:set var="book_existBookmark" value="false"></c:set>
                                        </c:forEach>

                                        <c:if test="${!booked_count}">
                                            <tr>
                                                <td colspan="9">북마크한 코인이 없습니다.</td>
                                            </tr>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9">북마크한 코인이 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="tabwarp icotab">
                            <div class="icoList">
                                <table class="coin_table">
                                    <colgroup>
                                        <col width="25%"/>
                                        <col width="10%"/>
                                        <col width="*"/>
                                        <col width="*"/>
                                        <col width="10%"/>
                                    </colgroup>
                                    <tr>
                                        <th class="left">이름</th>
                                        <th>
                                            <select class="sort_box coin_type"  name="ico_type" id="ico_type" onchange="selectCoinType();">
                                                <option value="">구분</option>
                                                <c:forEach var="typeList" items="${typeList}">
                                                    <option value="${typeList.ico_type}">${typeList.ico_type}</option>
                                                </c:forEach>
                                            </select>
                                        </th>
                                        <th>상장 여부</th>
                                        <th>평점</th>
                                        <th>북마크</th>
                                    </tr>
                                    <c:set var="book_existBookmark" value="false"></c:set>
                                    <c:set var="booked_count" value="false"></c:set>
                                    <c:choose>
                                        <c:when test="${!empty list}">
                                            <c:forEach var="icoList" items="${list}">
                                                <c:forEach var="book_bookmakrList" items="${bookmarkList}">
                                                    <c:if test="${icoList.ico_id == book_bookmakrList.ico_id}">
                                                        <c:set var="book_existBookmark" value="true"></c:set>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${book_existBookmark}">
                                                <c:set var="booked_count" value="true"></c:set>
                                                    <tr>
                                                        <td class="left">
                                                            <button type="button" class="button_none" onclick="moveDetail('${icoList.ico_id}','${paramMap.ico_state}');">
                                                                <img src="${CTX}/resources/image/coin/${icoList.ico_image}" onerror="imgError(this,'${CTX}');" alt="${icoList.ico_name}"><p>${icoList.ico_name}</p> <span>(${icoList.ico_symbol})</span>
                                                            </button>
                                                        </td>
                                                        <td class="center">
                                                            <c:choose>
                                                                <c:when test="${icoList.ico_type != null}">
                                                                    ${icoList.ico_type}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    -
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="center">${icoList.current_sale_type}</td>
                                                        <td class="center"><fmt:formatNumber pattern="0.0">${icoList.rating}</fmt:formatNumber></td>
                                                        <td class="center">
                                                            <span class="h3">
                                                                <button type="button" class="button_none" onclick="setBookmark('${icoList.ico_id}')">
                                                                    <img src="${CTX}/resources/image/bookmark_on.png" class="bookmark" alt="bookmark_on">
                                                                </button>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                                <c:set var="book_existBookmark" value="false"></c:set>
                                            </c:forEach>

                                            <c:if test="${!booked_count}">
                                                <tr>
                                                    <td colspan="5">북마크한 코인이 없습니다.</td>
                                                </tr>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5">북마크한 코인이 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </table>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="push"></div>
        </div>
    </div>
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>
