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

import com.myApp.LibraryManagement.services.AdminServices;

@WebServlet("/updateDeparment")
/**
 * Servlet implementation class UpdateDeparmentServlet
 */
public class UpdateDeparmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateDeparmentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		
		String deptId = (String)session.getAttribute("deptId");
		String deptName = request.getParameter("dept_name");
		
		Cookie ck = null;
		
		try {
			
			boolean uniqueName = AdminServices.isDepartmentUnique(deptName, deptId);
			
			if(uniqueName)
			{
				boolean status = AdminServices.updateDepartment(deptName, deptId);				
				
				if(status)
				{
					ck = new Cookie("status", "1");
					ck.setMaxAge(2);
					response.addCookie(ck);
					response.sendRedirect("editDepartment.jsp");
				}
				else
				{
					ck = new Cookie("status", "0");
					ck.setMaxAge(2);
					response.addCookie(ck);
					response.sendRedirect("editDepartment.jsp");
				}
			}
			else
			{
				ck = new Cookie("status", "2");
				ck.setMaxAge(2);				
				response.addCookie(ck);
				
				Cookie ck2 = new Cookie("deptName", deptName);
				ck2.setMaxAge(2);				
				response.addCookie(ck2);
				
				response.sendRedirect("editDepartment.jsp");
			}
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			ck = new Cookie("status", "0");
			ck.setMaxAge(2);
			response.addCookie(ck);
			response.sendRedirect("editDepartment.jsp");
		}
		
	}

}
