<%@page import="com.myApp.LibraryManagement.services.DashboardServices"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	String id;
	System.out.println("user type jsp : "+userType);
	Connection con = DbImplementation.dbConnect();
	PreparedStatement psmt2=null;
	if(userType==2)
	{	
		id = CommonServices.getTeacherId(sessionEmail);
		psmt2 = con.prepareStatement(QueryInterface.getTeacherDetails);
	}
	else if(userType==4)
	{		
		id = CommonServices.getStudentId(sessionEmail);
		psmt2 = con.prepareStatement(QueryInterface.getStudentsDetails);
	}
	else if(userType==3)
	{
		id = CommonServices.getLibrarianId(sessionEmail);
		psmt2 = con.prepareStatement(QueryInterface.getLibrarianDetails);
	}
	
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
   <title>Dashboard</title>
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
         <span><img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);"></span><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset;" class="btn">Sign out</span></a>
      </div>

      <div class="container">
            <div class="Navigation">
               <ul>
                  <li class="list">
                     <%if(userType!=3){ %><a href="dashboard.jsp"><%}else{ %><a href="dashboardAdminAndLibrarian.jsp"><%} %>
                        <span class="icon"><ion-icon name="albums-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                     </a>
                  </li>
                  <li class="list active" style="padding-right: 9.7rem">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <%if(userType==3){ %>
                  <li class="list">
                     <a href="addBooks.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Add Books</span>
                     </a>
                  </li>
                  <li class="list">
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
                        <%if(userType==1){ 
                        	if(rs5.getBoolean("a_notify")){ %><img alt="" src="icons/red-dot.png">
                        <%}}else{ if(rs5.getBoolean("l_notify")){ %><img alt="" src="icons/red-dot.png"><%}} %></span>
                     </a>
                  </li>
                  
                  <%} %>
                  <li class="list">
                     <a href="changePassword.jsp">
                        <span class="icon"><ion-icon name="key-outline"></ion-icon></span>
                        <span class="title">Change Password</span>
                     </a>
                  </li>
                  <%if(userType!=3){ %>
                  <li class="list">
                     <a href="requestBook.jsp">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Request Books</span>
                     </a>
                  </li>
                  <%} %>
               </ul>   
            </div>
            <div class="info" style="margin-top: 3rem;">
               <span class="logo">Profile Details : </span>
               <div style="display: flex; gap: 2rem; align-items: flex-start;">
                  <section class="field">
                     <div class="cell">
                        <div class="lebel">
                           <span>Name</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></span>
                        </div>
                     </div>
                     <%if(userType!=3){ %>
                     <div class="cell">
                        <div class="lebel">
                           <span>Department</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("Dept_Name") %></span>
                        </div>
                     </div>
                     <%} %>
                     <%if(userType == 4){ %>
                     <div class="cell">
                        <div class="lebel">
                           <span>Roll No.</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("Roll_no") %></span>
                        </div>
                     </div> 
                     <%} %>
                     <div class="cell">
                        <div class="lebel">
                           <span>Address</span>
                        </div>
                        <div class="box" style="display: flex; justify-content: space-between;">
                        	<div>
                        		<div>
	                        		<span>Village : <%=rs2.getString("village") %></span>
	                        	</div>
	                        	<div>
	                           		<span>Post : <%=rs2.getString("post") %></span>
	                        	</div>
                        	</div>
                        	<div>
                        		<div>
	                           		<span>District : <%=rs2.getString("district") %></span>
	                           </div>
	                           <div>
	                           		<span>Pin code : <%=rs2.getString("pin") %></span>
	                           </div>
                        	</div>
                        </div>
                     </div> 
                  </section>
                  <section class="field">
                  <%if(userType == 4){ %>
                     <div class="cell">
                        <div class="lebel">
                           <span>Registration No.</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("Reg_no") %></span>
                        </div>
                     </div>
                     <%} %>
                     <div class="cell">
                        <div class="lebel">
                           <span>Date of Birth</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("Dob") %></span>
                        </div>
                     </div>
                     <div class="cell">
                        <div class="lebel">
                           <span>Phone No.</span>
                        </div>
                        <div class="box">
                           <span><%=rs2.getString("phone") %></span>
                        </div>
                     </div>
                     <div class="cell" style="text-align: center; align-items: center;">
                        <a href="updateProfile.jsp" class="btn" style="position: unset; width: 50%;">Update Profile</a>
                     </div>
                  </section>
               </div>
            </div>
         </div>
      </div>
   <footer>
      <ul class="foot">
         <li><a href="">Home</a></li>
         <li><a href="">Services</a></li>
         <li><a href="">Social Links</a></li>
         <li><a href="">Contact Us</a></li>
      </ul>
      <b>
         <p>Design & Developed by VUDICT Technologies</p>
      </b>
      <!--<p>Copyright | All Rights Reserved</p>-->
   </footer>
   <script>
   
   function submitForm(id)
   {
   	var uncheck=document.getElementsByName('record');
       for(var i=0;i<uncheck.length;i++)
       {
           if(uncheck[i].type=='checkbox')
           {
               uncheck[i].checked=false;
           }
       }
   	
   	console.log(id);
   	if(confirm("Are you want to return this book ?"))
   		document.getElementById(id).checked = true;
	else
		exit(0);
   	
   	console.log("checked");
   	document.getElementById("form").submit();
   }
   
   </script>
</body>
</html>
<% con.close();}%>