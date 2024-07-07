<%@page import="com.myApp.LibraryManagement.services.BorrowBookServices"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%

String sessionEmail = (String)session.getAttribute("SessionUserEmail");
System.out.println(sessionEmail);
//checking session to confirm that the user logged in
if(sessionEmail==null)
{
	response.sendRedirect("login.jsp");
}
else
{
	int userType = CommonServices.UserType(sessionEmail); // admin = 1; teacher = 2; librarian = 3; student = 4
	
	String id;
	System.out.println("user type jsp : "+userType);
	
	Connection con = DbImplementation.dbConnect();
	PreparedStatement psmt2=null;
	
	if(userType==2)
		psmt2 = con.prepareStatement(QueryInterface.getTeacherDetails);
	else
		psmt2 = con.prepareStatement(QueryInterface.getStudentsDetails);
	
	psmt2.setString(1, sessionEmail);
	
	ResultSet rs2 = psmt2.executeQuery();
	rs2.next();
%>

<html>
<head>
   <link rel="stylesheet" href="css/dashboardStyle.css">
   <link rel="icon" type="image/icon" href="icons/favicon.ico">
   <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
   <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
   <title>Request Book</title>
   
   <style>
   
   	.lebel {
   		gap: 5px;
	    display: flex;
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    font-weight: 600;
	    flex-direction: column;
	}
	
	.box:focus {
	    outline: rgb(0, 140, 255) solid 1px;
	    border: 1px solid rgb(0, 140, 255);
	    box-shadow: rgba(14, 30, 37, 0.12) 0px 2px 4px 0px, rgba(14, 30, 37, 0.32) 0px 2px 16px 0px;
	}
	
	.box:hover {
	    outline: rgb(0, 102, 255) solid 1px;
	    border: 1px solid rgb(0, 102, 255);
	    box-shadow: rgba(14, 30, 37, 0.12) 0px 2px 4px 0px, rgba(14, 30, 37, 0.32) 0px 2px 16px 0px;
	}
   </style>
   
</head>

<body>
   <div class="wrapper">
   <%if(!rs2.getBoolean("status")){ %>
	   <div class="banned" id="status">
	        Services are disabled because your account is deactivated. <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">Contact librarian/admin.</a>
	   </div>
   <%} %>
   <div id="status-div" style="content-visibility: hidden;">
   	<span class="banned" id="status"></span>
   	</div>
      <div class="navbar">
		<div>
         <a href="index.jsp" style="display: flex; align-items: center;"><span><img src="icons/libraryLogo.svg" alt="Logo"
               style="transform: scale(0.6);"></span>
         <span class="logo">Library</span></a>
		</div>
		
         <span class="nav-txt" style="display: flex;align-items: center;">
         <span><img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);"></span>Welcome <%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset;" class="btn">Sign out</span></a>
      </div>

      <div class="container" style="gap: 12rem;">
      <div>
            <div class="Navigation">
               <ul>
                  <li class="list">
                     <a href="dashboard.jsp">
                        <span class="icon"><ion-icon name="albums-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                     </a>
                  </li>
                  <li class="list ">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="changePassword.jsp">
                        <span class="icon"><ion-icon name="key-outline"></ion-icon></span>
                        <span class="title">Change Password</span>
                     </a>
                  </li>
                  <li class="list active" style="padding-right: 0; padding: 4px 0 0 4px;">
                     <a href="requestBook.jsp" style="padding-right: 5rem; border-radius: 17px 0px 0 17px; background: #006eff57;">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Request Books</span>
                     </a>
                     <a href="requestedBooks.jsp">
                        <span class="icon"><ion-icon name="file-tray-full-outline"></ion-icon></span>
                        <span class="title">Requested Books</span>
                     </a>
                  </li>
               </ul>
            </div>
		</div>
           
        <div style="margin-top: 3rem;"> 
         <div class="info">
              <div> <span class="logo">Request Books : </span></div>
              
              <form action="<%=request.getContextPath()%>/RequestBook" method="post">
               <div style="display: flex; gap: 2rem; align-items: flex-start;">
                  <section class="field">
                     <div class="cell">
                        <div class="lebel">
                           <span>Book Name</span>
                           <input type="text" class="box" id="bookName" name="bookName" placeholder="Enter book name" required>
                        </div>
                     </div>
                     <div class="cell">
                        <div class="lebel">
                           <span>Publisher</span>
                           <input type="text" class="box" id="publisher" name="publisher" placeholder="Enter publisher name" required>
                        </div>
                     </div> 
                  </section>
                  <section class="field">
                     <div class="cell">
                        <div class="lebel">
                           <span>Author</span>
                           <input type="text" class="box" id="author" name="author" placeholder="Enter author name" required>
                        </div>
                     </div>
                     <div class="cell">
                        <div class="lebel">
                           <span>Edition </span>
                           <input type="text" class="box" id="edition" name="edition" placeholder="Enter edition i.e 1st, 2nd etc." required>
                        </div>
                     </div>
                     
                  </section>
                  </div>
                  	<div class="cell" style="text-align: center; align-items: center; margin-top: 3rem;">
                        <button id="submit" type="submit" style="position: unset; padding: 1rem 5rem; font-size: 17px;" class="btn">Submit</button>
                    </div>
                  </form>                  
                  </div>
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
   </div>
	<script src="js/requestBookScript.js"></script>
</body>
</html>
<% con.close();}%>