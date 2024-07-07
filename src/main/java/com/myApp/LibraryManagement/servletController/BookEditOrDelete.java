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

@WebServlet("/EditOrDelete")
/**
 * Servlet implementation class BookEditOrDelete
 */
public class BookEditOrDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookEditOrDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String bookId = request.getParameter("book");
		String edit = request.getParameter("edit");
		String delete = request.getParameter("delete");
		System.out.println("\n\n\n\n Edit = "+edit+"\n\n Delete = "+delete);
		
		if(edit!=null && delete==null)
		{
			request.setAttribute("bId", bookId);
			RequestDispatcher rd = request.getRequestDispatcher("editBook.jsp");
			
			rd.forward(request, response);
		}
		else if(delete!=null && edit==null)
		{
			HttpSession session = request.getSession(); // creating a session object
			String bookName = (String) session.getAttribute("bName");
			session.setAttribute("bName", bookName);
			
			try {
				String fromBookDetails = (String)session.getAttribute("fromBookDetails");
				boolean check = AdminServices.DeleteBook(bookId);
				if(check)
				{
					session.setAttribute("delSuccess", "1");
					
					
					RequestDispatcher rd=null;
					
					if(fromBookDetails==null)
						rd = request.getRequestDispatcher("search.jsp");
					else {
						rd = request.getRequestDispatcher("bookDetails.jsp");
						Cookie ck = new Cookie("status", "1");
						ck.setMaxAge(3);
						response.addCookie(ck);
					}
					rd.forward(request, response);
				}
				else
				{
					
					if(fromBookDetails==null)
						response.sendRedirect("somethingWentWrong.jsp");
					else {
						
						Cookie ck = new Cookie("status", "0");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("bookDetails.jsp");
					}
				}
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				response.sendRedirect("somethingWentWrong.jsp");
			}

		}
		else
		{
			response.sendRedirect("badRequest.jsp");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
