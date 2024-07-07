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
			session.setAttribute("fromBookDetails", "1");
			
%>
<html>
<head>
   <link rel="stylesheet" href="css/userDetailStyle.css">
   <link rel="icon" type="image/icon" href="icons/favicon.ico">
   <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
   <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
   <title>User Details</title>
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

      <div class="container">
            <div class="navigation">
               <ul style="display: grid; padding-top: 40px;">
                  <li class="list">
                     <a href="studentDetails.jsp">
                        <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                        <span class="title">Students</span>
                     </a>
                  </li>
                 
                  <li class="list">
                     <a href="teacherDetails.jsp">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">Teachers</span>
                     </a>
                  </li>
                  <%if(userType==1){ %>
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
                  <li class="list active" style="padding-right: 7.2rem;">
                     <a href="bookDetails.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Books</span>
                     </a>
                  </li>
                  <li class="list">
                     <a href="publishersDetails.jsp">
                        <span class="icon"><ion-icon name="bookmarks-outline"></ion-icon></span>
                        <span class="title">Publishers</span>
                     </a>
                  </li>
               </ul>   
            </div>
            
            <div style="width: -webkit-fill-available;">
            <div style="display: flex; align-items: center;">
                <a href="dashboardAdminAndLibrarian.jsp" style="color: black; font-size: 14px; padding-bottom: 0.7rem;">
                	<span class="back"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"> Back to dashboard</span>
                </a>
               <div id="status-div" style="content-visibility: hidden;">
            		<span id="status"></span>
            </div>
            </div>
                   <div class="content">
                     <div style="display: flex; gap: 1rem;">
                       <%
                       		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.allBooksDetails,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                       		ResultSet rs2 = psmt2.executeQuery();
                       		
                       		int size = CommonServices.getResultsetSize(rs2);
                       		rs2.beforeFirst();
                       		
                       %>
                       <div class="newStudets" style="border-radius: 10px; width: -webkit-fill-available;">
                           <div class="title2">
                               <h2>Books</h2>
                           </div>
                           <form id="form" style="width: -webkit-fill-available;" action="<%=request.getContextPath()%>/EditOrDelete">
                           <table class="table" style="width: -webkit-fill-available;">
                               <tr style="position: sticky; top: 70px;">
                                   <th style="border-radius: 7px 0px 0px 7px;">Book Id</th>
                                   <th>Name</th>
                                   <th>Author</th>
                                   <th>Edition</th>
                                   <th>Department</th>
                                   <th>Year Of Publishing</th>
                                   <th>Publisher</th>
                                   <th style="border: none; border-radius: 0 7px 7px 0; padding: 1rem 6rem;">Action</th>
                               </tr>
                               <%while(rs2.next()){ %>
                               <tr>
                                   <td><%=rs2.getString("bid") %><input type="checkbox" hidden="hidden" id="<%=size%>" name="book" value="<%=rs2.getString("bid")%>"></td>
                                   <td><%=rs2.getString("bookName") %></td>
                                   <td><%=rs2.getString("author") %></td>
                                   <td><%=rs2.getString("edition") %></td>
                                   <td><%=rs2.getString("Dept_Name") %></td>
                                   <td><%=rs2.getString("yearOfPublishing") %></td>
                                   <td><%=rs2.getString("pName") %></td>
                                   <td style="padding: 0;">
                                    <a href=<%=rs2.getString("bookPath")%>><input type="button" class="btn2-n" value="Open"></a>
                                    <input type="checkbox" hidden="hidden" id="e<%=size%>" name="edit" value="edit"><input type="button" onclick="submitForm(<%=size%>,e<%=size%>,null);" class="btn2-n" value="Edit"> 
                                    <input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete"><input type="button" onclick="submitForm(<%=size%>,null,d<%=size%>);" class="btn2-n" value="Delete">
                                   </td>
                               </tr>
                               <%size--;} %>
                           </table>
                           </form>
                       </div>
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
   <script>
   function submitForm(id,e,d)
   {
   	var uncheck = document.getElementsByName('book');
   	var uncheckEdit = document.getElementsByName('edit');
   	var uncheckDelete = document.getElementsByName('delete');
   	
       for(var i=0;i<uncheck.length;i++)
       {
           if(uncheck[i].type=='checkbox')
           {
               uncheck[i].checked=false;
           }
       }
       
       for(var i=0;i<uncheckEdit.length;i++)
       {
           if(uncheckEdit[i].type=='checkbox')
           {
           	uncheckEdit[i].checked=false;
           }
       }
       
       for(var i=0;i<uncheckDelete.length;i++)
       {
           if(uncheckDelete[i].type=='checkbox')
           {
           	uncheckDelete[i].checked=false;
           }
       }
   	
   	console.log(id);
   	console.log(e);
   	console.log(d);
   	document.getElementById(id).checked = true;
   	if(e!=null)
   		e.checked = true;
   	if(d!=null){
   		if(confirm("Are you want to delete this book ?"))
   			d.checked = true;
   		else
   			exit(0);
   	}
   	console.log("checked");
   	document.getElementById("form").submit();
   }
   
   
   
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
   	document.getElementById("status").innerHTML="Book Deleted";
   	document.getElementById("status-div").style.contentVisibility="visible";
   	document.getElementById("status-div").style.paddingBottom = "3rem";
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
   </script>
</body>
</html>
<%}else{response.sendRedirect("badRequest.jsp");}con.close();}%>