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
@WebServlet("/ManageRequest")
/**
 * Servlet implementation class ManageRequestServlet
 */
public class ManageRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ManageRequestServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String rid = request.getParameter("record");
		String add = request.getParameter("add");
		String delete = request.getParameter("delete");
		
		System.out.println("\n================ Manage Request Servlet ==============\n"+"rid = "+rid+"\nadd = "+add+"\ndelete = "+delete);
		
		if(add!=null)
		{
			HttpSession session = request.getSession();
			session.setAttribute("rid", rid);
			response.sendRedirect("addBooks.jsp");
		}
		else if(delete.matches("1"))
		{
			HttpSession session = request.getSession();		
			String email = (String) session.getAttribute("SessionUserEmail");
			
			try {
				boolean status = RequestBookServices.cancelRequest(email, rid);
				if(status)
				{
					Cookie ck = new Cookie("status", "43");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("requestedBooks.jsp");
				}
				else
				{
					Cookie ck = new Cookie("status", "44");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("requestedBooks.jsp");
				}
				
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Cookie ck = new Cookie("status", "44");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("requestedBooks.jsp");
			}
		}
		else if(delete.matches("0"))
		{
			try {
				boolean status = RequestBookServices.deleteRequest(rid);
				if(status)
				{
					Cookie ck = new Cookie("status", "43");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("requestedBooks.jsp");
				}
				else
				{
					Cookie ck = new Cookie("status", "44");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("requestedBooks.jsp");
				}
				
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Cookie ck = new Cookie("status", "44");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("requestedBooks.jsp");
			}
		}
		else
		{
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
