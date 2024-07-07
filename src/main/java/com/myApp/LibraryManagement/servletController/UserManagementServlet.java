package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.services.AdminServices;
import com.myApp.LibraryManagement.services.CommonServices;

@WebServlet("/UserManagement")
/**
 * Servlet implementation class StudentManagementServlet
 */
public class UserManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserManagementServlet() {
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
		// TODO Auto-generated method stub
		String sid = request.getParameter("sid");
		String tid = request.getParameter("tid");
		String lid = request.getParameter("lid");
		
		String ban = request.getParameter("ban");
		String limit = request.getParameter("limit");
		String activate = request.getParameter("Activate");
		String delete = request.getParameter("delete");
		
		HttpSession session = request.getSession();
		
		
		System.out.println("\n\n\n\n---------------------\n\n sid = "
		+sid+"\n ban = "+ban+"\n limit = "+limit+"\n activate = "+activate+"\n delete = "+delete);
		String email=null;
		System.out.println("\n\n Session scroll = "+session.getAttribute("scroll"));
		
		try {
			Cookie ck = null;
			
			if(sid!=null)
				email = CommonServices.getStudentEmail(sid);
			else if(tid!=null)
				email = CommonServices.getTeacherEmail(tid);
			else if(lid!=null)
				email = CommonServices.getLibrarianEmail(lid);
			else
				response.sendRedirect("somethingWentWrong.jsp");
			
			if(ban!=null)
			{
				boolean status = AdminServices.banUser(email);
				if(status) 
				{
					ck = new Cookie("status","1");
				}
				else
				{
					ck = new Cookie("status","0");
				}
			}
			else if(limit!=null)
			{
				String newLimit = null;
				
				if(sid!=null)
					newLimit = request.getParameter("limit-value"+sid);
				
				else if(tid!=null)
					newLimit = request.getParameter("limit-value"+tid);
				
				boolean status = AdminServices.setBorrowLimit(email, newLimit);
				if(status) 
				{
					ck = new Cookie("status","2");
				}
				else
				{
					ck = new Cookie("status","0");
				}
			}
			else if(activate!=null)
			{
				boolean status = AdminServices.activateUser(email);
				if(status) 
				{
					ck = new Cookie("status","3");
				}
				else
				{
					ck = new Cookie("status","0");
				}
			}
			else if(delete!=null)
			{
				Connection con = DbImplementation.dbConnect();
				CommonServices.setAutoCommit(con,false);
				
				boolean check = AdminServices.deleteUser(con,email);
				boolean deleteUserDetails = false;
				
				if(check)
				{
					if(sid!=null)
						deleteUserDetails = AdminServices.deleteUserDetails(con,sid, "sid", "students");
					else if(tid!=null)
						deleteUserDetails = AdminServices.deleteUserDetails(con,tid, "tid", "teachers");
					else if(lid!=null)
						deleteUserDetails = AdminServices.deleteUserDetails(con,lid, "lid", "librarian");
				}
				else
				{
					ck = new Cookie("status","0");
				}
				
				if(deleteUserDetails)
				{
					CommonServices.commit(con);
					ck = new Cookie("status","4");
				}
				else
				{
					CommonServices.rollback(con);
					ck = new Cookie("status","0");
				}
				CommonServices.setAutoCommit(con,true);
			}
			ck.setMaxAge(10);
			response.addCookie(ck);
			
			if(sid!=null)
				response.sendRedirect("studentDetails.jsp");
			else if(tid!=null)
				response.sendRedirect("teacherDetails.jsp");
			else if(lid!=null)
				response.sendRedirect("librarianDetails.jsp");
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
