<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.PreparedStatement"%>
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
		Connection con = DbImplementation.dbConnect();
		if(userType==1 || userType==3)
		{
			String pid = (String)session.getAttribute("pid");
			ResultSet pDetails = CommonServices.getPublisherDetails(pid);
			pDetails.next();
%>

    
<!DOCTYPE html>
<html>
<head>
   <link rel="stylesheet" href="css/userDetailStyle.css">
   <link rel="icon" type="image/icon" href="icons/favicon.ico">
   <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
   <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
   <title>User Details</title>
   <style>
   
	.columns {
	    display: grid;
	    gap: 1.5rem;
	}
	
	.first-col {
	    gap: 0.3rem;
	    display: grid;
	}
	
	.lebel-box {
	    display: flex;
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    font-weight: 500;
	}
	
	.box {
	    width: 17rem;
	    font-size: 15px;
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    font-weight: 500;
	    border: 1px solid rgb(255, 255, 255);
	    border-radius: 5px;
	    outline: black solid 1px;
	    line-height: 1.2;
	    padding: 0.8rem 2.5rem 0.8rem 1rem;
	    /* border-bottom: 2px solid black; */
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
	
	.container2 {
	    display: flex;
	    gap: 8rem;
	    padding-bottom: 3rem;
	}
	
	.heading {
	    text-align: center;
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    font-size: 25px;
	    font-weight: 700;
	}
	
	.footer
	{
	    display: grid;
	    box-sizing: border-box;
	    box-shadow: rgb(0 0 0 / 35%) 0px 0px 15px;
	    border-top-left-radius: 10px;
	    border-top-right-radius: 10px;
	    margin: 8px 8px 0px 8px;
	    background-color: #ffffff;
	    padding: 1rem 4rem 2rem;
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    font-weight: 700;
	    font-size: 1.2rem;
	    justify-items: center;
	}
	
	.foot-link{
		font-size: 1rem;
		list-style: none;
	}
	
	.foot{
		display: flex;
		margin-top: 1em;
	    margin-bottom: 1em;
		gap: 1rem;
	}
	
	.back
	{
		padding: 0;
	    display: flex;
	    align-items: center;
	    border-radius: 4rem;
	    width: 46px;
	    height: 2.8rem;
	    border: 1px solid rgba(255, 255, 255, 0);
	}
	
	.back:hover
	{
	    box-shadow: rgba(0, 0, 0, 0.35) 0px 0px 10px;
	}
	
	.back:active
	{
	    box-shadow: rgba(255, 255, 255, 0.35) 0px 0px 10px;
	    background-color: gray;
	    filter: invert();
	}
	
   </style>
</head>
<body>
   <div class="wrapper">
    <div class="navbar">
		<div>
         <a href="index.jsp" style="display: flex; align-items: center;"><span><img src="icons/libraryLogo.svg" alt="Logo"
               style="transform: scale(0.6);"></span>
         <span class="logo">Library</span></a>
		</div>
         <span class="nav-txt" style="display: flex;align-items: center;">
         	<span>
         		<img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);">
         	</span>
         	<%if(userType==1){ %>Admin<%}
         	else
         	{ 
         		PreparedStatement psmt = con.prepareStatement(QueryInterface.getLibrarianDetails);
         		psmt.setString(1, sessionEmail);
         		
         		ResultSet rs = psmt.executeQuery();
         		rs.next();
         	%> <%=rs.getString("First_name") %> <%=rs.getString("Last_name") %><%} %></span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset;" class="btn">Sign out</span></a>
      </div>

      <div class="container" style="gap: 21rem; justify-content: flex-start;">
            <div class="navigation">
               <ul style="display: grid; padding-top: 40px;">
                  <li class="list">
                     <a href="studentDetails.jsp">
                        <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                        <span class="title">Students</span>
                     </a>
                  </li>
                  <%if(userType==1){ %>
                  <li class="list">
                     <a href="teacherDetails.jsp">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">Teachers</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="librarianDetails.jsp">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">Librarians</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="departmentDetails.jsp">
                        <span class="icon"><ion-icon name="business-outline"></ion-icon></span>
                        <span class="title">Departments</span>
                     </a>
                  </li>
                  <%} %>
                  <li class="list">
                     <a href="bookDetails.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Books</span>
                     </a>
                  </li>
                  <li class="list active" style="padding-right: 5.12rem;">
                     <a href="publishersDetails.jsp">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Publishers</span>
                     </a>
                  </li>
               </ul>   
            </div>
            
            <div style="margin-top: 3rem; margin-bottom: 3rem;">

             
        	<div style="display: flex; padding-bottom: 2rem; gap: 2rem; align-items: center;">
        	<span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
                <span class="heading">Update Publisher</span>
            </div>
            <div id="status" style="margin-bottom: 2rem;" hidden="hidden"></div>
            <form action="<%=request.getContextPath()%>/updatePublisher" method="post">
                <div class="container2">
                    <div class="columns">
                        <div class="first-col">
                            <span class="lebel-box">Publisher Name</span>
                            <input type="text" class="box" id="Publisher" name="pName" placeholder="Enter Publisher Name" value="<%=pDetails.getString("pName")%>" required>
                        </div>
                    </div>
                </div>
            
            <div style="padding-bottom: 1rem; text-align: center;">
                <button id="submit" type="submit" class="btn" style="position: unset;">Update Publisher</button>
            </div>
        </form>
        </div>
            
		</div>
	</div>
	<div class="footer">
               <ul class="foot" style="padding-left: 0px;">
                <li class="foot-link"><a href="index.jsp">Home</a></li>
                <li class="foot-link"><a href="index.jsp#services">Services</a></li>
                <li class="foot-link"><a href="#">Contact Us</a></li>
                 <li class="foot-link"><a href="#">Back to top</a></li>
            	</ul>
            <span>Design & Developed by VUDICT Technologies</span>
	</div>
	<script src="js/updatePublisherScript.js"></script>
</body>
</html>
<%}else{response.sendRedirect("badRequest.jsp");}con.close();}%>