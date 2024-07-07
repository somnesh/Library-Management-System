package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.services.AdminServices;
import com.myApp.LibraryManagement.services.CommonServices;
import com.myApp.LibraryManagement.services.RequestBookServices;

@WebServlet("/AddBooks")
@MultipartConfig(fileSizeThreshold=0, maxFileSize=-1L) 
/**
 * Servlet implementation class AddBooks
 */
public class AddBooks extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddBooks() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String bookName = request.getParameter("bookName");
		String author = request.getParameter("author");
		String department = request.getParameter("department");
		String edition = request.getParameter("edition");
		String yearOfPublishing = request.getParameter("yearOfPublishing");
		String publisher = request.getParameter("Publisher");		
		
		System.out.println("\n=============================\n"
				+ "bookName : "+bookName
				+"\nauthor : "+author+"\ndepartment : "+department+"\nyearOfPublishing : "+yearOfPublishing);
		
		String uploadFilePath = "C:\\Users\\somne\\eclipse\\LibraryManagement\\src\\main\\webapp\\books";

		Part filePart = request.getPart("file");
		String fileName = filePart.getSubmittedFileName();
		
		for (Part part : request.getParts()) {                   
          if(fileName!=null)                  	
        	  part.write(uploadFilePath + fileName);        	         
		}
		
		System.out.println("done=======================");
		String path = "books/"+fileName;
		
		try {
			boolean noDuplicate = AdminServices.isBookDuplicate(bookName, author, edition);
			boolean check = false;
			String rid = request.getParameter("requestedRid");
			
			if(noDuplicate) 
			{
//				
				Connection con = DbImplementation.dbConnect();
				CommonServices.setAutoCommit(con,false);
				boolean status = AdminServices.insertBookData(con,bookName, author, department, edition, yearOfPublishing, publisher,path);
				
					if(status)
					{

						if(rid!=null)
						{
							check = RequestBookServices.requestGranted(rid);
							if(check)
							{
								CommonServices.commit(con);
//								CommonServices.setAutoCommit(1);
								System.out.println("Book added successfully");
								Cookie ck = new Cookie("status", "1");
								ck.setMaxAge(3);
								response.addCookie(ck);
								response.sendRedirect("addBooks.jsp");
							}
							else
							{
								CommonServices.rollback(con);
//								CommonServices.setAutoCommit(1);
								
							}
						}						
						
					}
					else
					{
						System.out.println("something went wrong");
						Cookie ck = new Cookie("status", "0");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("addBooks.jsp");
					}
					
				con.close();
				
				if(!check && rid!=null)
				{
					System.out.println("something went wrong check");
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("addBooks.jsp");
				}
			}
			else
			{
				Cookie ck = new Cookie("status", "2");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("addBooks.jsp");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("something went wrong");
			Cookie ck = new Cookie("status", "0");
			ck.setMaxAge(3);
			response.addCookie(ck);
			response.sendRedirect("addBooks.jsp");
		}
	}

}
