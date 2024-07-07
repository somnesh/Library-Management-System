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
else{

	int userType = CommonServices.UserType(sessionEmail); // admin = 1; teacher = 2; librarian = 3; student = 4

	System.out.println("user type jsp : "+userType);
	
	Connection con = DbImplementation.dbConnect();
	
	PreparedStatement psmt2=null;
	if(userType==2)
		psmt2 = con.prepareStatement(QueryInterface.getTeacherDetails);
	
	else if(userType==4)
		psmt2 = con.prepareStatement(QueryInterface.getStudentsDetails);
	
	else if(userType==3)
		psmt2 = con.prepareStatement(QueryInterface.getLibrarianDetails);
	
	psmt2.setString(1, sessionEmail);
	
	ResultSet rs2 = psmt2.executeQuery();
	rs2.next();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="css/changePassStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
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
         <span><img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);"></span><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></span>
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
                  
               </ul>  
                 </div>
                </div>

             <div style="margin-top: 3rem; margin-bottom: 3rem;">

             
        	<div style="display: flex; padding-bottom: 1rem; gap: 13rem; align-items: center; justify-content: center;">
			<span class="heading">Change Password</span>
			</div>
			<div id="status-div" style="content-visibility: hidden;">
            	<span id="status"></span>
            </div>
            <form action="" method="post">
	             <div class="i-fields">
	                 <span class="lebel-box">Old Password</span>
	                 <input type="text" class="box" style="margin-bottom: 35px;" name="password" placeholder="Enter your old password" required>
	             </div>
	             <div class="i-fields">
	                 <span class="lebel-box">New Password</span>
	                 <input type="text" class="box" style="margin-bottom: 35px;" name="password" placeholder="Create a new password" required>
	             </div>
	             <button type="submit" class="btn">Change password</button>
			</form>
        </div>
    </div>
    </div>
</body>
</html>
<%con.close();}%>