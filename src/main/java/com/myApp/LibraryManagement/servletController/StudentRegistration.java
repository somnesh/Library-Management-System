package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.StudentSignUpService;

@WebServlet("/StudentRegistration")
/**
 * Servlet implementation class StudentRegistation
 */
public class StudentRegistration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentRegistration() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		//getting form values 
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String roll = request.getParameter("roll");
		String reg = request.getParameter("reg");
		String department = request.getParameter("department");
		String dob = request.getParameter("dob");
		String village = request.getParameter("village");
		String district = request.getParameter("district");
		String post = request.getParameter("post");
		String pinCode = request.getParameter("pin");
		String password = request.getParameter("password");
		
		//type casting variable string to integer 
		int pin = Integer.parseInt(pinCode);
		
		
		try {
			
			//checking unique values email, phone, roll no, registration no
			boolean uniqueEmail = StudentSignUpService.isEmailUnique(email);
			boolean uniquePhone = StudentSignUpService.isPhoneUnique(phone);
			boolean uniqueRoll = StudentSignUpService.isRollUnique(roll);
			boolean uniqueReg = StudentSignUpService.isRegUnique(reg);
			
			if(uniqueEmail && uniquePhone && uniqueReg && uniqueRoll)
			{
				//every unique fields are unique
				try {
					boolean insertStatus = StudentSignUpService.insertStudentData(firstName, lastName, email, phone, roll, reg, department, dob, village, district, post, pin, password);
					if(insertStatus)
					{
						//registration confirmation page 
						HttpSession session = request.getSession();
						session.setAttribute("SessionUserEmail", email);
						response.sendRedirect("signUpConfirm.jsp");
						System.out.println("success");
					}
					else
					{
						//something went wrong page
						response.sendRedirect("somethingWentWrong.jsp");
						System.out.println("failed");
					}
				} catch (ClassNotFoundException | SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					response.sendRedirect("somethingWentWrong.jsp");
				}
			}
			else
			{
				Cookie[] ck = new Cookie[16];
				
				if(!uniqueEmail)
					ck[12] = new Cookie("emailCheck", "1");
				else
					ck[12] = new Cookie("emailCheck", "0");
				
				if(!uniquePhone)
					ck[13] = new Cookie("phoneCheck", "1");
				else
					ck[13] = new Cookie("phoneCheck", "0");
				
				if(!uniqueReg)
					ck[14] = new Cookie("regCheck", "1");
				else
					ck[14] = new Cookie("regCheck", "0");
				
				if(!uniqueRoll)
					ck[15] = new Cookie("rollCheck", "1");
				else
					ck[15] = new Cookie("rollCheck", "0");
				
				
				ck[0] = new Cookie("email", email);
				ck[1] = new Cookie("phone", phone);
				ck[2] = new Cookie("reg", reg);
				ck[3] = new Cookie("roll", roll);
				ck[4] = new Cookie("firstName", firstName);
				ck[5] = new Cookie("lastName", lastName);
				String dept = URLEncoder.encode(department, "UTF-8");
				ck[6] = new Cookie("department", dept);
				ck[7] = new Cookie("dob", dob);
				ck[8] = new Cookie("village", village);
				ck[9] = new Cookie("district", district);
				ck[10] = new Cookie("post", post);
				
				String pinStr = Integer.toString(pin);
				ck[11] = new Cookie("pin", pinStr);
				
				for(int i=0;i<16;i++)
				{
					ck[i].setMaxAge(3);
					response.addCookie(ck[i]);
				}
				response.sendRedirect("studentRegister.jsp");
			}
		} catch (ClassNotFoundException | SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}
}