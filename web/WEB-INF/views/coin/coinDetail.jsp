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
<script type="text/javascript" src="${CTX}/resources/js/dygraph-2.1.0.js"></script>
<link rel="stylesheet" src="${CTX}/resources/css/dygraph.css" />

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href='http://fonts.googleapis.com/css?family=Covered+By+Your+Grace' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="${CTX}/resources/css/amcharts.css"	type="text/css">
<script src="${CTX}/resources/amcharts/amcharts.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/serial.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/amstock.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/themes/light.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/themes/dark.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/themes/black.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/themes/chalk.js" type="text/javascript"></script>
<script src="${CTX}/resources/amcharts/themes/patterns.js" type="text/javascript"></script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="${CTX}/resources/css/slick.css">
<link rel="stylesheet" type="text/css" href="${CTX}/resources/css/slick-theme.css">
<script>
    $(function(){
        common_init();
        $(".tab_content").hide();
        $(".tab_content:first").show();

        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("active").css({"color": "#01167b","background": "#F1F1F2"});
            $(this).addClass("active").css({"color": "#fff","background": "#01167b"});
            //$(this).addClass("active").css("color", "darkred");
            $(".tab_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });
    })
    function moveCompanyDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/company/companyDetail')
        comForm.submit();
    }
    function moveicoDetail(id){
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl('/ico/icoDetail');
        comForm.submit();
    }
</script>
<script>
    var chartData1 = [];
    var chartData2 = [];
    var chartData3 = [];
    var chartData4 = [];

    generateChartData();

    function generateChartData() {
        var firstDate = new Date();
        firstDate.setDate(firstDate.getDate() - 500);
        firstDate.setHours(0, 0, 0, 0);
        <c:forEach var="dataList" items="${graphDataList}">
        chartData1.push({
            date : toDateString('${dataList.input_date}'),
            value : ${dataList.price_usd},
            volume : ${dataList.volume_24h_usd}
        });
        chartData2.push({
            date : toDateString('${dataList.input_date}'),
            value : ${dataList.market_cap_usd},
            volume : ${dataList.volume_24h_usd}
        });
        /*chartData3.push({
            date : toDateString('${dataList.input_date}'),
            value : ${dataList.volume_24h_usd},
            volume : ${dataList.volume_24h_usd}
        });*/
        </c:forEach>
    }

    // in order to set theme for a chart, all you need to include theme file
    // located in amcharts/themes folder and set theme property for the chart.

    var chart;

    makeChart("light", "#FFFFFF");

    // Theme can only be applied when creating chart instance - this means
    // that if you need to change theme at run time, youhave to create whole
    // chart object once again.

    function makeChart(theme, bgColor, bgImage) {

        if (chart) {
            chart.clear();
        }

        // background
        if (document.body) {
            document.body.style.backgroundColor = bgColor;
            document.body.style.backgroundImage = "url(" + bgImage + ")";
        }

        chart = AmCharts.makeChart("chartdiv", {
            type: "stock",
            theme: theme,
            categoryAxesSettings: {
                "minPeriod": "mm"
            },
//            balloonDateFormat: "YYYY-MM-DD JJ:NN",
            /*comparedDataSets : [{

            }],*/
            dataSets: [{
                title: "Price",
                fieldMappings: [{
                    fromField: "value",
                    toField: "value"
                }, {
                    fromField: "volume",
                    toField: "volume"
                }],
                dataProvider: chartData1,
                categoryField: "date",
                showInCompare : true,
                showInSelect : false
                },

                {
                    title: "Market cap",
                    fieldMappings: [{
                        fromField: "value",
                        toField: "value"
                    }, {
                        fromField: "volume",
                        toField: "volume"
                    }],
                    dataProvider: chartData2,
                    categoryField: "date",
                    showInCompare : true,
                    showInSelect : false
                },

            ],
            valueAxesSettings : {
                position : "right"
            },
            panels: [{
                showCategoryAxis: true,
                title: "",
                percentHeight: 70,
                stockGraphs: [{
                    id: "g1",

                    valueField: "value",
                    comparable: true,
                    compareField: "value",
                    /*valueAxis : [{
                        usePrefixes : true
                    }],*/
                    bullet: "round",
                    bulletSize : 0,
                    compareGraphBulletSize : 0,
                    lineThickness: 4,
                    compareGraphLineThickness: 4,
                    balloonText: "[[title]]:<b>$[[value]]</b>",
                    compareGraphBalloonText: "[[title]]:<b>$[[value]]</b>",
                    compareGraphBullet: "round"
                }],
                stockLegend: {
//                    periodValueTextComparing: "[[percent.value.close]]%",
//                    periodValueTextRegular: "$[[value.close]]"
                    valueTextRegular : "$[[value]]",
                    showEntries : true
                }
            },

                {
                    title: "",
                    percentHeight: 30,
                    stockGraphs: [{
                        valueField: "volume",
                        type: "smoothedLine",
                        /*yAxis : [{
                            usePrefixes : true
                        }],*/
                        balloonText: "Volume (24h):<b>$[[value]]</b>",
                        fillAlphas: 1
                    }],
                    stockLegend: {
                        labelText : "Volume (24h)",
//                        periodValueTextRegular: "[[value.close]]"
                        valueTextRegular : "$[[value]]",
                        showEntries : true
                    }
                }
            ],
            chartScrollbarSettings: {
                graph: "g1"
            },

            chartCursorSettings: {
//                categoryBalloonDateFormat:"YYYY-MM-DD JJ:NN",
                valueBalloonsEnabled: true
            },

            periodSelector: /*{
                position: "left",
                periods: [{
                    period: "fff",
                    label: "test",
                    format: "JJ:MM:SS"
                },*/{
                    position: "left",
                    dateFormat:"YYYY-MM-DD JJ:NN",
                    periods: [{
                        period: "DD",
                        count: 10,
                        label: "10 days"
                }, {
                    period: "MM",
                    selected: true,
                    count: 1,
                    label: "1 month"
                }, {
                    period: "YYYY",
                    count: 1,
                    label: "1 year"
                }, {
                    period: "YTD",
                    label: "YTD"
                }, {
                    period: "MAX",
                    label: "MAX"
                }]
            },
            dataSetSelector: {
                position: "left"
            }
        });
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
        <div class="container">
            <div class="content">
                <%--<div class="clip_top">
                    <a href="#"><img src="${CTX}/resources/image/ad/top_banner.jpg" alt="광고"/></a>
                </div>--%>
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
                                <%--<img class="logo" src="${CTX}/resources/image/coin/${coinInfo.ico_image}" onerror="imgError(this,'${CTX}');">--%>
                                <img class="logo" src="https://s2.coinmarketcap.com/static/img/coins/64x64/${coinInfo.coin_id}.png" onerror="imgError(this,'${CTX}');">
                                <div class="name">${coinInfo.coin_name}</div> <span class="h3 font_grey subName">${coinInfo.coin_symbol}</span>
                            </div>
                        </div>
                        <div class="detailBottom">
                            <div class="detailBottomBtn">
                                <div class="rank"><strong class="h3">랭크 ${coinInfo.rank}</strong></div>
                                <div class="coinName">${coinInfo.ico_type}</div>
                            </div>
                        </div>
                        <div class="price">
                            <strong class="h3">
                                ${currency}<fmt:formatNumber pattern="#,##0" minFractionDigits="6">${coinInfo.price_usd * excInfo.exc_rate}</fmt:formatNumber>
                                <span class="h3 <c:choose><c:when test="${coinInfo.percent_change_24h_usd > 0}">font_green</c:when><c:when test="${coinInfo.percent_change_24h_usd < 0}">font_red</c:when></c:choose>">
                                    (<fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_24h_usd}</fmt:formatNumber>%)
                                </span>
                            </strong>
                            <br>
                            <strong class="h3 font_grey sub_price"><fmt:formatNumber  minFractionDigits="8">${coinInfo.price_btc}</fmt:formatNumber> BTC</strong>
                        </div>
                    </div>
                    <div class="detailBookmark">
                        <button type="button" class="button_none" onclick="setBookmark('${coinInfo.ico_id}')">
                            <c:set var="existBookmark" value="false"></c:set>
                            <c:choose>
                                <c:when test="${!empty bookmarkList}">
                                    <c:forEach var="bookmarkList" items="${bookmarkList}">
                                        <c:if test="${bookmarkList.ico_id == coinInfo.ico_id}">
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
                            <c:if test="${coinInfo.ico_state == 1}">
                                <li><a href="#" onclick="moveicoDetail('${coinInfo.ico_id}');">ico 상세보기</a></li>
                            </c:if>
                        </ul>
                    </div>
                </div>
                <div class="margin-bottom" ></div>
                <div class="detail_info">
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
                            &lt;%&ndash;<c:if test="${coinInfo.coin_web_site != null}"><li><a href="${coinInfo.coin_web_site}">웹사이트</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${coinInfo.coin_white_paper != null}"><li><a href="${coinInfo.coin_white_paper}">백서</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${coinInfo.coin_telegram != null}"><li><a href="${coinInfo.coin_telegram}">텔레그램</a></li></c:if>&ndash;%&gt;
                            &lt;%&ndash;<c:if test="${coinInfo.coin_twitter != null}"><li><a href="${coinInfo.coin_twitter}">트위터</a></li></c:if>&ndash;%&gt;
                        </ul>
                    </div>--%>
                    <div class="tab">
                        <table class="coin_detail_table">
                            <colgroup>
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="*">
                                <col width="15%">
                            </colgroup>
                            <tr>
                                <th>시가총액</th>
                                <th>거래량<span>(24시간)</span></th>
                                <th>유통공급량</th>
                                <th>총 공급량</th>
                                <th>총 공급에 따른 시총</th>
                                <th>가격변동<span>(24시간)</span></th>
                                <th>가격변동<span>(7일)</span></th>
                            </tr>
                            <tr>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.market_cap_usd != 0}">
                                            ${currency}<fmt:formatNumber pattern="#,##0">${coinInfo.market_cap_usd * excInfo.exc_rate}</fmt:formatNumber>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.volume_24h_usd != 0}">
                                            ${currency}<fmt:formatNumber pattern="#,##0">${coinInfo.volume_24h_usd * excInfo.exc_rate}</fmt:formatNumber>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.circulating_supply != 0}">
                                            <fmt:formatNumber pattern="#,##0">${coinInfo.circulating_supply}</fmt:formatNumber> ${coinInfo.coin_symbol}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.max_supply != 0}">
                                            <fmt:formatNumber pattern="#,##0">${coinInfo.max_supply}</fmt:formatNumber> ${coinInfo.coin_symbol}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${(coinInfo.price_usd * coinInfo.max_supply) != 0}">
                                            <fmt:formatNumber pattern="#,##0">${coinInfo.price_usd * coinInfo.max_supply}</fmt:formatNumber> ${coinInfo.coin_symbol}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.percent_change_24h_usd > 0}">
                                            <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                        </c:when>
                                        <c:when test="${coinInfo.percent_change_24h_usd < 0}">
                                            <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_24h_usd}</fmt:formatNumber>%</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="center">
                                    <c:choose>
                                        <c:when test="${coinInfo.percent_change_7d_usd > 0}">
                                            <span class="font_green"><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                        </c:when>
                                        <c:when test="${coinInfo.percent_change_7d_usd < 0}">
                                            <span class="font_red"><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span><fmt:formatNumber pattern="#,##0.00">${coinInfo.percent_change_7d_usd}</fmt:formatNumber>%</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                            </tr>
                        </table>
                    </div>
                </div>
                <div class="margin-bottom" ></div>
                <div class="chartdivWarp">
                    <div id="chartdiv" style="width:100%; height:600px;"></div>
                </div>
                <div class="margin-bottom" ></div>
                <div class="tabwarp coinDetailtab">
                    <div class="tab_container">
                        <div class="tabLine"></div>
                        <ul class="tabs">
                            <li class="title active" rel="tab1" >이벤트</li>
                            <li class="title" rel="tab2">ICO 평점 </li>
                        </ul>
                    </div>
                    <div class="tabLine"></div>

                    <div class="tab_content" id="tab1">
                        <table class="coin_event_table">
                            <colgroup>
                                <col width="25%">
                                <col width="40%">
                                <col width="35%">
                            </colgroup>
                            <tr>
                                <th>날짜</th>
                                <th>이벤트</th>
                                <th>상세정보</th>
                            </tr>
                            <c:choose>
                                <c:when test="${!empty eventList}">
                                    <c:forEach var="eventList" items="${eventList}">
                                        <tr>
                                            <td class="center"><span class="dateFormatAddYear">${eventList.event_date}</span></td>
                                            <td class="center">${eventList.coin_event}</td>
                                            <td class="center linkText"><a href="${eventList.link}" class="button_none" target="_blank">${eventList.link}</a></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3">등록된 이벤트가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>

                        </table>
                    </div>
                    <div class="tab_content" id="tab2">
                        <table class="detail_review_table">
                            <colgroup>
                                <col width="40%">
                                <col width="30%">
                                <col width="30%">
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
                <%--<div class="margin-bottom" ></div>
                <div class="detail_company">
                    <div class="title">투자사</div>
                    <div class="imgWarp">
                        <c:choose>
                            <c:when test="${!empty companyList}">
                                <c:forEach var="companyList" items="${companyList}">
                                    <div class="logowarp">
                                        <a href="#" onclick="moveCompanyDetail('${companyList.company_id}')">
                                            <img src="${CTX}/resources/image/company/${companyList.company_image}" onerror="imgError(this,'${CTX}');" alt="${companyList.company_name}">
                                        </a>
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
