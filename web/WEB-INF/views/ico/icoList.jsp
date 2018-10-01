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
        common_init();
        $('#ico_type').val("${paramMap.ico_type}").attr("selected","selected");
        $('.active icotitle').css({"color": "#5D5D5D","background":"#FAFAFA"});
    })
    function moveDetail(id, state) {
        var url = '/ico/icoDetail';
        /*if(state == 1){
            url = '/coin/coinDetail';
        }*/
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id', id);
        comForm.setUrl(url);
        comForm.submit();
    }
    function selectType(type){
        var comForm = new CommonForm('commonForm');
        comForm.addParam("type",type);
        comForm.setUrl("/ico");
        comForm.submit();
    }
    function selectCoinType(){
        var ico_type = $('#ico_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('ico_type',ico_type);
        comForm.addParam('type','${paramMap.type}')
        comForm.submit();
    }
    function movePage(currPage){
        var ico_type = $('#ico_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('currPage',currPage);
        comForm.addParam('ico_type',ico_type);
        comForm.submit();
    }
</script>

<script>
    $(function () {

        $(".tab_content").hide();
        $(".tab_content:first").show();

        /*$("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("active").css({"color": "#0068FF","background": "#fff"});
            $(this).addClass("active").css({"color": "#5D5D5D","background":"#FAFAFA"});
            $(".tab_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });*/
    });
</script>

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
            <div class="tabwarp icotab">

                <div class="tab_container">
                    <ul class="tabs">
                        <li class="<c:if test="${paramMap.type == 0}">active</c:if> icotitle" rel="tab1" onclick="selectType(0)"> 예정된 ICO</li>
                        <li class="<c:if test="${paramMap.type == 1}">active</c:if> icotitle" rel="tab1" onclick="selectType(1)" >진행중 ICO </li>
                        <li class="<c:if test="${paramMap.type == 2}">active</c:if> icotitle" rel="tab1" onclick="selectType(2)" >완료된 ICO </li>
                        <li class="<c:if test="${paramMap.type == 3}">active</c:if> icotitle" rel="tab1" onclick="selectType(3)" >상장된 ICO </li>
                    </ul>
                </div>

                <div class="icotabLine"></div>

                <div class="tab_content" id="tab1">
                    <div class="icoList">
                        <table class="coin_table">
                            <colgroup>
                                <col width="25%"/>
                                <col width="10%"/>
                                <col width="*"/>
                                <col width="*"/>
                                <c:if test="${paramMap.type == 1}"><col width="*"/></c:if>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="*"/>
                                <col width="10%"/>
                            </colgroup>
                            <tr>
                                <th>이름</th>
                                <th>
                                    <select class="sort_box coin_type" name="ico_type" id="ico_type" onchange="selectCoinType();">
                                        <option value="">구분</option>
                                        <c:forEach var="typeList" items="${typeList}">
                                            <option value="${typeList.ico_type}">${typeList.ico_type}</option>
                                        </c:forEach>
                                    </select>
                                </th>
                                <th><c:choose><c:when test="${paramMap.type == 3}">ICO 가격</c:when><c:otherwise>토큰별 가격</c:otherwise></c:choose></th>
                                <th><c:choose><c:when test="${paramMap.type == 3}">현재가격</c:when><c:otherwise>하드캡</c:otherwise></c:choose></th>
                                <c:if test="${paramMap.type == 1}"><th>진행중</th></c:if>
                                <th>
                                    <c:choose>
                                        <c:when test="${paramMap.type == 0}">시작 날짜</c:when>
                                        <c:when test="${paramMap.type == 1}">기간</c:when>
                                        <c:when test="${paramMap.type == 2}">종료 날짜</c:when>
                                        <c:when test="${paramMap.type == 3}">투자수익률</c:when>
                                    </c:choose>
                                </th>
                                <th>평점</th>
                                <th>평점자 수</th>
                                <th>북마크</th>
                            </tr>
                            <c:choose>
                                <c:when test="${!empty icoList}">
                                    <c:forEach var="icoList" items="${icoList}">
                                        <tr>
                                            <td class="center">
                                                <%--<button type="button" class="button_none" onclick="moveDetail('${icoList.ico_id}','${icoList.ico_state}');">
                                                    <img src="${CTX}/resources/image/coin/${icoList.ico_image}" onerror="imgError(this,'${CTX}');"><p>${icoList.ico_name}</p> <span>(${icoList.ico_symbol})</span>
                                                </button>--%>
                                                <a class="button_none" href="/ico/icoDetail?id=${icoList.ico_id}">
                                                    <img src="${CTX}/resources/image/coin/${icoList.ico_image}" onerror="imgError(this,'${CTX}');"><p>${icoList.ico_name}</p> <span>(${icoList.ico_symbol})</span>
                                                </a>
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
                                            <td class="center">
                                                <span class="prefixZeroDot">
                                                    <c:choose>
                                                        <c:when test="${icoList.ico_price != 0}">
                                                            <c:choose>
                                                                <c:when test="${icoList.ico_price < 1}">
                                                                    <fmt:formatNumber pattern="$#,##0" minFractionDigits="6">${icoList.ico_price}</fmt:formatNumber>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <fmt:formatNumber pattern="$#,##0" minFractionDigits="2">${icoList.ico_price}</fmt:formatNumber>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <br>
                                            </td>
                                            <td class="center">
                                                <c:choose>
                                                    <c:when test="${paramMap.type == 3}">
                                                        <span class="prefixZeroDot">
                                                            <c:choose>
                                                                <c:when test="${icoList.price_usd != 0}">
                                                                    <c:choose>
                                                                        <c:when test="${icoList.price_usd < 1}">
                                                                            <fmt:formatNumber pattern="$#,##0" minFractionDigits="6">${icoList.price_usd}</fmt:formatNumber>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <fmt:formatNumber pattern="$#,##0" minFractionDigits="2">${icoList.price_usd}</fmt:formatNumber>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    -
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${icoList.hardcap != 0}">
                                                                <fmt:formatNumber pattern="$#,##0">${icoList.hardcap}</fmt:formatNumber>
                                                            </c:when>
                                                            <c:otherwise>
                                                                -
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${paramMap.type == 1}"><td class="center">${icoList.current_sale_type}</td></c:if>
                                            <td class="center">
                                                <c:choose>
                                                    <c:when test="${paramMap.type == 0}">
                                                        <strong class="dateFormat">${icoList.public_sale_start}</strong><c:if test="${icoList.public_sale_start == null}">?</c:if><br><span class="font_grey">${icoList.left_day}</span>
                                                    </c:when>
                                                    <c:when test="${paramMap.type == 1}">
                                                        <c:choose>
                                                            <c:when test="${icoList.current_sale_type == '프라이빗 세일'}">
                                                                <strong class="dateFormat">${icoList.private_sale_start}</strong><c:if test="${icoList.private_sale_start == null}">?</c:if> ~ <strong class="dateFormat">${icoList.private_sale_end}</strong><c:if test="${icoList.private_sale_end == null}">?</c:if><br><span class="font_grey">${icoList.left_day}</span>
                                                            </c:when>
                                                            <c:when test="${icoList.current_sale_type == '퍼블릭 세일'}">
                                                                <strong class="dateFormat">${icoList.public_sale_start}</strong><c:if test="${icoList.public_sale_start == null}">?</c:if> ~ <strong class="dateFormat">${icoList.public_sale_end}</strong><c:if test="${icoList.public_sale_end == null}">?</c:if><br><span class="font_grey">${icoList.left_day}</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:when test="${paramMap.type == 2}">
                                                        <strong class="dateFormat">${icoList.public_sale_end}</strong><c:if test="${icoList.public_sale_end == null}">?</c:if>
                                                    </c:when>
                                                    <c:when test="${paramMap.type == 3}">
                                                        <c:choose>
                                                            <c:when test="${icoList.roi >= 0}">
                                                                <span class="font_green"><fmt:formatNumber pattern="#,##0.00%">${icoList.roi}</fmt:formatNumber></span>
                                                            </c:when>
                                                            <c:when test="${icoList.roi < 0}">
                                                                <span class="font_red"><fmt:formatNumber pattern="#,##0.00%">${icoList.roi}</fmt:formatNumber></span>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="center"><fmt:formatNumber pattern="0.0">${icoList.rating}</fmt:formatNumber></td>
                                            <td class="center">${icoList.review_count}</td>
                                            <td class="center">
                                                <span class="h3">
                                                    <button type="button" class="button_none" onclick="setBookmark('${icoList.ico_id}');">
                                                        <c:set var="existBookmark" value="false"></c:set>
                                                        <c:choose>
                                                            <c:when test="${!empty bookmarkList}">
                                                                <c:forEach var="bookmarkList" items="${bookmarkList}">
                                                                    <c:if test="${icoList.ico_id == bookmarkList.ico_id}">
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
                                        <td colspan="<c:choose><c:when test="${paramMap.type == 1}">9</c:when><c:otherwise>8</c:otherwise></c:choose>">검색된 데이터가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        <%--<c:forEach var="num" begin="1" end="100">
                            <tr>
                                <td class="center"><button type="button" class="button_none" onclick="moveDetail('Sentinal Protocol','UPP');">Sentinal Protocol</button></td>
                                <td class="center">UPP</td>
                                <td class="center">화폐</td>
                                <td class="center">0.0002</td>
                                <td class="center">500000</td>
                                <td class="center">05.27.2018 ~ 06.01.2018 / 06.18.2019 ~ 06.30.2020</td>
                                <td class="center">5.0</td>
                            </tr>
                        </c:forEach>--%>
                        </table>
                    </div>
                </div>
                <div class="pageWarp">
                    <div class="pageNavigation">
                        ${pageInfo}
                    </div>
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
