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
                  <li class="list active" style="padding-right: 5.95rem;">
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
                  <li class="list">
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
                <a href="dashboardAdminAndLibrarian.jsp" style="color: black; font-size: 14px; padding-bottom: 0.7rem;"><span class="back"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"> Back to dashboard</span></a>
               
            </div>
                   <div class="content">
                     <div style="display: flex; gap: 1rem;">
                       <%
                       		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.allTeachersDetails,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                       		ResultSet rs2 = psmt2.executeQuery();
                       		
                       		int size = CommonServices.getResultsetSize(rs2);
                       		rs2.beforeFirst();
                       		
                       		ResultSet rs3[]= new ResultSet[size];
                       		int i=0;
                       		while(rs2.next())
                       		{
	                       		PreparedStatement psmt3 = con.prepareStatement(QueryInterface.countAlreadyBorrowedBookQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	                       		psmt3.setString(1, null);
	                       		psmt3.setString(2, rs2.getString("tid"));
	                       		
	                       		rs3[i] = psmt3.executeQuery();
	                       		rs3[i].next();
	                       		i++;
                       		}
                       		
                       		i=0;
                       		rs2.beforeFirst();
                       		
                       		boolean status = false;
                       		
                       %>
                       <div class="newStudets" style="border-radius: 10px; width: -webkit-fill-available;">
                       <div id="status" hidden="hidden"></div>
                           <div class="title2">
                               <h2>Teachers</h2>
                           </div>
                           <form id="form" action="<%=request.getContextPath()%>/UserManagement" method="post">
                           <table class="table" style="width: -webkit-fill-available;">
                               <tr style="position: sticky; top: 70px;">
                                   <th style="border-radius: 7px 0px 0px 7px;">Teacher Id</th>
                                   <th>Name</th>
                                   <th>Department</th>
                                   <th>Phone No.</th>
                                   <th>Borrowed books</th>
                                   <th>Borrow Limit</th>
                                   <th>Status</th>
                                   <th style="border: none; border-radius: 0 7px 7px 0; padding: 1rem 6rem;">Action</th>
                               </tr>
                               <%while(rs2.next()){ %>
                               <tr>
                                   <td><%=rs2.getString("tid") %><input type="checkbox" hidden="hidden" id="<%=size%>" name="tid" value="<%=rs2.getString("tid")%>"></td>
                                   <td><%=rs2.getString("First_name") %> <%=rs2.getString("Last_name") %></td>
                                   <td><%=rs2.getString("Dept_Name") %></td>
                                   <td><%=rs2.getString("Phone") %></td>
                                   <td><%=rs3[i].getString(1) %></td>
                                   <td><%=rs2.getString("borrowLimit") %></td>
                                   <% status = rs2.getBoolean("status");
									if(status) {%>
									<td style="color: green;">Active</td>
									<td style="padding: 0;">
                                    
                                    <input type="checkbox" hidden="hidden" id="b<%=size%>" name="ban" value="ban">
                                    <input type="button" style="background: #d70000;" onclick="submitForm(<%=size%>,b<%=size%>,null,null,null);" class="btn2" value="Ban User">
                                    
                                    <select name="limit-value<%=rs2.getString("tid")%>" id="limit-value" style="border-radius: 7px; padding: 4px 0px;">
                                    	<option id="5<%=size%>" value="5">5</option>
                                    	<option id="6<%=size%>" value="6">6</option>
                                    	<option id="7<%=size%>" value="7">7</option>
                                    </select>
                                    
                                    <input type="checkbox" hidden="hidden" id="l<%=size%>" name="limit" value="limit">
                                    <input type="button" onclick="submitForm(<%=size%>,null,null,l<%=size%>,null);" class="btn2" value="Limit">
                                    
                                    <script>
                                    	document.getElementById("5<%=size%>").removeAttribute("selected");
                                    	document.getElementById("<%=rs2.getString("borrowLimit")%><%=size%>").setAttribute("selected","");
                                    </script>
									<%}else{ %>
									<td style="color: red;">Banned</td>
                                    <td style="padding: 0;">
                                    
                                    <input type="checkbox" hidden="hidden" id="a<%=size%>" name="Activate" value="Activate">
                                    <input type="button" style="background: green;" onclick="submitForm(<%=size%>,null,a<%=size%>,null,null);" class="btn2" value="Activate">
                                    <%} %>
                                    
                                    <input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete">
                                    <input type="button" onclick="submitForm(<%=size%>,null,null,null,d<%=size%>);" class="btn2" value="Delete">
                                    </td>
                               </tr>
                               <%i++;size--; } %>
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
      <script src="js/userDetailsScript.js"></script>
<script>

let scroll2 = sessionStorage.getItem("scroll");

if(scroll2!=null)
{
	window.scrollTo(0, scroll2);
	console.log("scroll2 = "+scroll2);

	sessionStorage.clear();
}

function submitForm(id,ban,activate,limit,del)
{	
	
	let scroll = document.body.scrollTop;
	sessionStorage.setItem("scroll", scroll);

	console.log("scroll = "+scroll);
	
	var uncheck = document.getElementsByName('sid');
	var uncheckBan = document.getElementsByName('ban');
	var uncheckActivate = document.getElementsByName('Activate');
	var uncheckDelete = document.getElementsByName('delete');
	var uncheckLimit = document.getElementsByName('limit');
	
    for(var i=0;i<uncheck.length;i++)
    {
        if(uncheck[i].type=='checkbox')
        {
            uncheck[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckBan.length;i++)
    {
        if(uncheckBan[i].type=='checkbox')
        {
        	uncheckBan[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckActivate.length;i++)
    {
        if(uncheckActivate[i].type=='checkbox')
        {
        	uncheckActivate[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckDelete.length;i++)
    {
        if(uncheckDelete[i].type=='checkbox')
        {
        	uncheckDelete[i].checked=false;
        }
    }
    
    for(var i=0;i<uncheckLimit.length;i++)
    {
        if(uncheckLimit[i].type=='checkbox')
        {
        	uncheckLimit[i].checked=false;
        }
    }
	
	console.log(id);
	console.log(del);
	console.log(ban);
	console.log(activate);
	console.log(limit);
	
	document.getElementById(id).checked = true;
	if(ban!=null)
		ban.checked = true;
	
	if(del!=null){
		if(confirm("Are you want to delete this book ?"))
			del.checked = true;
		else
			exit(0);
	}
	
	if(activate!=null)
		activate.checked = true;
	
	if(limit!=null)
		limit.checked = true;
	
	console.log("checked");
	document.getElementById("form").submit();
}
</script>
</body>
</html>
<%}else{response.sendRedirect("badRequest.jsp");}con.close();}%>