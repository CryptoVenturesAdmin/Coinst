<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-26
  Time: 오전 10:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
    var paramMap = new Map();
    <c:forEach var="map" items="${paramMap}">
    paramMap.set('${map.key}','${map.value}');
    </c:forEach>
    $(function(){
        $('#exc_name').val("${excInfo.exc_id}").attr("selected","selected");
        $('#search_name').keyup(function(){
            if(isNull(this.value)){
                $('.search_coin').hide();
            }else{
                $('.search_coin').show();
            }
        })
    })
    $(document).click(function(e){
        $('.search_coin').hide().fadeOut(500);
    });
</script>
<head>
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-123136360-1"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-123136360-1');
    </script>
    <!--google adsense-->
    <!--업로드 시 주석 풀어줄 것!-->
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
    <script>
        (adsbygoogle = window.adsbygoogle || []).push({
            google_ad_client: "ca-pub-6206196082536417",
            enable_page_level_ads: true
        });
    </script>
    <!--<script async custom-element="amp-auto-ads"
            src="https://cdn.ampproject.org/v0/amp-auto-ads-0.1.js">
    </script>-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- google naver -->
    <meta name="description" content="가상화폐 정보">
    <meta name="Keywords" content="코인스트리트, 모든 가상화폐의 정보, 이벤트, 평점">
    <meta name="naver-site-verification" content="4a1b0997ae5d4a73dd9d5c1701aee4824142f60d"/>
    <meta name="google-site-verification" content="zFDei7vIlq5BNdJQrqbGF0Q1jdenum_yee4ofgiWCww" />
    <meta content="코인 스트리트" property="og:title">
    <meta content="코인스트리트, 모든 가상화폐의 정보, 이벤트, 평점" property="og:description">
    <meta content="http://www.coinst.kr/" property="og:url">
    <meta content="${CTX}/resources/image/og.jpg" property="og:image">
    <title>CoinSt.</title>
    <%--<link rel="shortcut icon" type="image/x-icon" href="${CTX}/resources/image/"/>--%>
    <!-- Chrome, Safari, IE -->
    <link rel="shortcut icon" href="${CTX}/resources/image/favicon_.ico">
    <!-- Firefox, Opera (Chrome and Safari say thanks but no thanks) -->
    <link rel="icon" href="${CTX}/resources/image/favicon-16.png">

    <%--<link rel="icon" href="${CTX}resources/image/favicon-16.png" sizes="16x16">
    <link rel="icon" href="${CTX}resources/image/favicon-32.png" sizes="32x32">
    <link rel="icon" href="${CTX}resources/image/favicon-48.png" sizes="48x48">
    <link rel="icon" href="${CTX}resources/image/favicon-64.png" sizes="64x64">
    <link rel="icon" href="${CTX}resources/image/favicon-128.png" sizes="128x128">
    <link rel="icon" href="${CTX}resources/image/favicon-152.png" sizes="152x152">--%>

</head>

<c:choose>
<c:when test="${excInfo.exc_name == 'USD'}"><c:set var="currency">$</c:set></c:when>
<c:when test="${excInfo.exc_name == 'KRW'}"><c:set var="currency">&#8361;</c:set></c:when>
</c:choose>
