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

import com.myApp.LibraryManagement.services.ForgotPassService;
import com.myApp.LibraryManagement.services.LoginService;

@WebServlet("/ChangePassServlet")
/**
 * Servlet implementation class ChangePassServlet
 */
public class ChangePassServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangePassServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String oldPass = request.getParameter("oldPass");
		String newPass = request.getParameter("newPass");
		
		HttpSession session = request.getSession();
		String email = (String)session.getAttribute("SessionUserEmail");
		
		try {
			boolean validate = LoginService.ValidateLogin(email, oldPass);
			if(validate) 
			{
				boolean check = ForgotPassService.changePassword(email, newPass);
				if(check)
				{
					Cookie ck = new Cookie("status", "1");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("changePassword.jsp");
				}
				else
				{
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("changePassword.jsp");
				}
			}
			else
			{
				Cookie ck = new Cookie("status", "2");
				Cookie ck2 = new Cookie("oldPass", oldPass);
				ck.setMaxAge(3);
				ck2.setMaxAge(3);
				response.addCookie(ck);
				response.addCookie(ck2);
				response.sendRedirect("changePassword.jsp");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Cookie ck = new Cookie("status", "0");
			ck.setMaxAge(3);
			response.addCookie(ck);
			response.sendRedirect("changePassword.jsp");
		}
	}

}
