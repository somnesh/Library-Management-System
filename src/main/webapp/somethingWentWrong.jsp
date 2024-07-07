<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="css/badRequestStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="somethingWentWrongStyle.css">
    <title>Something Went Wrong</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body>
    <div class="messege">
        <span>Something Went Wrong ⚠️</span>
    </div>
    <%
		String sessionEmail = (String)session.getAttribute("SessionUserEmail");
		if(sessionEmail==null)
		{
	%>
    <div class="messege btn">
        <a href="index.jsp"><span>Back to Home</span></a>
    </div>
    <%}else{ %>
    <div class="messege btn">
        <span style="cursor: pointer;" onclick="window.history.back()">Back</span>
    </div>
    <%} %>
</body>
</html>