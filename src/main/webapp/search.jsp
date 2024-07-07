<%@page import="com.myApp.LibraryManagement.services.BorrowBookServices"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.IOException"%>
<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="com.myApp.LibraryManagement.services.SearchServices"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.util.Objects" %>
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
		
		System.out.println("user type jsp : "+userType);
		
		String name = null;
		
		System.out.println("in jsp");
		//retriving cookie content for book name
		name = (String)session.getAttribute("bName");
		
		System.out.println("Book Name in jsp : "+name);
		
		ResultSet rs=null,rs2=null;
		int size=0,size2=0;
		/**
		* Initilizing the size variable this variable is used to count row in the Resultset,
		* after executing the search query.
		*/
		if(name!=null){

		System.out.println(name);
		
		ArrayList<ResultSet> rsObj = new ArrayList<ResultSet>();
		
		rsObj = (ArrayList<ResultSet>)request.getAttribute("results");
		
		if(rsObj==null){
			request.setAttribute("bName", name);
			RequestDispatcher rd = request.getRequestDispatcher("SearchServlet");
			rd.forward(request, response);
			System.out.println("\n\nResponse sent\n\n");
		}else{
			System.out.println("\n\nrs : "+rsObj.get(0));
			System.out.println("rs2 : "+rsObj.get(1)+"\n\n");
			
			rs=rsObj.get(0); //NotBorrowedBookInfo
			rs2 = rsObj.get(1); // BorrowedBookInfo
			
			size = CommonServices.getResultsetSize(rs);
			size2 = CommonServices.getResultsetSize(rs2);
			
			rs.beforeFirst(); //resetting the Resultset cursor in the beginning 
			rs2.beforeFirst();
		}
		}
		
		Connection con = DbImplementation.dbConnect();		
		PreparedStatement psmt4=null;
		if(userType==2)
		{			
			psmt4 = con.prepareStatement(QueryInterface.getTeacherDetails);
		}
		else if(userType == 4)
		{
			psmt4 = con.prepareStatement(QueryInterface.getStudentsDetails);
		}
		else if(userType == 3)
			psmt4 = con.prepareStatement(QueryInterface.getLibrarianDetails);
		
		psmt4.setString(1, sessionEmail);
		
		ResultSet rs4 = psmt4.executeQuery();
		rs4.next();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="css/searchStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
    <title>Search</title>
</head>
<body>
<%if(userType!=1){if(!rs4.getBoolean("status")){ %>
	   <div class="banned">
	        Services are disabled because your account is deactivated. <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">Contact Librarian/Admin.</a>
	   </div>
   <%} }%>
   <div id="status-div" style="content-visibility: hidden;">
   	<span class="banned" id="status"></span>
   	</div>
    <div class="container">    
        <div class="content">
            <div style="display: flex; gap: 1rem; align-items: center; margin-left: 2rem;">
                <a class="back" href=<%if(userType == 1 || userType == 3){%>"dashboardAdminAndLibrarian.jsp"<%}else{ %>"dashboard.jsp"<%} %>><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></a>
                <span class="heading">Search</span>
            </div>
            <section>
            <form style="display: flex; margin-right: 3rem;" action="<%=request.getContextPath()%>/SearchServlet">
                <input type="text" id="srh" name="bName" oninput="validate()" class="search-box" placeholder="Search books" required>
                <input type="image" class="srh-icon" src="icons/search.svg">
            </form>
            </section>
        </div>
        <div style="display: flex; margin: 5px 6rem 0 0; justify-content: flex-end;"><a href="advancedSearch.jsp">Advance Search</a></div>
    </div>
   
    <div class="container results">
    <%
    if(rs!=null){
	if(rs.next()||rs2.next()){rs.beforeFirst();rs2.beforeFirst();%>
		
		<%if(userType == 1 || userType == 3){%> <form id="form" style="width: -webkit-fill-available;" action="<%=request.getContextPath()%>/EditOrDelete">
		<%}else{ %><form id="form" style="width: -webkit-fill-available;" action="<%=request.getContextPath()%>/BorrowBook"><%} %>
		    <table>
			
			<!-- Headings -->
	        <tr style="border-bottom: 1px solid;">
	            <th class="right-bdr">Book name</th>
	            <th class="right-bdr">Author name</th>
	            <th class="right-bdr">Edition</th>
	            <th class="right-bdr">Publisher</th>
	            <th>Actions</th>
	        </tr>
		
		<%if(rs2.next())
		{
			System.out.println("if BorrowedBookInfo ****");
			rs2.beforeFirst();
			while(rs2.next())
			{
				if(size2>0 && size>0 || size2>1 && size==0){ size2--; System.out.println("if BorrowedBookInfo");%>
	            <tr style="border-bottom: 1px solid;">
	                <td class="right-bdr"><%=rs2.getString("bookName")%></td>
	                <td class="right-bdr"><%=rs2.getString("author")%></td>
	                <td class="right-bdr"><%=rs2.getString("edition")%></td>
	                <td class="right-bdr"><%=rs2.getString("pname") %></td>
	                <%if(userType == 2 || userType == 4){ %><td><a href =<%=rs2.getString("bookPath")%>><input type="button" class="btn" value="Open"></a></td><%} %>
	            </tr>
	            <%}else if(size2==1 && size==0){System.out.println("else BorrowedBookInfo"); %>
	            <!-- Last row -->
	            <tr>
	                <td class="right-bdr" style="border-radius: 0px 0px 0px 10px;"><%=rs2.getString("bookName")%></td>
	                <td class="right-bdr"><%=rs2.getString("author")%></td>
	                <td class="right-bdr"><%=rs2.getString("edition")%></td>
	                <td class="right-bdr"><%=rs2.getString("pname") %></td>
	                 <%if(userType == 2 || userType == 4){ %><td style="border-radius: 0px 0px 10px 0px;"><a href=<%=rs2.getString("bookPath") %>><input type="button" class="btn" value="Open"></a></td><%} %>
	            </tr>
	            <%}
			}
		}
		boolean status = CommonServices.isUserActive(sessionEmail);
		if(rs.next()) //checking whether the resultset is non-empty
    	{	
			rs.beforeFirst(); //Resetting the cursor to the beginning%>
            <!-- Middle data -->
             <%while(rs.next())
    		{ if(size!=1){size--; System.out.println("if");%>
            <tr style="border-bottom: 1px solid;">
                <td class="right-bdr"><%=rs.getString("bookName")%><input type="checkbox" hidden="hidden" id="<%=size%>" name="book" value="<%=rs.getString("bid")%>"></td>
                <td class="right-bdr"><%=rs.getString("author")%></td>
                <td class="right-bdr"><%=rs.getString("edition")%></td>
                <td class="right-bdr"><%=rs.getString("pname") %></td>
                <%                
                if(rs4.getBoolean("status") && (userType == 2 || userType == 4)){ %>
                <td style="border-radius: 0px 0px 10px 0px;">
                	<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow">
                </td>
                 <%}else if(!rs4.getBoolean("status") && (userType == 1 || userType == 3)){ %>
	                <td style="filter: grayscale(1);">
	                	<a href=<%=rs.getString("bookPath")%>><input type="button" class="btn" value="Open" disabled="disabled"></a>
	                	<input type="checkbox" hidden="hidden" id="e<%=size%>" name="edit" value="edit"><input type="button" onclick="submitForm(<%=size%>,e<%=size%>,null);" class="btn edit" value="Edit" disabled="disabled">
	                	<input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete"><input type="button" onclick="submitForm(<%=size%>,null,d<%=size%>);" class="btn delete" value="Delete" disabled="disabled">
	                </td>
	                <%}else if(rs4.getBoolean("status") && (userType == 1 || userType == 3)){ %>
	                <td>
	                	<a href=<%=rs.getString("bookPath")%>><input type="button" class="btn" value="Open"></a>
	                	<input type="checkbox" hidden="hidden" id="e<%=size%>" name="edit" value="edit"><input type="button" onclick="submitForm(<%=size%>,e<%=size%>,null);" class="btn edit" value="Edit">
	                	<input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete"><input type="button" onclick="submitForm(<%=size%>,null,d<%=size%>);" class="btn delete" value="Delete">
	                </td>
	                <%}else{%>
	                <td style="border-radius: 0px 0px 10px 0px; filter: grayscale(1);">
                		<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow" disabled="disabled">
                	</td>
                <%} %>
            </tr>
            <%}else{System.out.println("else"); size--;%>
            <!-- Last row -->
            <tr>
                <td class="right-bdr" style="border-radius: 0px 0px 0px 10px;"><%=rs.getString("bookName")%><input type="checkbox" hidden="hidden" id="<%=size%>" name="book" value="<%=rs.getString("bid")%>"></td>
                <td class="right-bdr"><%=rs.getString("author")%></td>
                <td class="right-bdr"><%=rs.getString("edition")%></td>
                <td class="right-bdr"><%=rs.getString("pname") %></td>
                <%
                if(status && (userType == 2 || userType == 4)){ %>
                <td style="border-radius: 0px 0px 10px 0px;">
                	<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow">
                </td>
                 <%}else if(!status && (userType == 1 || userType == 3)){ %>
	                <td style="filter: grayscale(1);">
	                	<a href=<%=rs.getString("bookPath")%>><input type="button" class="btn" value="Open" disabled="disabled"></a>
	                	<input type="checkbox" hidden="hidden" id="e<%=size%>" name="edit" value="edit"><input type="button" onclick="submitForm(<%=size%>,e<%=size%>,null);" class="btn edit" value="Edit" disabled="disabled">
	                	<input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete"><input type="button" onclick="submitForm(<%=size%>,null,d<%=size%>);" class="btn delete" value="Delete" disabled="disabled">
	                </td>
	                <%}else if(status && (userType == 1 || userType == 3)){ %>
	                <td>
	                	<a href=<%=rs.getString("bookPath")%>><input type="button" class="btn" value="Open"></a>
	                	<input type="checkbox" hidden="hidden" id="e<%=size%>" name="edit" value="edit"><input type="button" onclick="submitForm(<%=size%>,e<%=size%>,null);" class="btn edit" value="Edit">
	                	<input type="checkbox" hidden="hidden" id="d<%=size%>" name="delete" value="delete"><input type="button" onclick="submitForm(<%=size%>,null,d<%=size%>);" class="btn delete" value="Delete">
	                </td>
	                <%}else{%>
	                <td style="border-radius: 0px 0px 10px 0px; filter: grayscale(1);">
                		<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow" disabled="disabled">
                	</td>
                <%} %>
            </tr>
            <%}} %>
        </table>
        </form>
        <%}%>
    </div>
    <%
		}else{
			/*
        	* Resultset is empty means the search term doesn't exsist in our database or in other words
        	* the book not found.
        	*/
		%>
			<div style="display:grid; font-family: arial,sans-serif; padding-top:1rem">
	        	<span>Your search - "<%=name%>" - did not match any documents.</span><br>
				<span>Suggestions:
				<ul>
					<li>Make sure that all words are spelled correctly.</li>
					<li>Try different keywords.</li>
					<li>Try advance search</li>
				</ul>
				</span>
			</div>
		<%}
	}
    con.close();}
		
    %>
    <script src="js/searchScript.js"></script>
    <script>
    let delCheck = '<%= session.getAttribute("delSuccess") %>';
    
    let bookName = '<%= session.getAttribute("bName") %>';
    document.getElementById("srh").setAttribute("value",bookName);
    
    if(delCheck!='null')
    {
    	console.log(delCheck);
    	alert("Book deleted successfully");
    	<%session.removeAttribute("delSuccess");%>
    }
    
    
    
    function submitForm(id)
    {
    	var uncheck=document.getElementsByName('book');
        for(var i=0;i<uncheck.length;i++)
        {
            if(uncheck[i].type=='checkbox')
            {
                uncheck[i].checked=false;
            }
        }
    	
    	console.log(id);
    	document.getElementById(id).checked = true;
    	console.log("checked");
    	document.getElementById("form").submit();
    }
    
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
    </script>
</body>
</html>