<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="css/forgotPassStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body id="body">
    <div class="wrapper">
        <div class="content">
        	<div style="display: flex; padding-bottom: 3rem; gap: 1.5rem; align-items: center;">
        		<span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
        		<span class="heading">Forgot Password ?</span>
        	</div>
            
            <form action="<%=request.getContextPath()%>/ForgotPassServlet" method="post">
                <div class="i-fields">
                    <span class="lebel-box">Email</span>
                    <input type="text" class="box" id="email" name="email" placeholder="Enter your email" required>
                    <span id="message"></span>
                </div>
                <div class="i-fields">
                    <span class="lebel-box">Date of birth</span>
                    <input type="date" class="box" style="margin-bottom: 1rem;" id="dob" name="dob" required>
                </div>
                <button type="submit" class="btn">Next</button>
            </form>
            <div style="display: grid; gap: 0.5rem;">
                <span class="lebel-box-su">Don't have an account ? <a class="lu" href="studentRegister.jsp">Sign up</a></span>
                <a href="login.jsp"><span class="lebel-box-su log">Back to login</span></a>
            </div>
        </div>
    </div>
    <script src="js/forgotPassScript.js"></script>
</body>
</html>