<%@page import="com.myApp.LibraryManagement.services.AdminServices"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.myApp.LibraryManagement.interfaces.QueryInterface"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.myApp.LibraryManagement.dbImplementation.DbImplementation"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	String sessionEmail = (String)session.getAttribute("SessionUserEmail");
	System.out.println(sessionEmail);
	if(sessionEmail==null)
	{
		response.sendRedirect("login.jsp");
	}else{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getDepartmentNamesQuery);
	    PreparedStatement psmt2 = con.prepareStatement("SELECT * FROM PUBLISHERS");
		ResultSet rs = psmt.executeQuery();
	    ResultSet rs2 = psmt2.executeQuery();
	    
	    String bookId = (String)request.getAttribute("bId");
	    session.setAttribute("bId", bookId);
	    if(bookId!=null)
	    {
	    	ResultSet rsBookInfo = AdminServices.getBookInfo(bookId);
	    	rsBookInfo.next();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	
	<link rel="stylesheet" href="css/registerStyle.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Facilities</title>
    <link rel="icon" type="image/icon" href="icons/favicon.ico">
</head>
<body style="display: flex; margin:1rem; justify-content: center; align-items: center;">
    <div class="wrapper" style="padding: 3rem 7rem;">
        <div class="content" style="display: block;">
            <div style="display: flex; padding-bottom: 3rem; gap: 15rem; align-items: center;">
                <span class="back" onclick="window.history.back()"><img src="icons/arrowBack.svg" alt="back" style="height: 30px;"></span>
                <span class="heading">Update Book Details</span>
            </div>
            <div id="status-div" style="content-visibility: hidden;">
            		<span id="status"></span>
            </div>
            <form action="<%=request.getContextPath()%>/EditBookInfo" method="post">
                <div class="container">
                    <div class="columns">
                        <div class="first-col">
                            <span class="lebel-box">Book Name</span>
                            <input type="text" class="box" id="bookName" value="<%=rsBookInfo.getString("bookName") %>" name="bookName" placeholder="Enter Book Name" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Author</span>
                            <input type="text" class="box" id="author" value="<%=rsBookInfo.getString("author") %>" name="author" placeholder="Enter Author Name" required>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Department</span>
                            <select class="box" style="width: 20.6rem;" id="department" name="department" required>
                                <option value="" disabled hidden>Select Book department</option>
                                <%while(rs.next()){ %>
                                <option id="d<%=rs.getString("Dept_Id")%>" value="<%=rs.getString("dept_name")%>"><%=rs.getString("dept_name")%></option>
                                <%} %>
                            </select>
                        </div>
                        <div class="first-col">
                            <span class="lebel-box">Book path</span>
                            <input type="text" class="box" id="path" value=<%=rsBookInfo.getString("bookPath") %> name="path" placeholder="Enter book path" required>
                        </div>
                        
                        
                    </div>
                    <div class="columns">
                        <div class="second-col">
                            <span class="lebel-box">Edition</span>
                            <input type="text" class="box" id="edition" value="<%=rsBookInfo.getString("edition") %>" name="edition" placeholder="Enter Book Edition e.g. 3rd" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Year of Publishing</span>
                            <input type="number" class="box" id="yearOfPublishing" value="<%=rsBookInfo.getString("yearOfPublishing") %>" name="yearOfPublishing" placeholder="Enter Year of Publishing ( YYYY )" min="1900" max="2023" required>
                        </div>
                        <div class="second-col">
                            <span class="lebel-box">Publisher</span>
                            <select class="box" style="width: 20.6rem;" id="Publisher" name="Publisher" required>
                                <option value="" disabled hidden>Select Book Publisher</option>
                                <%while(rs2.next()){ %>
                                <option id="<%=rs2.getString("pid")%>" value="<%=rs2.getString("pName")%>"><%=rs2.getString("pName")%></option>
                                <%} %>
                            </select>
                        </div>
                        <div class="second-col">
                			<button id="submit" type="submit" class="btn">Update Book</button>
            			</div>
                        
                    </div>
                </div>
            
            
        </form>
        </div>
    </div>
	<script src="js/addBooksScript.js"></script>
    <script>
        let n = document.getElementById("d<%=rsBookInfo.getString("Dept_Id")%>");
        let m = document.getElementById("<%=rsBookInfo.getString("pid")%>");
        
        let d = document.getElementById("department").options;
        let p = document.getElementById("Publisher").options;
        console.log(n);
        
        console.log(d.selectedIndex);
        document.getElementById("d1").removeAttribute("selected");
        n.setAttribute("selected","");
       
        console.log(d);  
        m.setAttribute("selected","");
        if(p.selectedIndex>1)
        	p[1].selected = false;
        
    </script>
     <%con.close();}else{response.sendRedirect("badRequest.jsp");}con.close();} %>
</body>
</html>    