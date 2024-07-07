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
else{

	int userType = CommonServices.UserType(sessionEmail); // admin = 1; teacher = 2; librarian = 3; student = 4

	System.out.println("user type jsp : "+userType);
	Connection con = DbImplementation.dbConnect();	
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
    <title>Change Password</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
    <style>
    	.showPass
    	{
    		display: flex;
		    align-items: center;
		    padding-bottom: 2rem;
		    gap: 7px;
		    font-family: system-ui;
    	}
    </style>
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
         	%> <%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %><%} %>
         </span>
         <a id="logout" href="<%=request.getContextPath()%>/LogoutServlet"><span style="position: unset; padding: 13px 22px 14px 21px; font-size: 13px; box-shadow: rgb(0 0 0 / 35%) 0px 0px 7px;" class="btn">Sign out</span></a>
      </div> 
    <div class="wrapper">
        <div class="content" style="gap: 20rem;">
            <div>
                <div class="navigation">
                    <ul style="padding-left: 5px;">
                    
                  <li class="list">
                     <a href=<%if(userType==1 || userType==3){ %>"dashboardAdminAndLibrarian.jsp"<%}else{ %>"dashboard.jsp"<%} %>>
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
                  
                  <%
                  if(userType==1 || userType==3){
                  	if(userType==1){ %>
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
                  <li class="list active" style="padding-right: 4.55rem;">
                     <a href="changePassword.jsp">
                        <span class="icon"><ion-icon name="key-outline"></ion-icon></span>
                        <span class="title">Change Password</span>
                     </a>
                  </li>
                  <%}else{ %>
                  <li class="list ">
                     <a href="profile.jsp">
                        <span class="icon"><ion-icon name="person-circle-outline"></ion-icon></span>
                        <span class="title">Profile</span>
                     </a>
                  </li>
                  <li class="list active" style="padding-right: 4rem;">
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
                  <%} %>
               </ul>  
                 </div>
                </div>

             <div style="margin-top: 3rem; margin-bottom: 3rem;">

             
        	<div style="display: flex; padding-bottom: 1rem; gap: 13rem; align-items: center; justify-content: center;">
			<span class="heading" style="padding-bottom: 2rem;">Change Password</span>
			</div>
			<div id="status-div" style="content-visibility: hidden;">
            	<span id="status"></span>
            </div>
            <form action="<%=request.getContextPath()%>/ChangePassServlet" method="post">
            <div class="i-fields">
                    <span class="lebel-box">Old Password</span>
                    <input type="password" id="oldPass" class="box" style="margin-bottom: 35px;" name="oldPass" placeholder="Enter old password" required>
                </div>
                <div class="i-fields">
                    <span class="lebel-box">New Password</span>
                    <input type="password" id="newPass" class="box" style="margin-bottom: 35px;" oninput="check()" name="newPass" placeholder="Create a new password" required>
                </div>
                <div class="i-fields" style="display: grid;">
                    <span class="lebel-box">Confirm Password</span>
                    <input type="password" id="confirmPass" class="box" style="margin-bottom: 4px;" oninput="check()" placeholder="Confirm password" required>
                    <span id="message" style="position: unset; margin-bottom: 1rem;"></span>
                </div>
                
                <div class="showPass">
                	<input type="checkbox" onclick="showpass()" id="showPass" name="showPass" style="height: 18px; width: 18px;">
                	<label for="showPass">Show Password</label>
                </div>
            	<button id="submit" type="submit" onmousemove="check()" class="btn">Change password</button>
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
        
    <script>
	    function getCookie(cName) {
	    	console.log("jeje");
	    	  const name = cName + "=";
	    	  const cDecoded = decodeURIComponent(document.cookie);
	    	  const cArr = cDecoded.split('; ');
	    	  let res;
	    	  cArr.forEach(val => {
	    	    if (val.indexOf(name) === 0) res = val.substring(name.length);
	    	  })
	    	  return res;
	    	}
	    	
	    	
	    let statusCheck = getCookie("status");
	
	    if(statusCheck==1)
	    {
	    	console.log("status 1");
	    	document.getElementById("status").innerHTML="Password Changed";
	    	document.getElementById("status-div").style.contentVisibility="visible";
	    	document.getElementById("status-div").style.paddingBottom = "3rem";
	    }
	
	    if(statusCheck==2)
	    {
			let oldPass = getCookie("oldPass");
	    	
	    	document.getElementById("status").innerHTML="Invalid old Password";
	    	document.getElementById("status").style.border="2px solid red";
	    	document.getElementById("status").style.color="red";
	    	document.getElementById("status-div").style.contentVisibility="visible";
	    	document.getElementById("status-div").style.paddingBottom = "3rem";
	    	
	    	document.getElementById("oldPass").style.outline="red solid 1px";
	        document.getElementById("oldPass").style.border="1px solid red";
	        document.getElementById("oldPass").value=oldPass;
	    }
	    
	    if(statusCheck==0)
	    {
	    	console.log("status 0");
	    	document.getElementById("status").innerHTML="Something went wrong";
	    	document.getElementById("status").style.border="2px solid red";
	    	document.getElementById("status").style.color="red";
	    	document.getElementById("status-div").style.contentVisibility="visible";
	    	document.getElementById("status-div").style.paddingBottom = "3rem";  	
	    }	
    
    	function showpass()
    	{
    		let n = document.getElementById("showPass").checked;
    		let oldPass = document.getElementById("oldPass");
    		let newPass = document.getElementById("newPass");
    		let confirmPass = document.getElementById("confirmPass");
        	if(n)
        	{
        		oldPass.setAttribute("type", "text");
        		newPass.setAttribute("type", "text");
        		confirmPass.setAttribute("type", "text");
        	}
        	else
        	{
        		oldPass.setAttribute("type", "password");
        		newPass.setAttribute("type", "password");
        		confirmPass.setAttribute("type", "password");
        	}
    	}
    	
    	
    	function check()
    	{
    		console.log("in check");
    	    let pass1=document.getElementById("newPass").value;
    	    let pass2=document.getElementById("confirmPass").value;
    	    let sub=document.getElementById('submit');
    	    if (pass1!=pass2) 
    	    {
    	        document.getElementById("message").innerHTML="Those passwords didn't match. Try again.";
    	        sub.setAttribute("disabled","disabled");
    	        document.getElementById("confirmPass").style.outline="red solid 1px";
    	        document.getElementById("confirmPass").style.border="1px solid red";
    	        document.getElementById("newPass").style.outline="red solid 1px";
    	        document.getElementById("newPass").style.border="1px solid red";
    	    }
    	    else{
    	        document.getElementById("message").innerHTML="";
    	        sub.removeAttribute("disabled","disabled");
    	        document.getElementById("confirmPass").style.removeProperty("outline");
    	        document.getElementById("confirmPass").style.removeProperty("border");
    	        document.getElementById("newPass").style.removeProperty("outline");
    	        document.getElementById("newPass").style.removeProperty("border");
    	    }
    	}
    </script>
</body>
</html>
<%con.close();}%>