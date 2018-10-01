<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-06-09
  Time: 오후 7:31
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="CTX" value="${pageContext.request.contextPath}"/>
<script src="${CTX}/resources/js/jquery-3.2.1.min.js"></script>
<script src="${CTX}/resources/js/common_util.js"></script>
<link rel="stylesheet" href="${CTX}/resources/css/style.css"></link>
<script>
  $(function(){
//      getCoinPriceList(1,100);
  })
  function getCoinPrice(crypto_id, unused_param){
      var url1 = "https://api.coinmarketcap.com/v1/ticker/";

      var full_url = url1 + crypto_id;

      var response = UrlFetchApp.fetch(full_url);
      var data = JSON.parse(response.getContext());

      return data[0]['price_usd'];
  }
  function getCoinPriceList(start,limit){
      $.ajax({
          url:"https://api.coinmarketcap.com/v2/ticker/?start="+start+"&limit="+limit+"&sort=rank",
          success : function( result ){
              var data = result.data;
              debugger;
              <c:forEach var="num" begin="1" end="100">
              $('#RANK_${num}').html(data[${num}]['rank']);
              $('#NAME_${num}').html(data[${num}]['name']);
              $('#SYMBOL_${num}').html(data[${num}]['symbol']);
              $('#PRICE_USD_${num}').html(data[${num}]['price_usd']);
              </c:forEach>
          }

      })
  }
  function sendMail(){
      $.ajax({
          url:"mailAjax",
          type:"POST",
          data:{'user':'silvercl@naver.com'},
          dataType:"JSON",
          success: function(data){
              console.log(data.index);
              alert('success');
          }
      })
  }
  function moveDetail(name,symbol){
      var comForm = new CommonForm('commonForm');
      comForm.addParam('name',name);
      comForm.addParam('symbol',symbol);
      comForm.setUrl('/coinDetail');
      comForm.submit();
  }
</script>

<%@include file="/WEB-INF/views/comHeader.jsp"%>
    <div class="content">
      <h2>&gt; 상장된 코인 목록</h2>
      <table class="coin_table">
        <colgroup>
          <col width="5%"/>
          <col width="7%"/>
          <col width="10%"/>
          <col width="7%"/>
          <col width="*"/>
          <col width="*"/>
          <col width="*"/>
          <col width="*"/>
          <col width="*"/>
        </colgroup>
        <tr>
          <th>랭킹</th>
          <th>변동<br>(1달)</th>
          <th>
            <select class="sort_box">
              <option value="">이름</option>
              <option value="">수익률</option>
              <option value="">평점</option>
              <option value="">시가총액</option>
            </select>
          </th>
          <th>
            <select class="sort_box">
              <option value="">구분</option>
              <option value="">화폐</option>
              <option value="">사물인터넷</option>
              <option value="">플랫폼</option>
              <option value="">보안</option>
              <option value="">보험</option>
            </select>
          </th>
          <th>시가총액</th>
          <th>현재가격</th>
          <th>가격변동 (24시간)</th>
          <th>가격변동 (7일)</th>
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
        <tr>
          <td class="center">1</td>
          <td class="center"><strong>0</strong></td>
          <td class="center"><button type="button" class="button_none" onclick="moveDetail('Bitcoin','BTC');">Bitcoin</button></td>
          <td class="center">화폐</td>
          <td class="center">139,019,849,070,392</td>
          <td class="center">8,147,325</td>
          <td class="center"><span class="font_red">0.35</span></td>
          <td class="center"><span class="font_green">0.78</span></td>
          <td>☆</td>
        </tr>
        <tr>
          <td class="center">2</td>
          <td class="center"><strong class="font_blue">↓1</strong></td>
          <td class="center">Bitcoin</td>
          <td class="center">화폐</td>
          <td class="center">139,019,849,070,392</td>
          <td class="center">8,147,325</td>
          <td class="center"><span class="font_red">0.35</span></td>
          <td class="center"><span class="font_green">0.78</span></td>
          <td>☆</td>
        </tr>
        <c:forEach var="num" begin="1" end="100">
          <tr>
            <td class="center">3</td>
            <td class="center"><strong class="font_red">↑1</strong></td>
            <td class="center">Bitcoin</td>
            <td class="center">화폐</td>
            <td class="center">139,019,849,070,392</td>
            <td class="center">8,147,325</td>
            <td class="center"><span class="font_red">0.35</span></td>
            <td class="center"><span class="font_green">0.78</span></td>
            <td>☆</td>
          </tr>
        </c:forEach>
      </table>
    </div>
    <%--<div class="sidebar">
      <a href="#">&gt; 상장된 코인</a>
      &lt;%&ndash;<ul>
        <li><a href="#">Lorem</a></li>
        <li><a href="#">Ipsum</a></li>
        <li><a href="#">Dolor</a></li>
      </ul>&ndash;%&gt;
    </div>--%>
    <%--<div class="footer">
      <p>Copyright</p>
    </div>--%>
  </div>
  <%--<c:forEach begin="1" end="10" var="test">
    ${test}
  </c:forEach>
  <br/>--%>
  <%--<c:if test="${memberList != null}">
    <c:forEach var="list" items="${memberList}">
      ${list.F_ID}<br/>
  </c:forEach>
  </c:if>--%>
  <%--<button type="button" onclick="getCoinPriceList(1,100);">refresh</button>
  <table id="">
    <c:forEach var="number" begin="1" end="100">
    <tr>
      <td><span id="get_ID_${number}"></span></td>
      <td><span id="get_NAME_${number}"></span></td>
      <td><span id="get_SYMBOL_${number}"></span></td>
      <td><span id="get_PRICE_USD_${number}"></span></td>
    </tr>
    </c:forEach>
  <button type="button" onclick="sendMail();">SEND MAIL</button>
  </table>
  ${data}
  asdasd--%>
  </body>
</html>
