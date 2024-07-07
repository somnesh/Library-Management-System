<%@page import="com.myApp.LibraryManagement.services.DashboardServices"%>
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
	
	<link rel="stylesheet" href="css/registerStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    <title>Admin Facilities</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body>
<div class="navbar">
		<div>
			<a href="index.jsp" style="display: flex; align-items: center;">
		         <span style="display: flex;">
		         	<img src="icons/libraryLogo.svg" alt="Logo" style="transform: scale(0.6);">
		         </span>
		         <span class="logo">Library</span>
	         </a> 
		</div>
         <span class="nav-txt" style="display: flex;align-items: center;">
         <span><img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);"></span>
		 <%if(userType==1){ %>Admin<%}
         	else
         	{ 
         		PreparedStatement psmt = con.prepareStatement(QueryInterface.getLibrarianDetails);
         		psmt.setString(1, sessionEmail);
         		
         		ResultSet rs = psmt.executeQuery();
         		rs.next();
         	%> <%=rs.getString("First_name") %> <%=rs.getString("Last_name") %><%} %>
		 </span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset; padding: 13px 22px 14px 21px; font-size: 13px; box-shadow: rgb(0 0 0 / 35%) 0px 0px 7px;" class="btn">Sign out</span></a>
      </div> 
    <div class="wrapper">
        <div class="content" style="gap: 20rem;">
            <div>
                <div class="navigation">
                    <ul style="padding-left: 5px;">
                    
                  <li class="list">
                     <a href="dashboardAdminAndLibrarian.jsp">
                        <span class="icon"><ion-icon name="albums-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                     </a>
                  </li>
                   <%if(userType==3){ %>
                  <li class="list">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <%} %>
                  <%if(userType==1){ %>
                  <li class="list">
                     <a href="teacherRegister.jsp">
                        <span class="icon"><ion-icon name="person-add-outline"></ion-icon></span>
                        <span class="title">Add Teacher</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="librarianRegister.jsp">
                        <span class="icon"><ion-icon name="person-add-outline"></ion-icon></span>
                        <span class="title">Add Librarian</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="addDepartment.jsp">
                        <span class="icon"><ion-icon name="business-outline"></ion-icon></span>
                        <span class="title">Add Department</span>
                     </a>
                  </li>
                  <%} %>
                  <li class="list">
                     <a href="addBooks.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Add Books</span>
                     </a>
                  </li>
                  <li class="list active" style="padding-right: 6.2rem;">
                     <a href="addPublishers.jsp">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Add Publisher</span>
                     </a>
                  </li>
                  <%
                  ResultSet rs5 = DashboardServices.notifyBookRequest();
                  %>
                  <li class="list">
                  	 <a href="requestedBooks.jsp">
                        <span class="icon"><ion-icon name="file-tray-full-outline"></ion-icon></span>
                        <span class="title">Requested Books
                        <%if(rs5.next()){if(userType==1){ 
                        	if(rs5.getBoolean("a_notify")){ %><img alt="" src="icons/red-dot.png">
                        <%}}else{ if(rs5.getBoolean("l_notify")){ %><img alt="" src="icons/red-dot.png"><%}}} %></span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="changePassword.jsp">
                        <span class="icon"><ion-icon name="key-outline"></ion-icon></span>
                        <span class="title">Change Password</span>
                     </a>
                  </li>
               </ul>  
                 </div>
                </div>

             <div style="margin-top: 3rem; margin-bottom: 3rem;">

             
        	<div style="display: flex; padding-bottom: 1rem; gap: 13rem; align-items: center; justify-content: center;">
                <span class="heading" style="padding-bottom: 2rem;">Add Publisher</span>
            </div>
            <div id="status-div" style="content-visibility: hidden;">
            	<span id="status"></span>
            </div>
            <form action="<%=request.getContextPath()%>/AddPublishers" method="post">
                <div class="container">
                    <div class="columns">
                        <div class="first-col">
                            <span class="lebel-box">Publisher Name</span>
                            <input type="text" class="box" id="publisher" name="publisher" placeholder="Enter Publisher Name" required>
                        </div>
                    </div>
                </div>
            
            <div style="padding-bottom: 1rem;">
                <button id="submit" type="submit" class="btn">Add Publisher</button>
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
    <script src="js/addPublishersScript.js"></script>
</body>
</html>    
<%}else{response.sendRedirect("badRequest.jsp");}con.close();}%>