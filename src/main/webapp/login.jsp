<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	String sessionEmail = (String)session.getAttribute("SessionUserEmail");
	if(sessionEmail!=null)
	{
		int userType = CommonServices.UserType(sessionEmail);
		if(userType == 2 || userType == 4)
			response.sendRedirect("dashboard.jsp");
		else
			response.sendRedirect("dashboardAdminAndLibrarian.jsp");
	}
%>   
 
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="css/loginStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log in</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body>
    <div class="wrapper">
        <div style="display: flex; padding-bottom: 3rem; gap: 5rem; align-items: center;">
            <span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
            <span class="heading">Login</span>
        </div>
        <form action="<%=request.getContextPath()%>/Login" method="post">
            <div style="display: grid;">
                <div class="input" style="padding-bottom: 3rem;">
                    <span class="lebel-box">Email</span>
                    <input id="email" type="text" class="box" name="email" placeholder="Enter your email" required>
                    <img class="fa-solid fa-user-large" style="position: absolute; top: 13rem;     padding-left: 0.5rem;" src="icons/user-solid.svg"></img>
                </div>
                <div class="input">
                    <span class="lebel-box">Password</span>
                    <input id="pass" type="password" class="box" name="password" placeholder="Enter your password" required>
                    <img class="fa-solid fa-lock" style="position: absolute; top: 20.8rem; padding-left: 0.5rem;" src="icons/lock-solid.svg"></img>
                    <span id="eyes" style="display: flex; justify-content: flex-end;">
                        <img class="fa-solid fa-eye-slash" style="position: absolute; top: 21.2rem;" src="icons/eye-slash-solid.svg" onclick="change()"></img>
                    </span>
                </div>
               <div style="display: flex; justify-content: space-between;">
               	<span id="message2"></span>
                <span class="lebel-box-fp" style="padding-bottom: 4rem;"><a href="forgotPass.jsp">Forgot password ?</a></span>
               </div>
                <div style="display: flex; justify-content: center ;">
                    <button type="submit" class="btn">Sign in</button>
                </div>
                <span class="lebel-box-su" style="padding-top: 1rem;">Don't have an account ? <a href="studentRegister.jsp">Sign up</a></span>
            </div>
        </form>
    </div>
    <script src="js/loginScript.js"></script>
</body>
</html>