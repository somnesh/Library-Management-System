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
else{
	
	session.setAttribute("dashboard", "1"); //for borrowBook servlet 
	
	int userType = CommonServices.UserType(sessionEmail); // admin = 1; teacher = 2; librarian = 3; student = 4
	
	String sidOrTid=null,id;
	
	System.out.println("user type jsp : "+userType);
	
	Connection con = DbImplementation.dbConnect();
	
	PreparedStatement psmt2=null;
	if(userType==2)
	{
		sidOrTid="tid";
		id = CommonServices.getTeacherId(sessionEmail);
		psmt2 = con.prepareStatement(QueryInterface.getTeacherDetails);
	}
	else
	{
		sidOrTid ="sid";
		id = CommonServices.getStudentId(sessionEmail);
		psmt2 = con.prepareStatement(QueryInterface.getStudentsDetails);
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

      <div class="container">
      <div>
            <div class="Navigation">
               <ul>
                  <li class="list active">
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
                  <li class="list">
                     <a href="requestBook.jsp">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Request Books</span>
                     </a>
                  </li>
               </ul>
            </div>
            </div>
            
            <%
            	
            	PreparedStatement psmt = con.prepareStatement(QueryInterface.getAlreadyBorrowedBookInfo(sidOrTid, id),ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            	ResultSet rs = psmt.executeQuery();
            	
            %>
            
            <div style="width: -webkit-fill-available;" <%if(!rs.next()){ %> style="width: 125%;"<%}else{rs.beforeFirst();} %>>
            <div class="content">
            <section>
               <form style="display: flex;" action="<%=request.getContextPath()%>/SearchServlet">
                  <input type="text" id="srh" name="bName" oninput="validate()" class="search-box" placeholder="Search books" required>
                  <input type="image" class="srh-icon" src="icons/search.svg">
               </form>
            </section>
            <a style="padding-right: 2.8rem;" href="advancedSearch.jsp">Advance Search</a>
         </div>
         <div>
            
            
            <div style="display: grid; gap: 3rem;">
            <section>
               <b>Your Borrowed History</b>
               <form id="form" action="<%=request.getContextPath()%>/ReturnBook">
               <table class="table" style="width: -webkit-fill-available;">
                  <tr>
                     <th style="border-radius: 7px 0px 0px 7px;">Book Name</th>
                     <th>Author</th>
                     <th style="width: 15%;">Publising Year</th>
                     <th>Edition</th>
                     <th style="width: 16%;">Date of return</th>
                     <th style="border: none; border-radius: 0 7px 7px 0;">Action</th>
                  </tr>
                  
                  <%if(rs.next()){rs.beforeFirst();while(rs.next()){ %>
                  <tr>
                     <td><%=rs.getString("bookName") %></td>
                     <td><%=rs.getString("author") %></td>
                     <td><%=rs.getString("yearOfPublishing") %></td>
                     <td style="width: 9%;"><%=rs.getString("edition") %></td>
                     <td><%=rs.getString("Date_of_return") %></td>
                     <td style="border: none; width: 21%;">
                     <a style="position: unset; padding: 9px 20px 10px 20px;" class="btn" href=<%=rs.getString("bookPath")%>>Open</a>
                     <input type="checkbox" hidden="hidden" id="<%=rs.getString("recordId")%>" name="record" value="<%=rs.getString("recordId")%>">
                     <a style="position: unset; padding: 9px 20px 10px 20px;" class="btn" onclick="submitForm(<%=rs.getString("recordId")%>)">Return</a></td>
                  </tr>
                  <%}}else{ %>
                  <tr>
                     <td colspan="6" style="border: none;">You haven't borrowed any book</td>
                   </tr>
                   <%} %>
               </table>
				</form>
				</section>
				<section>
               <b>Suggested Books for You</b>
               <form id="borrowForm" style="width: -webkit-fill-available;" action="<%=request.getContextPath()%>/BorrowBook">
               <table class = "table" style="width: -webkit-fill-available;">
                  <tr>
                     <th style="border-radius: 7px 0px 0px 7px;">Book Name</th>
                     <th>Author</th>
                     <th style="width: 17%;">Publising Year</th>
                     <th>Edition</th>
                     <th style="border: none; border-radius: 0 7px 7px 0;">Action</th>
                  </tr>
                  <%
                  	PreparedStatement psmt3 = con.prepareStatement(QueryInterface.recommendBook, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                  	psmt3.setString(1, rs2.getString("Dept_Id"));
                  	
                  	if(userType==4) //student
                  	{	
                  		psmt3.setString(2, CommonServices.getStudentId(sessionEmail));
                  		psmt3.setString(3, null);
                  	}
                  	
                  	if(userType==2) //teacher
                  	{	
                  		psmt3.setString(2, null);
                  		psmt3.setString(3, CommonServices.getTeacherId(sessionEmail));
                  	}
                  	
                  	ResultSet rs3 = psmt3.executeQuery();
                  	
                  	boolean status = CommonServices.isUserActive(sessionEmail);
                  	if(status && rs3.next())
                  	{ rs3.beforeFirst();
                  		while(rs3.next())
                  		{
                  %>
                  
                  <tr>
                     <td><%=rs3.getString("bookName") %><input type="checkbox" hidden="hidden" id="b<%=rs3.getString("bid")%>" name="book" value="<%=rs3.getString("bid")%>"></td>
                     <td><%=rs3.getString("author") %></td>
                     <td><%=rs3.getString("yearOfPublishing") %></td>
                     <td><%=rs3.getString("edition") %></td>
                     <td style="border: none;"><input type="button" onclick="submitBorrowForm(b<%=rs3.getString("bid")%>);" class="btn" style="position: unset;" value="Borrow"></td>
                  </tr>
                 
                  <%}}else if(!status){%>
                	  <tr style="display: flex;width: 181%;justify-content: center;">
                      <td style="border: none; color: red;">No recommendation available because your account is deactivated</td>
                    </tr>
                  	
                  	<% }else{ %>
                  <tr>
                     <td colspan="6" style="border: none;">No recommendation available right now</td>
                   </tr>
                   <%} %>
               </table>
                </form>
               </section>
            </div>
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
	<script src="js/dashboardScript.js"></script>
</body>
</html>
<%con.close(); }%>