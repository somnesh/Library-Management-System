<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
String sessionEmail = (String)session.getAttribute("SessionUserEmail");
System.out.println(sessionEmail);

if(sessionEmail==null)
{
	System.out.println("boom");
	response.sendRedirect("index.jsp");
}
else{

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
    <link rel="stylesheet" href="css/signUpConfirm.css">
    <title>Sign up success</title>
    </head>
<body>
    <div class="wrapper">
        <div class="content" style="justify-items: center;">
            <span><img src="icons/party-popper.png" alt="party-popper"></span>
            <div class="container">
                <span class="heading" style="margin: 1em 0 7px 0; font-size: 35px; font-weight: 700;">Thank you!</span>
                <span class="heading" style="font-size: 20px; font-weight: 600;">Your account created successfully</span>
            </div>
            <a href="dashboard.jsp" class="btn">Go to dashboard</a>
        </div>
    </div>
</body>
</html>
<%}%>