<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="kalam.ttf" />
    <link rel="stylesheet" href="css/indexStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to our e-library</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body>
    <div class="wrapper">
        <div class="navbar">
            <span><img src="icons/libraryLogo.svg" alt="Logo" style="transform: scale(0.6);position: fixed;left: var(--gaplogo);top: 13px;"></span>
            <span class="logo"><a href="index.jsp">Library</a></span>
            
            <span class="nav-txt"><a href="index.jsp">Home</a></span>
            <span class="nav-txt" style="right: var(--gapcon);"><a href="#sub">Subjects</a></span>
            <span class="nav-txt srh"><a href="about.jsp">About us</a></span>
            <a href="login.jsp"><input type="button" class="btn" value="Sign in"></a>
            <a href="studentRegister.jsp"><input type="button" class="btn" value="Sign up" style="right:var(--gapsp)"></a>
        </div>
        
        <div class="container">
            <section>
                <div class="txt">
                    <span>"Reading is essential for those who seek to rise above the ordinary."</span>
                    <div class="txt-two">
                        <span style="font-size: 1.5rem;">Get full access of various types of books for free</span>
                        <a style="width: fit-content;" href="studentRegister.jsp"><input type="button" class="btn-two" value="Register Now"></a>
                    </div>
                </div>
                <div class="image-section">
                    <img src="icons/e-book.svg" alt="" style="height: 17rem; padding: 5rem 6rem 3rem 3rem;">
                </div>
            </section>
            <section id="services">
                <div class="image2">
                    <img src="icons/mobile-book.svg" alt="" style="height: 19rem; padding: 3rem 6rem;">
                </div>
                <div class="txt" style="padding-top: 3rem;">
                    <span>Our library offers :
                        <ul style="font-size: 2.5rem; margin-top: 0px;">
                        
                            <li><%=CommonServices.noOfBooks()%> &nbsp;Books</li>
                            <li><%=CommonServices.noOfDeparments()%> &nbsp;Subjects</li>
                            <li>6 &nbsp;Days borrow policy</li>
                            <li>24*7 &nbsp;Service</li>
                        </ul>
                    </span>
                </div>
            </section>
            <section id="sub" style="display: block;">
                <div class="txt">
                   <span>Subjects we have :</span>
                   <span style="font-size: 2.5rem;">Arts :</span>
                   <table style="width: 100%; font-size: 2rem;">
                    <tr>
                        <td>Bengali</td>
                        <td>English</td>
                        <td>Geography</td>
                        <td>History</td>
                    </tr>
                    <tr>
                        <td>Philosophy</td>
                        <td>Political Science</td>
                        <td>Sanskrit</td>
                    </tr>
                   </table>

                   <span style="font-size: 2.5rem;">Commerce :</span>
                   <table style="width: 100%; font-size: 2rem;">
                        <tr>
                            <td>Accountancy</td>
                            <td>Economics</td>
                            <td>Statictics</td>
                        </tr>
                    </table>

                   <span style="font-size: 2.5rem;">Science :</span>
                   <table style="width: 100%; font-size: 2rem;">
                       <tr>
                            <td>Chemistry</td>
                            <td>Biology</td>
                            <td>Electronics</td>
                            <td>Physics</td>
                        </tr>
                        <tr>
                            <td>Computer Application</td>
                            <td>Computer Science</td>
                            <td>Mathematics</td>
                        </tr>
                    </table>
                </div>
            </section>
        </div>

        <div class="footer">
               <ul class="foot">
                <li class="foot-link"><a href="index.jsp">Home</a></li>
                <li class="foot-link"><a href="#services">Services</a></li>
                <li class="foot-link"><a href="#">Contact Us</a></li>
                 <li class="foot-link"><a href="#">Back to top</a></li>
            	</ul>
            <span>Design & Developed by VUDICT Technologies</span>
        </div>
        </div>
</body>
</html>