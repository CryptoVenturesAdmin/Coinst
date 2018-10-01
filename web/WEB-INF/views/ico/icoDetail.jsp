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
<link rel="stylesheet" href="${CTX}/resources/css/lightbox.min.css">
<script src="${CTX}/resources/js/lightbox-plus-jquery.min.js"></script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="${CTX}/resources/css/slick.css">
<link rel="stylesheet" type="text/css" href="${CTX}/resources/css/slick-theme.css">
<script>
    $(function(){
        common_init();
    })
    function moveCompanyDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/company/companyDetail');
        comForm.submit();
    }
    function moveCoinDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/coin/coinDetail');
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
        <div class="container icoDetail">
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

                <div class="detailHeader">
                    <div class="detailInfo">
                        <div class="detailTop">
                            <div class="name_symbol">
                                <img class="logo" src="${CTX}/resources/image/coin/${icoInfo.ico_image}" onerror="imgError(this,'${CTX}');">
                                <div class="name">${icoInfo.ico_name}</div> <span class="h3 font_grey subName">${icoInfo.ico_symbol}</span>
                            </div>
                        </div>

                        <div class="detailBottom">
                            <div class="detailBottomBtn">
                                <%--<div class="rank"><strong class="h3">랭크 </strong></div>--%>
                                <div class="coinName">화폐</div>
                                <c:if test="${icoInfo.current_sale_type != null}">
                                    <div class="eventName">
                                        ${icoInfo.current_sale_type}
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <div class="price date">
                            <c:choose>
                                <c:when test="${icoInfo.current_sale_type != null}">
                                    <c:choose>
                                        <c:when test="${icoInfo.current_sale_type == '프라이빗 세일 예정' or icoInfo.current_sale_type == '프라이빗 세일 진행중'}">
                                            <c:choose>
                                                <c:when test="${fn:substring(icoInfo.private_sale_start,18 ,19) == 1}">
                                                    <p><span class="h3">${fn:substring(icoInfo.private_sale_start,5,7)}월 </span></p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p><span class="h3 font_green"><span class="dateFormat">${icoInfo.private_sale_start}</span><c:if test="${icoInfo.private_sale_start == null}">?</c:if> ~ <span class="dateFormat">${icoInfo.private_sale_end}</span><c:if test="${icoInfo.private_sale_end == null}">?</c:if></span></p>
                                                    <p><span class="font_grey">${icoInfo.left_day}</span></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${icoInfo.current_sale_type == '퍼블릭 세일 예정' or icoInfo.current_sale_type == '퍼블릭 세일 진행중'}">
                                            <c:choose>
                                                <c:when test="${fn:substring(icoInfo.public_sale_start,18 ,19) == 1}">
                                                    <p><span class="h3">${fn:substring(icoInfo.public_sale_start,5,7)}월 </span></p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p><span class="h3 font_green"><span class="dateFormat">${icoInfo.public_sale_start}</span><c:if test="${icoInfo.public_sale_start == null}">?</c:if> ~ <span class="dateFormat">${icoInfo.public_sale_end}</span><c:if test="${icoInfo.public_sale_end == null}">?</c:if></span></p>
                                                    <p><span class="font_grey">${icoInfo.left_day}</span></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${icoInfo.ico_state == 2}">
                                                <p><span class="h3">시작일자 미정</span></p>
                                        </c:when>
                                        <c:otherwise>
                                                <p><span class="h3">상장중</span></p>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="textInfo">
                            ${icoInfo.ico_explain}
                            <br>
                            ${icoInfo.special}
                        </div>
                    </div>
                    <div class="detailBookmark">
                        <button type="button" class="button_none" onclick="setBookmark('${icoInfo.ico_id}')">
                            <c:set var="existBookmark" value="false"></c:set>
                            <c:choose>
                                <c:when test="${!empty bookmarkList}">
                                    <c:forEach var="bookmarkList" items="${bookmarkList}">
                                        <c:if test="${bookmarkList.ico_id == icoInfo.ico_id}">
                                            <c:set var="existBookmark" value="true"></c:set>
                                        </c:if>
                                    </c:forEach>
                                    <c:choose>
                                        <c:when test="${existBookmark}">
                                            <img class="bookmark" src="${CTX}/resources/image/bookmark_on.png" alt="bookmark_on">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="bookmark" src="${CTX}/resources/image/bookmark.png" alt="bookmark">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img class="bookmark" src="${CTX}/resources/image/bookmark.png" alt="bookmark">
                                </c:otherwise>
                            </c:choose>
                        </button>

                    </div>
                    <div class="detailRight">
                        <ul>
                            <c:forEach var="linkList" items="${linkList}">
                                <li><a href="#" onclick="openTab('${linkList.link_url}')">${linkList.link_type}</a></li>
                            </c:forEach>
                            <c:if test="${icoInfo.ico_state == 1}">
                                <li><a href="#" onclick="moveCoinDetail('${icoInfo.ico_id}');">상장 정보보기</a></li>
                            </c:if>
                        </ul>
                    </div>
                    <div class="detail_period event">
                    </div>
                </div>
                <div class="margin-bottom" ></div>
                    <%--<div class="nav">
                        <ul>
                            <c:choose>
                                <c:when test="${!empty linkList}">
                                    <c:forEach var="linkList" items="${linkList}">
                                        <li><button type="button" class="button_none" onclick="openTab('${linkList.link_url}')">${linkList.link_type}</button></li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    등록된 링크가 없습니다.
                                </c:otherwise>
                            </c:choose>
                            &lt;%&ndash;<c:if test="${icoInfo.coin_web_site != null}"><li><a href="${icoInfo.coin_web_site}">웹사이트</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${icoInfo.coin_white_paper != null}"><li><a href="${icoInfo.coin_white_paper}">백서</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${icoInfo.coin_telegram != null}"><li><a href="${icoInfo.coin_telegram}">텔레그램</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${icoInfo.coin_twitter != null}"><li><a href="${icoInfo.coin_twitter}">트위터</a></li></c:if>&ndash;%&gt;
                        </ul>
                    </div>--%>
                <div class="Detailwarp">
                    <div class="detail_video_image">
                        <div class="title">동영상</div>
                        <c:choose>
                            <c:when test="${icoInfo.ico_video != null}">
                                <iframe width="560" height="315" src="${icoInfo.ico_video}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
                            </c:when>
                            <c:otherwise>
                                <%--<div>이미지</div>--%>
                                <img src="${CTX}/resources/image/no_video.jpg" alt="no_video">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail_ico_info">
                        <div class="title">코인 정보</div>
                        <div class="tableWarp">
                            <table class="ico_detail_table">
                                <colgroup>
                                    <col width="*">
                                    <col width="*">
                                    <col width="*">
                                </colgroup>
                                <div class="icotable tr1">
                                    <tr>
                                        <th>구분</th>
                                        <th>ICO 가격</th>
                                        <th>총 발행량</th>
                                    </tr>
                                    <tr>
                                        <td class="center">${icoInfo.ico_type}</td>
                                        <td class="center">
                                            <span class="prefixZeroDot">
                                                <c:choose>
                                                    <c:when test="${icoInfo.ico_price != 0}">
                                                        <c:choose>
                                                            <c:when test="${icoInfo.ico_price < 1}">
                                                                <fmt:formatNumber pattern="$#,##0" minFractionDigits="6">${icoInfo.ico_price}</fmt:formatNumber>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber pattern="$#,##0" minFractionDigits="2">${icoInfo.ico_price}</fmt:formatNumber>
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
                                                <c:when test="${icoInfo.max_supply != 0}">
                                                    <fmt:formatNumber pattern="#,##0">${icoInfo.max_supply}</fmt:formatNumber> ${icoInfo.ico_symbol}
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </div>
                                <div class="icotable tr2">
                                    <tr>
                                        <th>프라이빗 세일</th>
                                        <th>퍼블릭 세일</th>
                                        <th>하드캡</th>

                                    </tr>
                                    <tr>
                                        <td class="center">
                                            <c:choose>
                                                <c:when test="${icoInfo.private_sale_start == null and icoInfo.private_sale_end == null}">
                                                    ?
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${fn:substring(icoInfo.private_sale_start,18 ,19) == 1}">
                                                            ${fn:substring(icoInfo.private_sale_start,5,7)}월
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${icoInfo.private_sale_start == null}">?</c:if>${fn:substring(icoInfo.private_sale_start,0,10)} ~ <c:if test="${icoInfo.private_sale_end == null}">?</c:if>${fn:substring(icoInfo.private_sale_end,0,10)}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="center">
                                            <c:choose>
                                                <c:when test="${icoInfo.public_sale_start == null and icoInfo.public_sale_end == null}">
                                                    ?
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${fn:substring(icoInfo.public_sale_start,18 ,19) == 1}">
                                                            ${fn:substring(icoInfo.public_sale_start,5,7)}월
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${icoInfo.public_sale_start == null}">?</c:if>${fn:substring(icoInfo.public_sale_start,0,10)} ~ <c:if test="${icoInfo.public_sale_end == null}">?</c:if>${fn:substring(icoInfo.public_sale_end,0,10)}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="center">
                                            <c:choose>
                                                <c:when test="${icoInfo.hardcap != 0}">
                                                    <fmt:formatNumber pattern="$#,##0">${icoInfo.hardcap}</fmt:formatNumber>
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </div>
                                <div class="icotable tr3">
                                    <tr>
                                        <c:if test="${icoInfo.ico_kyc != null}"><th>KYC</th></c:if>
                                        <c:if test="${icoInfo.ico_white_list != null}"><th>Whitelist</th></c:if>
                                        <th></th>
                                    </tr>
                                    <tr>
                                        <c:if test="${icoInfo.ico_kyc != null}">
                                            <td class="center">
                                                ${icoInfo.ico_kyc}
                                            </td>
                                        </c:if>
                                        <c:if test="${icoInfo.ico_white_list != null}">
                                            <td class="center">
                                                    ${icoInfo.ico_white_list}
                                            </td>
                                        </c:if>
                                        <td class="center"></td>
                                    </tr>
                                </div>
                            </table>
                        </div>
                        <div class="align_right">업데이트 날짜 : ${fn:substring(icoInfo.update_date,0,10)}</div>
                    </div>
                </div>
                <div class="margin-bottom" ></div>
                <div class="detail_review">
                    <div class="title">ICO 평점</div>
                    <div class="detail_review_table_wrp">
                        <table class="detail_review_table">
                            <colgroup>
                                <col width="*">
                                <col width="*">
                                <col width="40%">
                            </colgroup>
                            <tr>
                                <th>이름</th>
                                <th>평점</th>
                                <th>상세정보</th>
                            </tr>
                            <c:choose>
                                <c:when test="${!empty reviewList}">
                                    <c:forEach var="reviewList" items="${reviewList}">
                                        <tr>
                                            <td class="center">${reviewList.reviewer_name}</td>
                                            <td class="center">${reviewList.review_point}</td>
                                            <td class="center linkText"><a href="${reviewList.detail_url}" class="button_none" target="_blank">${reviewList.detail_url}</a></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3">등록된 리뷰가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </table>
                    </div>
                </div>
                <div class="margin-bottom" ></div>
                <c:if test="${icoInfo.ico_roadmap != null}">
                    <div class="detail_roadmap">
                        <div class="title">ICO 로드맵</div>
                        <div class="sliderWarp roadmap_slider">
                            <section class="regular slider">
                                <c:set var="roadMap" value="${fn:split(icoInfo.ico_roadmap,'|')}"/>
                                <%--<c:set var="roadMapSize" value="${fn:length(roadMap)}"/>--%>
                                <c:forEach var="roadMapList" items="${roadMap}" varStatus="status">
                                    <a class="example-image-link" href="${CTX}/resources/image/roadmap/${roadMapList}" data-lightbox="example-set" data-title="Click the right half of the image to move forward.">
                                        <img class="example-image" src="${CTX}/resources/image/roadmap/${roadMapList}" alt="">
                                    </a>
                                </c:forEach>
                            </section>
                        </div>
                    </div>
                </c:if>
                <%--<div class="margin-bottom" ></div>
                <div class="detail_company">
                    <div class="title">투자사</div>
                    <div class="imgWarp">
                        <c:choose>
                            <c:when test="${!empty companyList}">
                                <c:forEach var="companyList" items="${companyList}">
                                    <div class="logowarp">
                                        <button type="button" class="button_none" onclick="moveCompanyDetail('${companyList.company_id}')">
                                            <img src="${CTX}/resources/image/company/${companyList.company_image}" onerror="imgError(this,'${CTX}');" alt="${companyList.company_name}">
                                        </button>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                등록된 회사가 없습니다.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>--%>
                <div class="push"></div>
            </div>
        </div>
    </div>
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
    <script src="${CTX}/resources/js/slick.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        $(document).on('ready', function() {
            $(".regular").slick({
                dots: false,
                infinite: true,
                slidesToShow: 5,
                slidesToScroll: 5,
                autoplay: true,
                autoplaySpeed: 2000
            });
        });
    </script>

</body>
</html>
