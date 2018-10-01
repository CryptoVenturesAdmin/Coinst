<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: BBUGGE
  Date: 2018-08-09
  Time: 오후 2:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/header.jsp"%>
<html>
<body>

<div class="container">

    <div class="header">
        <%@include file="/WEB-INF/views/comHeader.jsp"%>
    </div>
    <div class="headerPush"></div>
    <div class="content">
        <div class="notice">
            <h1>모바일 버전은 추후 제공 예정입니다.</h1>
        </div>
    </div>
    <div class="push"></div>
</div>

<div class="footer">
    <%@include file="/WEB-INF/views/comFooter.jsp"%>
</div>
</body>
</html>