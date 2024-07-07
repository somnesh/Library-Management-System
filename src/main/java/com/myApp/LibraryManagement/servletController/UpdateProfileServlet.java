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
import com.myApp.LibraryManagement.services.UpdateProfileService;

@WebServlet("/UpdateProfile")
/**
 * Servlet implementation class UpdateProfileServlet
 */
public class UpdateProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateProfileServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		String email = (String)session.getAttribute("SessionUserEmail");
		
		
		
		//getting form values 
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String phone = request.getParameter("phone");
		String dob = request.getParameter("dob");
		String village = request.getParameter("village");
		String district = request.getParameter("district");
		String post = request.getParameter("post");
		String pinCode = request.getParameter("pin");
		
		//type casting variable string to integer 
		int pin = Integer.parseInt(pinCode);
		
		try {
				
			int userType = CommonServices.UserType(email); // admin = 1; teacher = 2; librarian = 3; student = 4
			
			boolean uniquePhone = false, insertStatus = false;
			String id=null;
			
			//checking unique value 
			if(userType==4) //student
			{
				id = CommonServices.getStudentId(email);
				uniquePhone = UpdateProfileService.isPhoneUnique("students", "sid", phone, id);
				insertStatus = UpdateProfileService.UpdateStudentData(firstName, lastName, email, phone, dob, village, district, post, pin);
			}
			
			if(userType==3) //librarian
			{
				id = CommonServices.getLibrarianId(email);
				uniquePhone = UpdateProfileService.isPhoneUnique("librarian", "lid", phone, id);
				insertStatus = UpdateProfileService.UpdateLibrarianData(firstName, lastName, email, phone, dob, village, district, post, pin);
			}
			
			if(userType==2) //teacher
			{
				id = CommonServices.getTeacherId(email);
				uniquePhone = UpdateProfileService.isPhoneUnique("teachers", "tid", phone, id);
				insertStatus = UpdateProfileService.UpdateTeacherData(firstName, lastName, email, phone, dob, village, district, post, pin);
			}
			
			if(uniquePhone)
			{
				//every unique fields are unique
				if(insertStatus)
				{
					//registration confirmation page 
					session.setAttribute("SessionUserEmail", email);
					Cookie ck = new Cookie("status", "1");
					ck.setMaxAge(3);
					response.addCookie(ck);
					response.sendRedirect("updateProfile.jsp");
					System.out.println("success");
				}
				else
				{
					//something went wrong page
					response.sendRedirect("somethingWentWrong.jsp");
					Cookie ck = new Cookie("status", "0");
					ck.setMaxAge(3);
					response.addCookie(ck);
					System.out.println("failed");
				}
			}
			else
			{
				//phone number is not unique
				Cookie ck2 = new Cookie("status", "2");
				ck2.setMaxAge(3);
				response.addCookie(ck2);
				
				
				Cookie[] ck = new Cookie[9];
				
				if(!uniquePhone)
					ck[8] = new Cookie("phoneCheck", "1");
				else
					ck[8] = new Cookie("phoneCheck", "0");
				
				ck[0] = new Cookie("phone", phone);

				ck[1] = new Cookie("firstName", firstName);
				ck[2] = new Cookie("lastName", lastName);

				ck[3] = new Cookie("dob", dob);
				ck[4] = new Cookie("village", village);
				ck[5] = new Cookie("district", district);
				ck[6] = new Cookie("post", post);
				
				String pinStr = Integer.toString(pin);
				ck[7] = new Cookie("pin", pinStr);
				
				for(int i=0;i<9;i++)
				{
					ck[i].setMaxAge(3);
					response.addCookie(ck[i]);
				}
				response.sendRedirect("updateProfile.jsp");
			}
		} catch (ClassNotFoundException | SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
