package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.AdminServices;

@WebServlet("/AddPublishers")
/**
 * Servlet implementation class AddPublishers
 */
public class AddPublishers extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddPublishers() {
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
		String publisherName = request.getParameter("publisher");
		
		try {
			boolean isUniquePublisher = AdminServices.isPublisherDuplicate(publisherName);
			if(isUniquePublisher)
			{
				boolean status = AdminServices.insertPublisherData(publisherName);
				if(status)
				{
					System.out.println("publisher added successfully");
					Cookie ck = new Cookie("status", "1");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("addPublishers.jsp");
				}
				else
				{
					System.out.println("something went wrong");
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("addPublishers.jsp");
				}
			}
			else
			{
				Cookie ck = new Cookie("status", "2");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("addPublishers.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("something went wrong");
			Cookie ck = new Cookie("status", "0");
			ck.setMaxAge(3);
			response.addCookie(ck);
			response.sendRedirect("addPublishers.jsp");
		}
	}

}
