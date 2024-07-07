<%@page import="java.util.ArrayList"%>
<%@page import="com.myApp.LibraryManagement.services.CommonServices"%>
<%@page import="com.myApp.LibraryManagement.services.SearchServices"%>
<%@page import="com.myApp.LibraryManagement.services.BorrowBookServices"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jakarta.servlet.http.Cookie" %>
<%@page import="java.util.Objects" %>
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
		session.setAttribute("advancedSearch", "1");
		
		String bookDetails[] = (String[])session.getAttribute("bookDetails");
		
		//session.setAttribute("bookDetails", bookDetails);
		
		int userType = CommonServices.UserType(sessionEmail);
		
		ResultSet rs=null,rs2=null;
		
		int size=0,size2=0;
		
		ArrayList<ResultSet> rsObj = new ArrayList<ResultSet>();
		
		rsObj = (ArrayList<ResultSet>)request.getAttribute("results");
		
		if(rsObj==null){
			
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
		ResultSet rs3 = CommonServices.getPublishersNames();
		ResultSet rs4 = CommonServices.getDepartmentNames();
		
		Connection con = DbImplementation.dbConnect();
		boolean status = CommonServices.isUserActive(sessionEmail);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="css/advancedSearchStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
    <title>Advanced Search</title>
</head>
<body>
<%if(!status){ %>
	   <div class="banned">
	        Services are disabled because your account is deactivated. <a style="text-decoration: underline; color: white; font-family: unset;" href="mailto:somneshmukhopadhyay@gmail.com">Contact Librarian/Admin.</a>
	   </div>
   <%} %>
   <div id="status-div" style="content-visibility: hidden;">
   	<span class="banned" id="status"></span>
   	</div>
    <div class="container">
        <div style="display: flex; gap: 1rem; align-items: center; margin-left: 2rem; margin-bottom: 2rem;">
            <span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
            <span class="heading">Advanced Search</span>
        </div>
         <form action="<%=request.getContextPath()%>/AdvancedSearch" method="get">
        <div class="content">
            <div class="columns">
                <div class="first-col">
                    <span class="lebel-box">Book Name</span>
                    <input type="text" class="box" oninput="validate()" id="bookName" name="bookName" placeholder="Enter Book Name" <%if(bookDetails!=null){ %>value="<%=bookDetails[0]%>"<%} %> required>
                </div>
                <div class="first-col">
                    <span class="lebel-box">Author Name</span>
                    <input type="text" class="box" oninput="validate()" id="author" name="author" placeholder="Enter Author Name" <%if(bookDetails!=null){ %>value="<%=bookDetails[1]%>"<%} %> required>
                </div>
                <div class="first-col">
                    <span class="lebel-box">Department</span>
                    <select class="box" style="width: 20.6rem;" id="department" name="department" required>
                        <%if(bookDetails==null){ %><option value="" disabled selected hidden>Select Book department</option><%} %>
                        <%while(rs4.next()){ %>
                        <option id="<%=rs4.getString("dept_name")%>" value="<%=rs4.getString("dept_name")%>"><%=rs4.getString("dept_name")%></option>
                        <%} %>
                    </select>
                </div>
            </div>
            <div class="columns">
                <div class="second-col">
                    <span class="lebel-box">Book Edition</span>
                    <input type="text" class="box" oninput="validate()" id="edition" name="edition" placeholder="Enter Book Edition i.e. 3rd" <%if(bookDetails!=null){ %>value="<%=bookDetails[3]%>"<%} %> required>
                </div>
                <div class="second-col">
                    <span class="lebel-box">Publisher</span>
                    <select class="box" style="width: 20.6rem;" id="publisher" name="publisher" required>
                        <%if(bookDetails==null){ %><option value="" disabled selected hidden>Select Book Publisher</option><%} %>
                        <%while(rs3.next()){ %>
                        <option id="<%=rs3.getString("pName")%>" value="<%=rs3.getString("pName")%>"><%=rs3.getString("pName")%></option>
                        <%} %>
                    </select>
                </div>
                <div style="display: flex; justify-content: center;">
                    <button style="padding: 1rem 2rem 1rem 2rem; font-size: 16px;" id="submit" type="submit" class="btn">Advanced Search</button>
                </div>
            </div>
        </div>
        </form>
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
		
		if(rs.next()) //checking whether the resultset is non-empty
    	{	
			rs.beforeFirst(); //Resetting the cursor to the beginning%>
            <!-- Middle data -->
             <%while(rs.next())
    		{ if(size!=1){size--; System.out.println("if");%>
            <tr style="border-bottom: 1px solid;">
                <td class="right-bdr"><%=rs.getString("bookName")%><input type="checkbox" hidden="hidden" id="<%=size%>" name="book" value="<%=rs.getString("bid")%>"></td>
                <td class="right-bdr"><%=rs.getString("author")%><input type="text" hidden="hidden" name="check" value="<%=rs.getString("bookName")%>"></td>
                <td class="right-bdr"><%=rs.getString("edition")%></td>
                <td class="right-bdr"><%=rs.getString("pname") %></td>
                
                 <%                
                if(status && (userType == 2 || userType == 4)){ %>
                <td style="border-radius: 0px 0px 10px 0px;">
                	<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow">
                </td>
                 <%}else if(userType == 1 || userType == 3){ %>
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
                <td class="right-bdr"><%=rs.getString("author")%><input type="text" hidden="hidden" name="check" value="<%=rs.getString("bookName")%>"></td>
                <td class="right-bdr"><%=rs.getString("edition")%></td>
                <td class="right-bdr"><%=rs.getString("pname") %></td>
                 <%                
                if(status && (userType == 2 || userType == 4)){ %>
                <td style="border-radius: 0px 0px 10px 0px;">
                	<input type="button" onclick="submitForm(<%=size%>);" class="btn" value="Borrow">
                </td>
                 <%}else if(userType == 1 || userType == 3){ %>
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
        <%}else{ System.out.println("rs null : " + rs);
        	/*
        	* Resultset is empty means the search term doesn't exsist in our database or in other words
        	* the book not found.
        	*/
        %>
        <div style="display:grid; font-family: arial,sans-serif; padding-top:1rem">
	        	<span>Your search - did not match any documents.</span><br>
				<span>Suggestions:
				<ul>
					<li>Make sure that all words are spelled correctly.</li>
					<li>Try different keywords.</li>
				</ul>
				</span>
			</div>
        	<% }
		}else{%>
			<div style="display:grid; font-family: arial,sans-serif; padding-top:1rem">
	        	<span>Search books with name, author, publisher, and department for accurate search results</span><br>
			</div>
    		<%} %>
    <script src="js/advancedSearchScript.js"></script>
       <script>
       <%if(bookDetails!=null){ %>
       let n = document.getElementById("<%=bookDetails[2]%>");
       let m = document.getElementById("<%=bookDetails[4]%>");
       
       let d = document.getElementById("department").options;
       let p = document.getElementById("publisher").options;
       console.log(n);
       
       console.log(d.selectedIndex);
       document.getElementById("Accountancy").removeAttribute("selected");
       n.setAttribute("selected","");
      
       console.log(d);  
       m.setAttribute("selected","");
       if(p.selectedIndex>1)
       	p[1].selected = false;
       
 	<% //session.removeAttribute("bookDetails"); %>
    <%}%>
    
    </script>
<%con.close();} %>
</body>
</html>