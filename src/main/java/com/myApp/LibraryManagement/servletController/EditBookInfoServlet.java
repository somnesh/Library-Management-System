package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.AdminServices;

@WebServlet("/EditBookInfo")
/**
 * Servlet implementation class EditBookInfoServlet
 */
public class EditBookInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditBookInfoServlet() {
        super();
        // TODO Auto-generated constructor stub
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
		
		System.out.println(bookName+author+department+edition+yearOfPublishing+publisher);

		HttpSession session = request.getSession();
		String bookId = (String) session.getAttribute("bId");
		
		try {
				
			System.out.println("book id : "+bookId);
			boolean status = AdminServices.UpdateBookData(bookId,bookName, author, department, edition, yearOfPublishing, publisher);
			if(status)
			{
				System.out.println("Book info updated successfully");
				Cookie ck = new Cookie("status", "1");
				ck.setMaxAge(3);
				
				request.setAttribute("bId",bookId);
				RequestDispatcher rd = request.getRequestDispatcher("editBook.jsp");

				response.addCookie(ck);
				rd.forward(request, response);
				
			}
			else
			{
				System.out.println("something went wrong");
				Cookie ck = new Cookie("status", "0");
				ck.setMaxAge(3);
				request.setAttribute("bId",bookId);
				RequestDispatcher rd = request.getRequestDispatcher("editBook.jsp");

				response.addCookie(ck);
				rd.forward(request, response);
			}					
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("something went wrong");
			Cookie ck = new Cookie("status", "0");
			ck.setMaxAge(3);
			request.setAttribute("bId",bookId);
			RequestDispatcher rd = request.getRequestDispatcher("editBook.jsp");

			response.addCookie(ck);
			rd.forward(request, response);
		}
	}
	

}
