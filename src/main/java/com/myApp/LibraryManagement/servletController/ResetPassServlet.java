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
import java.util.Objects;

import com.myApp.LibraryManagement.services.ForgotPassService;
@WebServlet("/ResetPassServlet")
/**
 * Servlet implementation class ResetPassServlet
 */
public class ResetPassServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPassServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String newPass = request.getParameter("password");
		String email="";
		Cookie ck[]=request.getCookies();  
		for(int i=0;i<ck.length;i++)
		{
			if(Objects.equals(ck[i].getName(), "email"))
			{
				System.out.println(ck[i].getValue());
				email =ck[i].getValue();
			}
		}
		
		try {
			boolean passChanged = ForgotPassService.changePassword(email, newPass);
			
			if(passChanged)
			{
				System.out.println("password changed");
				//confirmation page
				//send redirect to dashboard
				HttpSession session = request.getSession();
				session.setAttribute("SessionUserEmail", email);
				response.sendRedirect("dashboardDemo.jsp");
			}
			else
			{
				System.out.println("falied");
				//something went wrong 
				response.sendRedirect("somethingWentWrong.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
