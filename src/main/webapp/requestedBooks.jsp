<%@page import="com.myApp.LibraryManagement.services.DashboardServices"%>
<%@page import="com.myApp.LibraryManagement.services.RequestBookServices"%>
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
	if(userType==1 || userType==3)
	{
		ResultSet rs5 = DashboardServices.notifyBookRequest();
	    if(rs5.next()){
	    	DashboardServices.notifyDone(rs5.getString(1),userType); //Notification Done  
	    }
	}
	Connection con = DbImplementation.dbConnect();
	PreparedStatement psmt2=null;
	ResultSet rs2 = null, rs = null, rs3 = null,rs4 = null;
	if(userType!=1)
	{
		if(userType==2)
			psmt2 = con.prepareStatement(QueryInterface.getTeacherDetails);
		else if(userType==4)
			psmt2 = con.prepareStatement(QueryInterface.getStudentsDetails);
		else if(userType==3)
			psmt2 = con.prepareStatement(QueryInterface.getLibrarianDetails);
		
		psmt2.setString(1, sessionEmail);
		
		rs2 = psmt2.executeQuery();
		rs2.next();		
	}
%>

<html>
<head>
   <link rel="stylesheet" href="css/dashboardStyle.css">
   <link rel="icon" type="image/icon" href="icons/favicon.ico">
   <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
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
	
	.material-symbols-outlined {
		cursor: pointer;
		user-select: none;
	  font-variation-settings:
	  'FILL' 0,
	  'wght' 400,
	  'GRAD' 0,
	  'opsz' 48
	}
	
	.material-symbols-outlined:hover {
	  font-variation-settings:
	  'FILL' 0
	  }
	  
	  .material-symbols-outlined:active {
	  font-variation-settings:
	  'FILL' 1,
	  'wght' 400,
	  'GRAD' 0,
	  'opsz' 48
	  }
	  
	  .th2{
	  background-color: rgb(0 140 255);
	  }

   </style>
   
</head>

<body>
   <div class="wrapper">
   <%if(userType!=1){if(!rs2.getBoolean("status")){ %>
	   <div class="banned" id="status">
	        Services are disabled because your account is deactivated. <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">Contact librarian/admin.</a>
	   </div>
   <%}} %>
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
         <span><img src="icons/person-circle.png" alt="person" style="transform: scale(0.6);"></span>Welcome <%if(userType==1){ %>Admin<%}
         	else{%><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %><%} %></span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset;" class="btn">Sign out</span></a>
      </div>

      <div class="container" style="gap: 2rem;">
      <div>
            <div class="Navigation">
               <ul>
                  <li class="list">
                     <%if(userType!=1 && userType!=3){ %><a href="dashboard.jsp"><%}else{ %><a href="dashboardAdminAndLibrarian.jsp"><%} %>
                        <span class="icon"><ion-icon name="albums-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                     </a>
                  </li>
                  <%if(userType!=1){ %>
                  <li class="list ">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <%} %> 
                  <%if(userType==1) {%>
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
                  <%} %>
                  <%if(userType==1 || userType==3) {%>
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
                                    
                  <li class="list active" style="padding-right: 0; ">
                  	 <a href="requestedBooks.jsp" style="padding-right: 4.35rem; width: max-content; ">
                        <span class="icon"><ion-icon name="file-tray-full-outline"></ion-icon></span>
                        <span class="title">Requested Books</span>
                     </a>
                  </li>
                  <%} %>
                  
                                   
                  <li class="list">
                     <a href="changePassword.jsp">
                        <span class="icon"><ion-icon name="key-outline"></ion-icon></span>
                        <span class="title">Change Password</span>
                     </a>
                  </li>
                  <%if(userType!=1 && userType!=3){ %>
                  <li class="list active" style="padding-right: 0; padding: 4px 0 4px 4px;">
                     <a href="requestBook.jsp" style="padding-right: 5rem; width: max-content;">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Request Books</span>
                     </a>
                     <a href="requestedBooks.jsp" style="border-radius: 17px 0px 0 17px; background: #006eff57;">
                        <span class="icon"><ion-icon name="file-tray-full-outline"></ion-icon></span>
                        <span class="title">Requested Books</span>
                     </a>
                  </li>
                  
                  <% rs = RequestBookServices.requestedBooks(sessionEmail);
                  }
                  else
                  {
                	  rs = RequestBookServices.requestedBooks();                	  
                  }
                  %>
               </ul>
            </div>
		</div>
           
        <div style="margin-top: 3rem; width: -webkit-fill-available;"> 
         <div class="info">
			<div> <span class="logo">Requested Books : </span></div>
				<form id="form" action="<%=request.getContextPath()%>/ManageRequest" method="post">
				<table class="table" style="width: -webkit-fill-available;">
                  <tr>
                     <th style="border-radius: 7px 0px 0px 7px;">ID</th>
                     <th>Book Name</th>
                     <th>Author</th>
                     <th style="width: 14%;">Edition</th>
                     <th>Publisher</th>
                     <th style="border: none; border-radius: 0 7px 7px 0;">Action</th>                     
                  </tr>
                  
                  <%if(rs.next()){rs.beforeFirst();while(rs.next()){ %>
                  <tr>
                     <td><%=rs.getString("rid") %><input type="checkbox" hidden="hidden" id="b<%=rs.getString("rid")%>" name="record" value="<%=rs.getString("rid")%>"></td>
                     <td><%=rs.getString("book_name") %></td>
                     <td><%=rs.getString("author") %></td>
                     <td style="width: 9%;"><%=rs.getString("edition") %></td>
                     <td><%=rs.getString("publisher") %></td>
                     <td style="display: flex; align-items: center; justify-content: space-around; border: none;">
	                     <%if(userType!=1 && userType!=3){ %>
	                     <input type="checkbox" hidden="hidden" id="d<%=rs.getString("rid")%>" name="delete" value="1">
	                     <input type="button" onclick="submitManageForm(b<%=rs.getString("rid")%>,null,d<%=rs.getString("rid")%>);" class="btn" style="position: unset;" value="Cancel Request">
	                     <%}else{ %>
	                     <input type="checkbox" hidden="hidden" id="a<%=rs.getString("rid")%>" name="add" value="add">
	                     <input type="button" onclick="submitManageForm(b<%=rs.getString("rid")%>,a<%=rs.getString("rid")%>,null);" class="btn" style="position: unset;" value="Add Book">
	                     
	                     <input type="checkbox" hidden="hidden" id="d<%=rs.getString("rid")%>" name="delete" value="0">
	                     <input type="button" onclick="submitManageForm(b<%=rs.getString("rid")%>,null,d<%=rs.getString("rid")%>);" class="btn" style="position: unset;" value="Reject Request">
	                     <div id="arrow<%=rs.getString("rid")%>">
	                     	<span class="material-symbols-outlined" onclick="drop(drop<%=rs.getString("rid")%>,drop2<%=rs.getString("rid")%>,arrow<%=rs.getString("rid")%>);">arrow_drop_down_circle</span>
	                     </div>
	                     
	                     <%
	                     rs3 = RequestBookServices.studentRequests(rs.getString("rid"));
	                     rs4 = RequestBookServices.teacherRequests(rs.getString("rid"));
	                     
	                     System.out.println("\n\n rs3 ="+rs3+"\n rs4 = "+rs4);
	                     %>
                     </td>                     
                  </tr>
                  <tr id="drop<%=rs.getString("rid")%>" hidden="hidden">
                  <%if(rs3.next()){ rs3.beforeFirst(); int i=0;%>
                  	 <td colspan="6" style="border: none;"><span style="font-size: 20px; font-weight: 600;"> Students who have requested this book </span>
                  	 	<table class="table" style="width: -webkit-fill-available;">
                  	 		<tr>
                  	 			<th class="th2" style="border-radius: 7px 0px 0px 7px;">#</th>
                  	 			<th class="th2">Student Id</th>
                  	 			<th class="th2">Name</th>
                  	 			<th class="th2">Roll No.</th>
                  	 			<th class="th2">Phone</th>
                  	 			<th class="th2">Status</th>
                  	 			<th class="th2" style="border: none; border-radius: 0 7px 7px 0;">Department</th>
                  	 		</tr>
                  	 		<%while(rs3.next()){i++; %>
                  	 		<tr>
                  	 			<td><%=i %></td>
                  	 			<td><%=rs3.getString("sid") %></td>
                  	 			<td><%=rs3.getString("First_name") %> <%=rs3.getString("Last_name") %></td>
                  	 			<td><%=rs3.getString("Roll_no") %></td>
                  	 			<td><%=rs3.getString("Phone") %></td>
                  	 			<td><%if(CommonServices.isUserActive(CommonServices.getStudentEmail(rs3.getString("sid")))){ %>Active<%}else{ %>Banned<%} %></td>
                  	 			<td><%=rs3.getString("Dept_Name") %></td>
                  	 		</tr>
                  	 		<%} %>
                  	 	</table>
                  	 </td>
                  	 <%} %>
                  	 </tr>
                  	 <tr id="drop2<%=rs.getString("rid")%>" hidden="hidden">
                  	 <%if(rs4.next()){ rs4.beforeFirst();int i=0; %>
                  	 <td colspan="6" style="border: none;"><span style="font-size: 20px; font-weight: 600;"> Teachers who have requested this book </span>
                  	 	<table class="table" style="width: -webkit-fill-available;">
                  	 		<tr>
                  	 			<th class="th2" style="border-radius: 7px 0px 0px 7px;">#</th>
                  	 			<th class="th2">Teacher Id</th>
                  	 			<th class="th2">Name</th>
                  	 			<th class="th2">Phone</th>
                  	 			<th class="th2">Status</th>
                  	 			<th class="th2" style="border: none; border-radius: 0 7px 7px 0;">Department</th>
                  	 		</tr>
                  	 		<%while(rs4.next()){i++; %>
                  	 		<tr>
                  	 			<td><%=i %></td>
                  	 			<td><%=rs4.getString("tid") %></td>
                  	 			<td><%=rs4.getString("First_name") %> <%=rs4.getString("Last_name") %></td>
                  	 			<td><%=rs4.getString("Phone") %></td>
                  	 			<td><%if(CommonServices.isUserActive(CommonServices.getTeacherEmail(rs3.getString("tid")))){ %>Active<%}else{ %>Banned<%} %></td>
                  	 			<td><%=rs4.getString("Dept_Name") %></td>
                  	 		</tr>
                  	 		<%} %>
                  	 	</table>
                  	 </td>
                  	 <%} }%>
                  </tr>
                  <%}}else{
                	  if(userType!=1 && userType!=3){      	%>
                  <tr>
                     <td colspan="6" style="border: none;">You haven't requested any books</td>
                   </tr>
                   <%}else{%>
               	   <tr>
                     <td colspan="6" style="border: none;">No requested books right now</td>
                   </tr>
                   <%} }%>
               </table>	  
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
	<script>
	
	if(statusCheck==43)
	{
		console.log("status 43");
		document.getElementById("status").innerHTML='Request Deleted Successfully';
		document.getElementById("status-div").style.contentVisibility="visible";
		document.getElementById("status").style.background="#009300";
	}
	
	if(statusCheck==44)
	{
		console.log("status 44");
		document.getElementById("status").innerHTML='Something went wrong';
		document.getElementById("status-div").style.contentVisibility="visible";
	}
	
	function drop(id,id2,icon)
	{
		id.removeAttribute("hidden");
		id2.removeAttribute("hidden");
		icon.style.transform="rotate(180deg)";
		icon.innerHTML='<span class="material-symbols-outlined" onclick="hide('+id.id+','+id2.id+','+icon.id+');">arrow_drop_down_circle</span>';
	}
	
	function hide(id,id2,icon)
	{
		id.setAttribute("hidden","hidden");
		id2.setAttribute("hidden","hidden");
		icon.style.transform="rotate(0deg)";
		icon.innerHTML='<span class="material-symbols-outlined" onclick="drop('+id.id+','+id2.id+','+icon.id+');">arrow_drop_down_circle</span>';
	}
	
	function submitManageForm(rid,add,del)
	{
		var uncheck=document.getElementsByName('record');
		var uncheckAdd=document.getElementsByName('add');
		var uncheckDelete=document.getElementsByName('delete');
		
        for(var i=0;i<uncheck.length;i++)
        {
           if(uncheck[i].type=='checkbox')
           {
               uncheck[i].checked=false;
           }
        }
        
        for(var i=0;i<uncheckAdd.length;i++)
        {
           if(uncheckAdd[i].type=='checkbox')
           {
        	   uncheckAdd[i].checked=false;
           }
        }
        
        for(var i=0;i<uncheckDelete.length;i++)
        {
           if(uncheckDelete[i].type=='checkbox')
           {
        	   uncheckDelete[i].checked=false;
           }
        }
        
        rid.checked = true;
       
       if(add!=null)
    	   add.checked = true;
       
       else if(del!=null)
       {
    	   if(confirm("Are you sure you want to cancel this book request ?"))
    		   del.checked = true;
	   		else
	   		exit(0);
    	}
    	   
       
       document.getElementById("form").submit();
	}
	</script>
</body>
</html>
<% con.close();}%>