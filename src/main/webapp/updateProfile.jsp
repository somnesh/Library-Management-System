<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
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

	ResultSet rs = CommonServices.getDepartmentNames();
%>
<html lang="en">
<head>
	
	<link rel="stylesheet" href="css/registerStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile Details</title>
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
    <div class="wrapper" style="justify-content: center;">
    
        <div class="content" style="display: block; margin-top: 2rem;">
            <div style="display: flex; padding-bottom: 3rem; gap: 15rem; align-items: center;">
               <span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
                <span class="heading">Update Profile Details</span>
            </div>
            <div id="status-div" style="content-visibility: hidden;">
            		<span id="status"></span>
            </div>
            <form action="<%=request.getContextPath()%>/UpdateProfile" method="post">
                <div class="container">
                    <div class="columns">
                        <div class="first-col">
                            <span class="lebel-box">First Name</span>
                            <input type="text" class="box" id="firstName" name="firstName" placeholder="Enter your first name" value="<%=rs2.getString("First_name")%>" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Email</span>
                            <input type="text" class="box" id="email" name="email" placeholder="Enter your email address" value="<%=rs2.getString("Email")%>" disabled="disabled" required>
                        </div>
                        <%if(userType == 4){ %>
                        <div class="first-col">
                            <span class="lebel-box">Roll No.</span>
                            <input type="text" class="box" id="roll" name="roll" placeholder="Enter your roll number" value="<%=rs2.getString("Roll_no")%>" disabled="disabled" required>
                        </div>
                        <%} %>
                        <%if(userType!=3){ %>
                        <div class="first-col">
                            <span class="lebel-box">Department</span>
                            <select class="box" style="width: 20.6rem;" id="department" name="department" disabled="disabled" required>
                                <option value="" disabled selected hidden>Select your department</option>
                                <%while(rs.next()){ %>
                                <option id="<%=rs.getString("dept_name")%>" value="<%=rs.getString("dept_name")%>"><%=rs.getString("dept_name")%></option>
                                <%} %>
                              </select>
                        </div>
                        <%} %>
                        <div class="first-col">
                            <span class="lebel-box">Village</span>
                            <input type="text" class="box" id="village" name="village" placeholder="Enter your village name" value="<%=rs2.getString("village")%>" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Post Office</span>
                            <input type="text" class="box" id="post" name="post" placeholder="Enter your post offce name" value="<%=rs2.getString("post")%>" required>
                        </div>
                        
                    </div>
                    <div class="columns">
                        <div class="second-col">
                            <span class="lebel-box">Last Name</span>
                            <input type="text" class="box" id="lastName" name="lastName" placeholder="Enter your last name" value="<%=rs2.getString("Last_name")%>" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Phone Number</span>
                            <input type="tel" class="box" id="phone" name="phone" placeholder="Enter your phone number" value="<%=rs2.getString("phone")%>" required>
                        </div>
                        <%if(userType == 4){ %>
                        <div class="second-col">
                            <span class="lebel-box">Registration No.</span>
                            <input type="text" class="box" id="reg" name="reg" placeholder="Enter your registration number" value="<%=rs2.getString("Reg_no")%>" disabled="disabled" required>
                        </div>
                        <%} %>
                        <div class="second-col">
                            <span class="lebel-box">Date of Birth</span>
                            <input type="date" class="box" id="dob" name="dob" value="<%=rs2.getString("Dob")%>" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">District</span>
                            <input type="text" class="box" id="district" name="district" placeholder="Enter your district" value="<%=rs2.getString("district")%>" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Pin Code</span>
                            <input type="number" class="box" id="pin" name="pin" placeholder="Enter your pin code" value="<%=rs2.getString("pin")%>" required>
                        </div>
                        
                    </div>
                </div>
            
            <div style="padding-bottom: 1rem;">
                <button id="submit" type="submit" class="btn">Update Profile</button>
            </div>
        </form>
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
        <script src="js/updateProfileScript.js"></script>
</body>
</html>    
<%con.close();}%>