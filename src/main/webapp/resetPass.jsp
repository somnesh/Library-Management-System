<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="css/resetPassStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body> 
    <div class="wrapper">
        <form action="<%=request.getContextPath()%>/ResetPassServlet" method="post">
            <div class="content">
            <div style="display: flex; padding-bottom: 3rem; gap: 1.5rem; align-items: center;">
        		<span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
                <span class="heading">Reset Password</span>
             </div>
                <div class="i-fields">
                    <span class="lebel-box">New Password</span>
                    <input type="text" class="box" style="margin-bottom: 35px;" name="password" placeholder="Create a new password" required>
                </div>
            	<button type="submit" class="btn">Reset password</button>
        	</div>
    	</form>
    </div>
</body>
</html>