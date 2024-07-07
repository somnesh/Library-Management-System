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
			PreparedStatement psmt4 = con.prepareStatement(QueryInterface.getLibrarianDetails);
			
			psmt4.setString(1, sessionEmail);
			
			ResultSet rs4 = psmt4.executeQuery();
			rs4.next();
%>
<html>
<head>
   <link rel="stylesheet" href="css/dashboardAdminAndLibrarianStyle.css">
   <link rel="icon" type="image/icon" href="icons/favicon.ico">
   <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
   <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
   <title>Dashboard</title>
</head>
<body>
<%if(userType!=1){if(!rs4.getBoolean("status")){ %>
	   <div class="banned" style="margin: 0 8px;">
	        Services are disabled because your account is deactivated. <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">Contact Librarian/Admin.</a>
	   </div>
   <%} }%>
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
         	Welcome <%if(userType==1){ %>Admin<%}
         	else
         	{ 
         		PreparedStatement psmt = con.prepareStatement(QueryInterface.getLibrarianDetails);
         		psmt.setString(1, sessionEmail);
         		
         		ResultSet rs = psmt.executeQuery();
         		rs.next();
         	%> <%=rs.getString("First_name") %> <%=rs.getString("Last_name") %><%} %></span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset;" class="btn">Sign out</span></a>
      </div>

      <div class="container" style="flex-direction: column; <%if(userType!=1){if(!rs4.getBoolean("status")){ %>pointer-events: none; filter: grayscale(1);<%}} %>">
      <div style="display: flex; gap: 1rem;">
            <div class="navigation">
               <ul style="display: grid; padding-top: 40px;">
                  <li class="list active" style="padding-right: 7.6rem;">
                     <a href="dashboardAdminAndLibrarian.jsp">
                        <span class="icon"><ion-icon name="albums-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                     </a>
                  </li>
                  <%if(userType==1){ %>
                  <li class="list" style="padding: 0;">
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
                  <%} if(userType==3){%>
                  <li class="list ">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <%} %>
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
            
            <div>
            <div class="content" style="align-items: center;">
            <section style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
               <form style="display: flex;" action="<%=request.getContextPath()%>/SearchServlet">
                  <input type="text" id="srh" name="bName" oninput="validate()" class="search-box" placeholder="Search books" required>
                  <input type="image" class="srh-icon" src="icons/search.svg">
               </form>
                <a style="padding-right: 2.8rem;" href="advancedSearch.jsp">Advance Search</a>
            </section>
           
         </div>
               <div class="content">
                   <div class="cards">
                   		<a href="studentDetails.jsp">
	                       <div class="card">
	                           <div class="box">
	                               <h1><%=CommonServices.noOfStudents() %></h1>
	                               <h3>Students</h3>
	                           </div>
	                           <div class="iconcase">
	                               <img src="icons/students.png" style="filter: grayscale(1);">
	                           </div>
	                       </div>
						</a>
						<a href="teacherDetails.jsp">
                       <div class="card">
                           <div class="box">
                               <h1><%=CommonServices.noOfTeachers() %></h1>
                               <h3>Teachers</h3>
                           </div>
                           <div class="iconcase">
                               <img src="icons/teachers.png" style="filter: grayscale(1);">
                           </div>
                       </div>
                       </a>
                       <%if(userType==1){ %>
                       <a href="librarianDetails.jsp">
                       <div class="card">
                           <div class="box">
                           <h1><%=CommonServices.noOfLibrarians() %></h1>
                           <h3>Librarians</h3>
                           </div>
                           <div class="iconcase">
                               <img src="icons/users.png" style="filter: grayscale(1);">
                           </div>
                       </div>
                       </a>
                       
                       <a href="departmentDetails.jsp">
                       <div class="card">
                           <div class="box">
                               <h1><%=CommonServices.noOfDeparments() %></h1>
                               <h3>Departments</h3>
                           </div>
                           <div class="iconcase">
                               <img src="icons/department.png" style="filter: grayscale(1);">
                           </div>
                       </div>
                       </a>
                       <%} %>
                       <a href="bookDetails.jsp">
                       <div class="card">
                           <div class="box">
                               <h1><%=CommonServices.noOfBooks() %></h1>
                               <h3>Books</h3>
                           </div>
                           <div class="iconcase">
                               <img src="icons/books.png" style="filter: grayscale(1);">
                           </div>
                       </div>
                       </a>
                       <a href="publishersDetails.jsp">
                       <div class="card">
                           <div class="box">
                               <h1><%=CommonServices.noOfPublishers() %></h1>
                               <h3>Publishers</h3>
                           </div>
                           <div class="iconcase">
                               <img src="icons/dashboard.png">
                           </div>
                       </div>
                       </a>
                   </div>
                   </div>
                   </div>
                   </div>
                   
                   <%
                   		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.newTeachers,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                   		PreparedStatement psmt3 = con.prepareStatement(QueryInterface.newStudents,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                   		
                   		ResultSet rs2 = psmt2.executeQuery();
                   		ResultSet rs3 = psmt3.executeQuery();
                   		
                   		boolean status=false;
                   %>
                   
                   <div class="content2">
                     <div style="display: flex; gap: 1rem;">
                       <div class="new-table" style="border-radius: 10px;">
                           <div class="title2">
                               <h2>New Teachers</h2>
                               <a href="teacherDetails.jsp" class="btn2">View All</a>
                           </div>
                           <table>
                               <tr style="background: #4d9aff; color: white;">
                                   <th style="border-left: 1px solid #999;">Teacher Id</th>
                                   <th>Name</th>
                                   <th>Department</th>
                                   <th>Phone No.</th>
                                   <th>Status</th>
                               </tr>
                               <%while(rs2.next()){ %>
                               <tr>
                                   <td style="border-left: 1px solid #999;"><%=rs2.getString("tid") %></td>
                                   <td><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></td>
                                   <td><%=rs2.getString("Dept_Name") %></td>
                                   <td><%=rs2.getString("phone") %></td>
                                   <% status = rs2.getBoolean("status");
                                   if(status) {%><td style="color: green; font-weight:600;">Active<%}else{ %><td style="color: red; font-weight:600;">Banned<%} %></td>
                               </tr>
                               <%} %>
                           </table>
                       </div>
                       <div class="new-table" style="border-radius: 10px;">
                           <div class="title2">
                               <h2>New Students</h2>
                               <a href="studentDetails.jsp" class="btn2">View All</a>
                           </div>
                           <table>
                               <tr style="background: #4d9aff; color: white;">
                                   <th style="border-left: 1px solid #999;">Student Id</th>
                                   <th>Name</th>
                                   <th>Department</th>
                                   <th>Phone No.</th>
                                   <th>Status</th>
                               </tr>
                               <%while(rs3.next()){ %>
                               <tr>
                                   <td style="border-left: 1px solid #999;"><%=rs3.getString("sid") %></td>
                                   <td><%=rs3.getString("First_name") %> <%=rs3.getString("Last_name") %></td>
                                   <td><%=rs3.getString("Dept_Name") %></td>
                                   <td><%=rs3.getString("phone") %></td>
                                   <% status = rs3.getBoolean("status");
									if(status) {%><td style="color: green; font-weight:600;">Active<%}else{ %><td style="color: red; font-weight:600;">Banned<%} %></td>
                               </tr>
                               <%} %>
                           </table>
                       </div>
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
      <p><b>Design & Developed by VUDICT Technologies</b></p>
      <!--<p>Copyright | All Rights Reserved</p>-->
   </footer>
</body>
</html>
<%}else{response.sendRedirect("badRequest.jsp");}con.close();}%>