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
    var selectMarketName = "Bitfinex";
    var selectPriceMap = new Map();
    $(function(){
        initialRealTimeData();
        setInterval(function(){
            selectMarketName = $('#marketPremium option:selected').val();
            initialRealTimeData();
        },3000);
    })

    function initialRealTimeData(){
        getMarketDataAjax();
        calPremium(selectPriceMap);
    }

    function getMarketDataAjax(){
        $.ajax({
            url:"/marketDataAjax",
            dataType: "JSON",
            success: function(rtnList){
                for(var i = 0; i < rtnList.length; i++){
                    var data = rtnList[i];
                    <c:forEach var="symbolList" items="${symbolList}">

                    if(data['${symbolList.coin_symbol}'] != null){
                        var marketName = data['${symbolList.coin_symbol}']['marketName'];
                        var price = data['${symbolList.coin_symbol}']['price'];
                        var fluctate_font_color = 'font_green';
                        var fluctate_rate_font_color = 'font_green';
                        var fluctate_sign = '';
                        var fluctate_24h = data['${symbolList.coin_symbol}']['fluctate_24h'];
                        var fluctate_rate_24h = data['${symbolList.coin_symbol}']['fluctate_rate_24h'];
                        var volume_1d_krw = Math.floor(data['${symbolList.coin_symbol}']['volume_1d_krw'] / 10000) * 10000;

                        if(fluctate_24h < 0){
                            fluctate_font_color = 'font_red';
                            fluctate_sign = '-';
                        }else if(fluctate_24h == 0){
                            fluctate_font_color = '';
                            fluctate_sign = '';
                        }
                        if(fluctate_rate_24h < 0){
                            fluctate_rate_font_color = 'font_red';
                        }else if(fluctate_rate_24h == 0){
                            fluctate_rate_font_color = '';
                        }

                        $('#${symbolList.coin_symbol}_'+marketName+'_name').html(marketName);

                        var before_price = $('#${symbolList.coin_symbol}_'+marketName+'_price').children('span').attr('val');
                        tableHighlight($('#${symbolList.coin_symbol}_'+marketName+'_price'),before_price,price,1000);
                        $('#${symbolList.coin_symbol}_'+marketName+'_price').html('<span val="'+price.toFixed(0)+'">&#8361;'+numberWithCommas(price.toFixed(0))+'</span>');

                        var before_fluctate_24h = $('#${symbolList.coin_symbol}_'+marketName+'_fluctate_24h').children('span').attr('val');
                        tableHighlight($('#${symbolList.coin_symbol}_'+marketName+'_fluctate_24h'),before_fluctate_24h,fluctate_24h,1000);
                        $('#${symbolList.coin_symbol}_'+marketName+'_fluctate_24h').html('<span class="'+fluctate_font_color+'" val="'+fluctate_24h+'">'+fluctate_sign+' &#8361;'+numberWithCommas(Math.abs(fluctate_24h).toFixed(0))+'</span>');

                        var before_fluctate_rate_24h = $('#${symbolList.coin_symbol}_'+marketName+'_fluctate_rate_24h').children('span').attr('val');
                        tableHighlight($('#${symbolList.coin_symbol}_'+marketName+'_fluctate_rate_24h'),before_fluctate_rate_24h,fluctate_rate_24h,1000);
                        $('#${symbolList.coin_symbol}_'+marketName+'_fluctate_rate_24h').html('<span class="'+fluctate_rate_font_color+'" val="'+fluctate_rate_24h+'">'+fluctate_rate_24h.toFixed(2)+'%</span>');

                        var before_volume = $('#${symbolList.coin_symbol}_'+marketName+'_volume').children('span').attr('val');
                        tableHighlight($('#${symbolList.coin_symbol}_'+marketName+'_volume'),before_volume,(volume_1d_krw / 100000000).toFixed(0),1000);
                        $('#${symbolList.coin_symbol}_'+marketName+'_volume').html('<span val="'+(volume_1d_krw / 100000000).toFixed(0)+'">&#8361;'+numberWithCommas((volume_1d_krw / 100000000).toFixed(0))+'</span>');

                        if(marketName == selectMarketName){
                            selectPriceMap.set('${symbolList.coin_symbol}',price.toFixed(0));
                            <%--calPremium('${symbolList.coin_symbol}',data['${symbolList.coin_symbol}']['price']);--%>
                        }
                    }else{
                        $('#${symbolList.coin_symbol}_'+marketName).addClass('nullData');
                        $('#${symbolList.coin_symbol}_'+marketName).empty();
                    };
                    if(marketName == 'Bitfinex'){
                        var obj = $('#${symbolList.coin_symbol}_content').find('td');
                        if(isNull(obj)){
                            $('#${symbolList.coin_symbol}_content').hide();
                        }else{
                            $('#${symbolList.coin_symbol}_content').show();
                        }
                    }
                    </c:forEach>
                }
            }/*,
            error:function(request,status,error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }*/
        });
    }
    function selectMarket(){
        selectMarketName = $('#marketPremium option:selected').val();
        initialRealTimeData();
    }
    function calPremium(map){
        <c:forEach var="symbolList" items="${symbolList}">
        var symbol = '${symbolList.coin_symbol}';
        var price = map.get(symbol);
        var eachPrice = 0;
        $('tr[id^='+symbol+']').children('td[id$=price]').children('span').each(function(){
            eachPrice = $(this).attr('val');
            var font_color = "font_green";
            var td = $(this).parent().nextAll('td[id$=premium]');
            if(!isNull(eachPrice) && !isNull(price)){
                var premium = (eachPrice - price) / price * 100;
                if(premium < 0){
                    font_color = 'font_red';
                }else if(premium == 0){
                    font_color = '';
                }
                var before_premium = td.children('span').attr('val');
                tableHighlight(td,before_premium,premium,1000);
                td.html('<span class="'+font_color+'" val="'+premium+'">'+premium.toFixed(2)+'%</span>');
            }else{
                var before_premium = td.children('span').attr('val');
                tableHighlight(td,before_premium,0,1000);
                td.html('<span class="" val="0">0.00%</span>');
            }

        });
        </c:forEach>
    }

    /* 색상 강조 이벤트
        target : 대상
        beforeNum : 이전 숫자
        afterNum : 바뀐 숫자
        speed : 에니메이션 스피드
    */
    function tableHighlight(target, beforeNum, afterNum, speed){
        if(beforeNum < afterNum){
            target.effect('highlight', {
                color: '#cfffdd'
            }, speed);
        } else if(beforeNum > afterNum){
            target.effect('highlight', {
                color: '#ffcfcf'
            }, speed);
        }
    }

</script>
<body>
    <%--<amp-auto-ads type="adsense"
                  data-ad-client="ca-pub-8109245012699678">
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
            <div id="marketDataTable">
                <div class="market_selection">
                    <select class="market" id="marketPremium" onchange="selectMarket();">
                        <option value="Bitfinex" selected>Bitfinex</option>
                        <option value="Binance">Binance</option>
                        <option value="Bithumb">Bithumb</option>
                        <option value="Upbit">Upbit</option>
                        <option value="Coinone">Coinone</option>
                    </select>
                </div>
                <c:forEach var="symbolList" items="${symbolList}">
                    <div id="${symbolList.coin_symbol}_content">
                        <div class="title">${symbolList.coin_symbol}</div>
                        <table class="market_table">
                            <colgroup>
                                <col width="10%">
                                <col width="20%">
                                <col width="20%">
                                <col width="15%">
                                <col width="15%">
                                <col width="20%">
                            </colgroup>
                            <tr>
                                <th>마켓이름</th>
                                <th>현재 시세</th>
                                <th>등락가</th>
                                <th>등락폭</th>
                                <th>프리미엄</th>
                                <th>거래량 (억원)</th>
                            </tr>
                            <c:forEach var="marketList" items="${marketList}">
                                <tr id="${symbolList.coin_symbol}_${marketList.name}">
                                    <td class="center" id="${symbolList.coin_symbol}_${marketList.name}_name"></td>
                                    <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_price"></td>
                                    <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_fluctate_24h"></td>
                                    <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_fluctate_rate_24h"></td>
                                    <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_premium"></td>
                                    <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_volume"></td>
                                </tr>
                            </c:forEach>
                        </table>
                        <div class="margin-bottom" ></div>
                    </div>
                </c:forEach>
            </div>
            <div class="push"></div>
        </div>
    </div>
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>
