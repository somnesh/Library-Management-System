package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

import com.myApp.LibraryManagement.services.BorrowBookServices;
import com.myApp.LibraryManagement.services.CommonServices;

@WebServlet("/BorrowBook")
/**
 * Servlet implementation class BorrowBookServlet
 */
public class BorrowBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BorrowBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String bookId = request.getParameter("book");
		
		RequestDispatcher rd;
		
		System.out.println("In borrowBook Servlet = "+ bookId);
		
		HttpSession session = request.getSession();
		
		String advancedSearch =  (String)session.getAttribute("advancedSearch"); //if not null then it is advanced search
		String dashboard =  (String)session.getAttribute("dashboard");
		
		String userEmail = (String)session.getAttribute("SessionUserEmail");
		String bookName = (String)session.getAttribute("bName");
		
		System.out.println("borrowBook Servlet : User email : "+userEmail);
		System.out.println("borrowBook Servlet : Book name from session : "+bookName);
		System.out.println("\n\n\nCheck = "+advancedSearch);
		
		try {
			
			boolean isActive = CommonServices.isUserActive(userEmail);
			if(isActive)
			{
				boolean checkLimit = BorrowBookServices.limitCheck(userEmail);
				if(checkLimit)
				{
					//user type
					int userType = CommonServices.UserType(userEmail);
					// admin = 1; teacher = 2; librarian = 3; student = 4
					
					if(BorrowBookServices.checkUniqueRecord(userEmail, userType, bookId))
					{
						System.out.println("\nif 1 \n");
						if(userType==4)
						{
							boolean insertCheck = BorrowBookServices.insertBorrowBookDetailsForStudent(userEmail, bookId);
							if(insertCheck)
							{
								System.out.println("\nif 2 \n");
								
								
								request.setAttribute("bName", bookName);
								
								if(advancedSearch!=null)
								{
									request.setAttribute("advancedSearch", null);
									rd = request.getRequestDispatcher("AdvancedSearch");	
									rd.forward(request, response);
								}
								else if(dashboard!=null)
								{
									request.setAttribute("dashboard", null);									
									response.sendRedirect("dashboard.jsp");
								}
								else
								{
									rd = request.getRequestDispatcher("SearchServlet");
									rd.forward(request, response);
								}
								System.out.println("borrowBook Servlet : book name added in borrow servlet");
								
							}
							else
							{
								response.sendRedirect("somethingWentWrong.jsp");
							}
						}
						else if(userType == 2)
						{
							System.out.println("\n else if 1 \n");
							boolean insertCheck = BorrowBookServices.insertBorrowBookDetailsForTeacher(userEmail, bookId);
							if(insertCheck)
							{
								
								String bookDetails[] = (String[])session.getAttribute("bookDetails");
								session.setAttribute("bookDetails", bookDetails);
								
								request.setAttribute("bName", bookName);
								
								System.out.println("set attribute");
								
								if(advancedSearch!=null)
								{
									rd = request.getRequestDispatcher("AdvancedSearch");
									
									rd.forward(request, response);
									System.out.println("borrowBook Servlet : rd forward");
								}
								else if(dashboard!=null)
									response.sendRedirect("dashboard.jsp");
								else
								{
									rd = request.getRequestDispatcher("SearchServlet");
								
									rd.forward(request, response);
									System.out.println("borrowBook Servlet : rd forward");
								}
							}
							else
							{
								response.sendRedirect("somethingWentWrong.jsp");
								System.out.println("oh shit");
							}
						}
						else
						{
							response.sendRedirect("badRequest.jsp");
						}
					}
					else
					{
						response.sendRedirect("badRequest.jsp");
					}
				}
				else
				{
					Cookie ck = null;
					if(advancedSearch!=null)
					{
						ck = new Cookie("status", "20");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("advancedSearch.jsp");
					}
					else if(dashboard!=null)
					{
						ck = new Cookie("status", "20");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("dashboard.jsp");
					}
					else
					{
						ck = new Cookie("status", "20");
						ck.setMaxAge(3);
						response.addCookie(ck);
						response.sendRedirect("search.jsp");
					}
				}
			}
			else
			{
				response.sendRedirect("badRequest.jsp");
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}

}
