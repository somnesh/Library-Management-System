package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.ForgotPassService;
@WebServlet("/ForgotPassServlet")
/**
 * Servlet implementation class ForgotPassServlet
 */
public class ForgotPassServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ForgotPassServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		String dob = request.getParameter("dob");
		
		try {
			boolean isValid = ForgotPassService.validateForgotPass(email, dob);	
			if(isValid )
			{
				Cookie ck = new Cookie("email", email);
				ck.setMaxAge(120);
				response.addCookie(ck);
				response.sendRedirect("resetPass.jsp");
			}
			else
			{
				Cookie ck = new Cookie("email", "0");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("forgotPass.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}
}