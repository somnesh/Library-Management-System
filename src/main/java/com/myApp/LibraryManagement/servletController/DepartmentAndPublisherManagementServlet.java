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
import java.sql.SQLIntegrityConstraintViolationException;

import com.myApp.LibraryManagement.services.AdminServices;

@WebServlet("/DeparmentAndPublisherManagement")
/**
 * Servlet implementation class DepartmentAndPublisherManagementServlet
 */
public class DepartmentAndPublisherManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DepartmentAndPublisherManagementServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String delete = request.getParameter("delete");
		String edit = request.getParameter("edit");
		String deptId = request.getParameter("deptId");
		String pid = request.getParameter("pid");
		
		System.out.println("\n--------------------\n deptId = "+deptId);
		
		try 
		{			
			if(delete!=null)
			{						
				boolean status = false,f=true;
				Cookie ck = null;
				
				if(deptId!=null)
				{
					try {
						status = AdminServices.deleteDepartment(deptId);
					}
					catch(SQLIntegrityConstraintViolationException e)
					{
						f=false;
						ck = new Cookie("status","7");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("departmentDetails.jsp");
					}
					
					if(f)
					{
						if(status) 					
							ck = new Cookie("status","5");					
						else				
							ck = new Cookie("status","0");
						
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("departmentDetails.jsp");
					}
				}
				else if(pid!=null)
				{	
					try {
						status = AdminServices.deletePublisher(pid);						
					}
					catch(SQLIntegrityConstraintViolationException e)
					{
						f=false;
						ck = new Cookie("status","8");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("publishersDetails.jsp");
					}
					
					if(f)
					{
						if(status) 					
							ck = new Cookie("status","6");					
						else				
							ck = new Cookie("status","0");
						
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("publishersDetails.jsp");
					}
				}
				
			}
			
			else if(edit!=null)
			{
				HttpSession session = request.getSession();
				if(deptId!=null)
				{
					session.setAttribute("deptId", deptId);
					response.sendRedirect("editDepartment.jsp");
				}
				
				else if(pid!=null)
				{
					session.setAttribute("pid", pid);
					response.sendRedirect("editPublisher.jsp");
				}
			}
											
		}
		catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
