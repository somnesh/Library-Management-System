package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.AdminServices;

@WebServlet("/TeacherRegistration")
/**
 * Servlet implementation class TeacherRegistration
 */
public class TeacherRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TeacherRegistration() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String department = request.getParameter("department");
		String dob = request.getParameter("dob");
		String village = request.getParameter("village");
		String district = request.getParameter("district");
		String post = request.getParameter("post");
		String pinCode = request.getParameter("pin");
		String password = request.getParameter("password");
		
		try {
			boolean uniqueEmail = AdminServices.isEmailUnique(email);
			boolean uniquePhone = AdminServices.isPhoneUnique(phone);
			
			if(uniqueEmail && uniquePhone)
			{
				boolean insertCheck = AdminServices.insertTeacherData(firstName, lastName, email, phone, department, dob, village, district, post, pinCode, password);
				if(insertCheck)
				{
					System.out.println("Teacher account created successfully");
					Cookie ck = new Cookie("status", "1");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("teacherRegister.jsp");
				}
				else
				{
					System.out.println("something went wrong");
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("teacherRegister.jsp");
				}
			}
			else
			{
				Cookie[] ck = new Cookie[12];
				
				if(!uniqueEmail)
					ck[10] = new Cookie("emailCheck", "1");
				else
					ck[10] = new Cookie("emailCheck", "0");
				
				if(!uniquePhone)
					ck[11] = new Cookie("phoneCheck", "1");
				else
					ck[11] = new Cookie("phoneCheck", "0");
				
				ck[0] = new Cookie("email", email);
				ck[1] = new Cookie("phone", phone);
				ck[2] = new Cookie("firstName", firstName);
				ck[3] = new Cookie("lastName", lastName);
				String dept = URLEncoder.encode(department, "UTF-8");
				ck[4] = new Cookie("department", dept);
				ck[5] = new Cookie("dob", dob);
				ck[6] = new Cookie("village", village);
				ck[7] = new Cookie("district", district);
				ck[8] = new Cookie("post", post);
				ck[9] = new Cookie("pin", pinCode);
				
				for(int i=0;i<12;i++)
				{
					ck[i].setMaxAge(3);
					response.addCookie(ck[i]);
				}
				response.sendRedirect("teacherRegister.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Cookie ck = new Cookie("status", "0");
			ck.setMaxAge(3);
			response.addCookie(ck);
			response.sendRedirect("teacherRegister.jsp");
		}
		
	}

}
