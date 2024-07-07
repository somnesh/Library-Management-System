<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%
	ResultSet rs = CommonServices.getDepartmentNames();
%>
<html lang="en">
<head>
	<script src="https://kit.fontawesome.com/57c36a6797.js" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="css/studentRegisterStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign up</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body>
	<div class="navbar" style="display: block;">
            <span><img src="icons/libraryLogo.svg" alt="Logo" style="transform: scale(0.6);position: fixed;left: var(--gaplogo);top: 13px;"></span>
            <span class="logo" style="position: fixed; top: 20px; left: 70px;"><a href="index.jsp">Library</a></span>
             
            <span class="nav-txt"><a href="index.jsp" style="position: fixed; top: 28px; right: var(--gapHome);">Home</a></span>
            <span class="nav-txt" style="position: fixed; top: 28px; right: var(--gapcon);"><a href="index.jsp#sub">Subjects</a></span>
            <span class="nav-txt srh"><a href="about.jsp">About us</a></span>
            <a href="login.jsp"><input type="button" class="btn" style="padding: 13px 22px 14px 21px; font-size: 13px; position: fixed; right: var(--gap); top: 17px;" value="Sign in"></a>
            <a href="studentRegister.jsp"><input type="button" class="btn" style="padding: 13px 22px 14px 21px; font-size: 13px; position: fixed; right: var(--gapsp); top: 17px;" value="Sign up"></a>
        </div>
    <div class="wrapper"> 
        <div class="content">
            <div style="display: flex; padding-bottom: 3rem; gap: 15rem; align-items: center;">
                <span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
                <span class="heading">Create a new account</span>
            </div>
            <form action="<%=request.getContextPath()%>/StudentRegistration" method="post">
                <div class="container">
                    <div class="columns">
                        <div class="first-col">
                            <span class="lebel-box">First Name</span>
                            <div style="display: flex">
                            <input type="text" class="box" id="firstName" name="firstName" placeholder="Enter your first name" required>
                            <span id="fName-msg"></span>
                            </div>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Email</span>
                            <input type="text" class="box" id="email" name="email" placeholder="Enter your email address" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Roll No.</span>
                            <input type="text" class="box" id="roll" name="roll" placeholder="Enter your roll number" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Department</span>
                            <select class="box" style="width: 20.6rem;" id="department" name="department" required>
                                <option value="" disabled selected hidden>Select your department</option>
                                <%while(rs.next()){ %>
                                <option value="<%=rs.getString("dept_name")%>"><%=rs.getString("dept_name")%></option>
                                <%} %>
                              </select>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Village</span>
                            <input type="text" class="box" id="village" name="village" placeholder="Enter your village name" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Post Office</span>
                            <input type="text" class="box" id="post" name="post" placeholder="Enter your post offce name" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Password</span>
                            <div style="display: flex; align-items: center;">
                                <input type="password" class="box" id="pass" name="password"
                                    placeholder="Create a password" required>
                                <span style="display: flex;" id="e1">
                                    <img class="fa-solid fa-eye-slash" src="icons/eye-slash-solid.svg" onclick="change('pass','e1')"></img>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="columns">
                        <div class="second-col">
                            <span class="lebel-box">Last Name</span>
                            <input type="text" class="box" id="lastName" name="lastName" placeholder="Enter your last name" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Phone Number</span>
                            <input type="number" class="box" id="phone" name="phone" placeholder="Enter your phone number" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Registration No.</span>
                            <input type="text" class="box" id="reg" name="reg" placeholder="Enter your registration number" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Date of Birth</span>
                            <input type="date" class="box" id="dob" name="dob" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">District</span>
                            <input type="text" class="box" id="district" name="district" placeholder="Enter your district" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Pin Code</span>
                            <input type="number" class="box" id="pin" name="pin" placeholder="Enter your pin code" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Confirm Password</span>
                            <div style="display: flex; align-items: center;">
                                <input type="password" class="box" id="conPass" placeholder="Confirm your username" required>
                                <span style="display: flex;" id="e">
                                    <img class="fa-solid fa-eye-slash" src="icons/eye-slash-solid.svg" onclick="change('conPass','e')"></img>
                                </span>
                            </div>
                            <span id="message"></span>
                        </div> 
                    </div>
                </div>
            
            <div onmousemove="check()" style="padding-bottom: 1rem;">
                <button id="submit" type="submit" class="btn">Sign up</button>
            </div>
        </form>
            <span class="lebel-box-su">Already have an account ? <a href="login.jsp">Sign in</a></span>
        </div>
         
    </div>
    <div class="footer">
               <ul class="foot">
                <li class="foot-link"><a href="index.jsp">Home</a></li>
                <li class="foot-link"><a href="index.jsp#services">Services</a></li>
                <li class="foot-link"><a href="#">Contact Us</a></li>
                 <li class="foot-link"><a href="#">Back to top</a></li>
            	</ul>
            <span>Design & Developed by VUDICT Technologies</span>
        </div>
    <script src="js/studentRegisterScript.js"></script>
</body>
</html>    