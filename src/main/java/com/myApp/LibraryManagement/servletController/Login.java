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

import com.myApp.LibraryManagement.services.CommonServices;
import com.myApp.LibraryManagement.services.LoginService;

@WebServlet("/Login")
/**
 * Servlet implementation class StudentLogin
 */

public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Login() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		try {
			//validating user credentials 
			boolean validateLogin = LoginService.ValidateLogin(email, password);
			
			if(validateLogin)
			{
				//Determining user type
				int userType = CommonServices.UserType(email); // admin = 1; teacher = 2; librarian = 3; student = 4
				
				if(userType == 1)
				{
					//admin dash-board
					System.out.println("welcome admin");
					
					HttpSession session = request.getSession();
					session.setAttribute("SessionUserEmail", email);
					response.sendRedirect("dashboardAdminAndLibrarian.jsp");
				}
				else if(userType == 2)
				{
					//teacher dash-board
					System.out.println("welcome teacher");
					
					HttpSession session = request.getSession();
					session.setAttribute("SessionUserEmail", email);
					response.sendRedirect("dashboard.jsp");
				}
				else if(userType == 3)
				{
					//librarian dash-board
					System.out.println("welcome librarian");
					
					HttpSession session = request.getSession();
					session.setAttribute("SessionUserEmail", email);
					response.sendRedirect("dashboardAdminAndLibrarian.jsp");
				}
				else
				{
					//student dash-board
					System.out.println("welcome student");
					
					HttpSession session = request.getSession();
					session.setAttribute("SessionUserEmail", email);
					response.sendRedirect("dashboard.jsp");
				}
			}
			else
			{
				Cookie ck = new Cookie("userEmail",email);
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("login.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) 
		{
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		} 
	}
}
