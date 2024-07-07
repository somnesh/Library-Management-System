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
import com.myApp.LibraryManagement.services.GenerateIdService;

@WebServlet("/AddDepartment")
/**
 * Servlet implementation class AddDepartment
 */
public class AddDepartment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddDepartment() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String deptName = request.getParameter("dept_name");
		
		//generating department id
		try {
			boolean uniqueName = AdminServices.isDepartmentUnique(deptName);
			
			if(uniqueName)
			{
				String deptId = GenerateIdService.generateDepatmentId();
				
				boolean status = AdminServices.addDepatment(deptId, deptName);
				if(status)
				{
					System.out.println("Department added");
					Cookie ck = new Cookie("status", "1");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("addDepartment.jsp");
				}
				else
				{
					System.out.println("failed");
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("addDepartment.jsp");
				}
			}
			else
			{
				System.out.println("duplicate");
				Cookie ck = new Cookie("status", "2");
				ck.setMaxAge(3);
				response.addCookie(ck);
				response.sendRedirect("addDepartment.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
