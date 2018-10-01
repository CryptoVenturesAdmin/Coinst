<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-15
  Time: 오전 10:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/header.jsp"%>
<script>
    var selectMarket = "Bithumb";
    var selectPriceMap = new Map();
    $(function(){
        initialRealTimeData();
        setInterval(function(){
            selectMarket = $('#marketPremium option:selected').val();
            initialRealTimeData();
        },2000);
    })

    $(function(){
        $('.market_table').find('tr').each(function(){
            $(this).find('td').each(function(){
                var Idx = $(this).index();
                var td = $(this);
                if(Idx != 0){
                    setInterval(function(){
                        var txt = parseInt(td.text());
                        var count = parseInt(Math.random()*9)+1;
                        tableHighlight(td, txt, count, 1000);//색상 강조 이벤트
                    }, 3000);
                }
            });
        });
    });

    /* 색상 강조 이벤트
        target : 대상
        beforeNum : 이전 숫자
        afterNum : 바뀐 숫자
        speed : 에니메이션 스피드
    */
    function tableHighlight(target, beforeNum, afterNum, speed){
        target.text(afterNum);
        if(beforeNum <afterNum){
            target.effect('highlight', {
                color: '#cfffdd'
            }, speed);
        } else if(beforeNum > afterNum){
            target.effect('highlight', {
                color: '#ffcfcf'
            }, speed);
        }
    }

    function initialRealTimeData(){

        <c:forEach var="marketList" items="${marketList}">
        getMarketDataAjax('${marketList.name}');
        </c:forEach>
        calPremium(selectPriceMap);
    }

    function getMarketDataAjax(marketName){
        $.ajax({
            url:"/marketDataAjax",
            data:{'marketName':marketName},
            dataType: "JSON",
            success: function(data){
                <c:forEach var="symbolList" items="${symbolList}">
                if(data['${symbolList.coin_symbol}'] != null){
                    $('#${symbolList.coin_symbol}_'+marketName+'_name').html(data['${symbolList.coin_symbol}']['marketName']);
                    $('#${symbolList.coin_symbol}_'+marketName+'_price').html(data['${symbolList.coin_symbol}']['price'].toFixed(2));
                    $('#${symbolList.coin_symbol}_'+marketName+'_volume').html(data['${symbolList.coin_symbol}']['volume_1d'].toFixed(2) + ' ${symbolList.coin_symbol}');
                    $('#${symbolList.coin_symbol}_'+marketName+'_percent_change_24h').html(data['${symbolList.coin_symbol}']['percent_change_24h'].toFixed(2));
                    if(marketName == selectMarket){
                        selectPriceMap.set('${symbolList.coin_symbol}',data['${symbolList.coin_symbol}']['price']);
                        <%--calPremium('${symbolList.coin_symbol}',data['${symbolList.coin_symbol}']['price']);--%>
                    }
                }else{
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
            }/*,
            error:function(request,status,error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }*/
        });
    }
    function selectMarket(){
        selectMarket = $('#marketPremium option:selected').val();
        initialRealTimeData();
        /*var marketName = $('#marketPremium option:selected').val();
        $("tr[id^=BTC]").each(function(){
            this.find("tr").each(function(){

            })
        })*/
    }
    function calPremium(map){
        <c:forEach var="symbolList" items="${symbolList}">
            var symbol = '${symbolList.coin_symbol}';
            var price = map.get(symbol);
            var eachPrice = 0;
            $('tr[id^='+symbol+']').children('td[id$=price]').each(function(){
                eachPrice = $(this).html();
                if(!isNull(eachPrice) && !isNull(price)){
                    var premium = (eachPrice - price) / price * 100;
                    $(this).nextAll('td[id$=premium]').html(premium.toFixed(2)+'%');
                }else{
                    $(this).nextAll('td[id$=premium]').html('0.00%');
                }
            });
        </c:forEach>
    }
    function getAccessToken(){
        var client_id = '881_5g23oz8h3400084o4o88ooc0kwso0ccwwg8gw4o84gs004804g';
        var client_secret = "222ru730zwpwwkw8kwggckws4s4gsook4owkgwsk04gwcss0sw";
        $.ajax({
            url:"https://api.coinmarketcal.com/oauth/v2/token",
            data:{'client_id':client_id,'client_secret':client_secret},
            type:"GET",
            success: function(data){
                debugger;

            }
        })
    }
    function getShowOnly() {
        $.ajax({
            url: "",
            data: {'access_token': ''},
            dataType: "JSON",
            success: function (data) {
                debugger;
                console.log(data.index);
                alert('success');
            }
        })
    }
        /*function onSignIn(googleUser){
        var profile = googleUser.getBasicProfile();
        console.log("ID: "+profile.getId());
        console.log('Full Name: ' + profile.getName());
        console.log('Given Name:' + profile.getGivenName());
        console.log('Family Name: ' + profile.getFamilyName());
        console.log('Image URL: ' + profile.getImageUrl());
        console.log('Email: ' + profile.getEmail());

        var id_token = googleUser.getAuthResponse().id_token;
        console.log("ID Token: "+ id_token);

    }*/

</script>
<html>
<head>
    <title>Title</title>
    <meta name="google-signin-scope" content="profile email">
    <%--<meta name="google-signin-client_id" content="336887541701-5rqfmcc64lit4bjejnuc4n">--%>
    <meta name="google-signin-client_id" content="889786478398-i5ullfc4egh21mlb2h4mrnemrlkvguon.apps.googleusercontent.com">
</head>
    <%--<div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark"> </div>
    <script>
        function onSignIn(googleUser) {
            // Useful data for your client-side scripts:
            var profile = googleUser.getBasicProfile();
            console.log("ID: " + profile.getId()); // Don't send this directly to your server!
            console.log('Full Name: ' + profile.getName());
            console.log('Given Name: ' + profile.getGivenName());
            console.log('Family Name: ' + profile.getFamilyName());
            console.log("Image URL: " + profile.getImageUrl());
            console.log("Email: " + profile.getEmail());

            // The ID token you need to pass to your backend:
            var id_token = googleUser.getAuthResponse().id_token;
            console.log("ID Token: " + id_token);
        };
    </script>
    <script type="text/javascript" src="${CTX}/resources/js/dygraph-2.1.0.js"></script>
    <link rel="stylesheet" src="${CTX}/resources/css/dygraph.css" />
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {'packages':['line']});
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {

            var data = new google.visualization.DataTable();
            data.addColumn('number', 'Day');
            data.addColumn('number', 'Guardians of the Galaxy');
            data.addColumn('number', 'The Avengers');
            data.addColumn('number', 'Transformers: Age of Extinction');

            data.addRows([
                [1,  37.8, 80.8, 41.8],
                [2,  30.9, 69.5, 32.4],
                [3,  25.4,   57, 25.7],
                [4,  11.7, 18.8, 10.5],
                [5,  11.9, 17.6, 10.4],
                [6,   8.8, 13.6,  7.7],
                [7,   7.6, 12.3,  9.6],
                [8,  12.3, 29.2, 10.6],
                [9,  16.9, 42.9, 14.8],
                [10, 12.8, 30.9, 11.6],
                [11,  5.3,  7.9,  4.7],
                [12,  6.6,  8.4,  5.2],
                [13,  4.8,  6.3,  3.6],
                [14,  4.2,  6.2,  3.4]
            ]);

            var options = {
                chart: {
                    title: 'Box Office Earnings in First Two Weeks of Opening',
                    subtitle: 'in millions of dollars (USD)'
                },
                width: 900,
                height: 500,
                axes: {
                    x: {
                        0: {side: 'top'}
                    }
                },
                // Allow multiple
                // simultaneous selections.
                selectionMode: 'multiple',
                // Trigger tooltips
                // on selections.
                tooltip: {trigger: 'selection'},
                // Group selections
                // by x-value.
                aggregationTarget: 'x-value.'

            };

            var chart = new google.charts.Line(document.getElementById('line_chart'));

            chart.draw(data, google.charts.Line.convertOptions(options));
        }
    </script>
    </head>--%>
    <body>
    <%--<div id="line_chart"></div>

    <div id="graphdiv"></div>
    <script type="text/javascript">
        g = new Dygraph(

            // containing div
            document.getElementById("graphdiv"),

            // CSV or path to a CSV file.
            "Date,Temperature\n" +
            "2008-05-07,75\n" +
            "2008-05-08,70\n" +
            "2008-05-09,80\n"

        );
    </script>

    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-XXXXX-Y', 'auto');
        ga('send', 'pageview');
    </script>--%>
    <%--<button type="button" class="" onclick="getMarketDataAjax('Bithumb')">Bithumb</button>
    <button type="button" class="" onclick="getMarketDataAjax('Upbit')">Upbit</button>
    <button type="button" class="" onclick="getMarketDataAjax('Coinone')">Coinone</button>
    <button type="button" class="" onclick="getMarketDataAjax('Binance')">Binance</button>
    <button type="button" class="" onclick="getMarketDataAjax('Bitfinex')">Bitfinex</button>--%>
    <select id="marketPremium" onchange="selectMarket();">
        <option value="Bithum" selected>Bithumb</option>
        <option value="Upbit">Upbit</option>
        <option value="Coinone">Coinone</option>
        <option value="Binance">Binance</option>
        <option value="Bitfinex">Bitfinex</option>
    </select>
    <div id="marketDataTable">
        <c:forEach var="symbolList" items="${symbolList}">
            <div id="${symbolList.coin_symbol}_content">
                <div class="title">${symbolList.coin_symbol}</div>
                <table class="coin_detail_table">
                    <colgroup>
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                    </colgroup>
                    <tr>
                        <th>마켓이름</th>
                        <th>시세</th>
                        <th>프리미엄</th>
                        <th>볼륨</th>
                        <th>변동률</th>
                    </tr>
                    <c:forEach var="marketList" items="${marketList}">
                    <tr id="${symbolList.coin_symbol}_${marketList.name}">
                        <td class="center" id="${symbolList.coin_symbol}_${marketList.name}_name"></td>
                        <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_price"></td>
                        <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_premium"></td>
                        <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_volume"></td>
                        <td class="right" id="${symbolList.coin_symbol}_${marketList.name}_percent_change_24h"></td>
                    </tr>
                    </c:forEach>
                </table>
            </div>
        </c:forEach>
    </div>
</body>
</html>
