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
    })
    function searchEvent(){
        var year = $('#year option:selected').val();
        var month = $('#month option:selected').val();
        var search_text = $('#search_text').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('year',year);
        comForm.addParam('month',month);
        comForm.addParam('search_text',search_text);
        comForm.setUrl('/event');
        comForm.submit();
    }
    function moveDetail(id,state){
        var url = "/coin/coinDetail";
        if(state == '2'){
            url = "/ico/icoDetail";
        }
        var comForm = new CommonForm('commonForm');
        comForm.addParam('id',id);
        comForm.setUrl(url);
        comForm.submit();
    }
    /*function yearSelectAjax(){
        var year = $('#year option:selected').val();
        $.ajax({
            type:"POST",
            data:{'year':year},
            url:"/event/yearSelectAjax",
            cache:"false",
            dataType:"JSON",
            success : function(monthList){
                $('#month').empty();
                var htm = "";
                for(var i=0; i < monthList.length; i++){
                    htm += "<option value='"+monthList[i]['month']+"'>"+monthList[i]['month']+"월</option>"
                }
                $('#month').append(htm);
            },error : function(request,status,error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }*/
    function movePage(currPage){
        var year = $('#year option:selected').val();
        var month = $('#month option:selected').val();
        var search_text = $('#search_text').val();
        var coin_type = $('#coin_type option:selected').val();
        var comForm = new CommonForm('commonForm');
        comForm.addParam('currPage',currPage);
        comForm.addParam('year',year);
        comForm.addParam('month',month);
        comForm.addParam('search_text',search_text);
        comForm.submit();
    }
</script>

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
    <div class="headerPush"></div>
    <div class="content">
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
        <div class="search_section">
            <select class="year" id="year" name="year" onchange="searchEvent();">
                <c:forEach var="yearList" items="${yearList}">
                    <option value="${yearList.year}" <c:if test="${yearList.year == paramMap.year}">selected</c:if>>${yearList.year}년</option>
                </c:forEach>
            </select>
            <select class="month" id="month" name="month" onchange="searchEvent();">
                <%--<c:forEach var="monthList" items="${monthList}">
                    <option value="${monthList.month}" <c:if test="${monthList.month == paramMap.month}">selected</c:if>>${monthList.month}월</option>
                </c:forEach>--%>
                <c:forEach var="month" begin="1" end="12" >
                    <c:choose><c:when test="${month < 10}"><c:set var="monthZero" value="0${month}"/></c:when><c:otherwise><c:set var="monthZero" value="${month}"/></c:otherwise></c:choose>
                    <option value="${month}" <c:if test="${monthZero == paramMap.month}">selected</c:if>>${month}월</option>
                </c:forEach>
            </select>
            <div class="search">
                <input type="text" class="search_text" id="search_text" name="search_text" placeholder="Search" onkeydown="if(event.keyCode==13)searchEvent();" value="${paramMap.search_text}">
                <button type="button" onclick="searchEvent();"><img src="${CTX}/resources/image/search-white.png"></button>
            </div>
        </div>
        <div class="eventTable_wrp">
            <table class="eventTable">
                <colgroup>
                    <col width="*"/>
                    <col width="*"/>
                    <col width="*"/>
                    <col width="30%"/>
                    <col width="*"/>
                </colgroup>
                <tr>
                    <th>날짜</th>
                    <th>이름</th>
                    <th>구분</th>
                    <th>이벤트</th>
                    <th>링크</th>
                </tr>
                <c:choose>
                    <c:when test="${!empty eventList}">
                        <c:forEach var="eventList" items="${eventList}">
                            <c:if test="${eventList.is_expose == 'Y'}">
                                <tr>
                                    <td class="center"><strong class="dateFormatAddYear">${eventList.event_date}</strong><br><span class="font_grey">${eventList.left_day}</span></td>
                                    <td class="center">
                                        <c:set var="url" value=""/>
                                        <c:choose>
                                            <c:when test="${eventList.ico_state == 2}"><c:set var="url" value="/ico/icoDetail"/></c:when>
                                            <c:otherwise><c:set var="url" value="/coin/coinDetail"/></c:otherwise>
                                        </c:choose>
                                            <%--<button type="button" class="button_none" onclick="moveDetail('${eventList.ico_id}','${eventList.ico_state}')"><p>${eventList.ico_name}</p> <span>(${eventList.ico_symbol})</span></button>--%>
                                        <a class="button_none" href="${url}?id=${eventList.ico_id}"><p>${eventList.ico_name}</p> <span>(${eventList.ico_symbol})</span></a>
                                    </td>
                                    <td class="center">
                                        <c:choose>
                                            <c:when test="${eventList.ico_type != null}">
                                                ${eventList.ico_type}
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="center">${eventList.event_name}<%--<c:if test="${eventList.event_name_kor != null}"><br>(${eventList.event_name_kor})</c:if>--%></td>
                                    <td class="center linkText"><c:if test="${eventList.source != null}"><a href="${eventList.source}" class="button_none" target="_blank">${eventList.source}</a></c:if></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6">검색된 데이터가 없습니다.</td>
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
    <div class="footer">
        <%@include file="/WEB-INF/views/comFooter.jsp"%>
    </div>
</body>
</html>
