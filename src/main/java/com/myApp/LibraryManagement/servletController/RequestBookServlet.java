package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.RequestBookServices;

@WebServlet("/RequestBook")
/**
 * Servlet implementation class RequestBookServlet
 */
public class RequestBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RequestBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String bookName = request.getParameter("bookName");
		String author = request.getParameter("author");
		String edition = request.getParameter("edition");
		String publisher = request.getParameter("publisher");
		
		HttpSession session = request.getSession();
		
		String email = (String)session.getAttribute("SessionUserEmail");
		
		try {
			boolean bookCheck = RequestBookServices.isbookAlreadyExists(bookName, author, edition, publisher);
			boolean duplicate = RequestBookServices.duplicateRequestFromSameUser(email, bookName, author, edition, publisher);
			if(duplicate)
			{
				if(bookCheck)
				{
					boolean requestCheck = RequestBookServices.insertDataRequestBook(email, bookName, author, edition, publisher);				
					if(requestCheck)
					{
						//Request Submitted Successfully
						Cookie ck = new Cookie("status", "330");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("requestBook.jsp");
					}
					else
					{
						//Request Submission failed
						Cookie ck = new Cookie("status", "331");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("requestBook.jsp");
					}				
				}
				else
				{
					//The book is already exists in the library
					Cookie ck = new Cookie("status", "332");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("requestBook.jsp");
				}
			}
			else
			{
				//The book request already made
				Cookie ck = new Cookie("status", "333");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("requestBook.jsp");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
