package com.myApp.LibraryManagement.servletController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.myApp.LibraryManagement.services.AdvancedSearchServices;

@WebServlet("/AdvancedSearch")
/**
 * Servlet implementation class AdvancedSearch
 */
public class AdvancedSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdvancedSearch() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("\n\n\n In advanced search servlet");
		String bookName = request.getParameter("bookName");
        String author = request.getParameter("author");
        String department = request.getParameter("department");
        String edition = request.getParameter("edition");
        String publisher = request.getParameter("publisher");
		
        HttpSession session = request.getSession();
        String email = (String)session.getAttribute("SessionUserEmail");
        String bookDetails[] = new String[5];
        
        if(bookName==null)
        {
        	bookDetails = (String[])session.getAttribute("bookDetails");
        	bookName = bookDetails[0];
        	author = bookDetails[1];
        	department = bookDetails[2];
        	edition = bookDetails[3];
        	publisher = bookDetails[4];
        }
        else 
        {
	        bookDetails[0] = bookName;
	        bookDetails[1] = author;
	        bookDetails[2] = department;
	        bookDetails[3] = edition;
	        bookDetails[4] = publisher;
        }
        session.setAttribute("bookDetails", bookDetails);
        
        
        
        try {
			ResultSet rs2 = AdvancedSearchServices.getAlreadyBorrowedSearchResults(email, bookName, author, department, edition, publisher);
			ResultSet rs = AdvancedSearchServices.getNotBorrowedSearchResults(email, bookName, author, department, edition, publisher);
			
			ArrayList<ResultSet> rsObj = new ArrayList<ResultSet>();
			rsObj.add(rs);
			rsObj.add(rs2);
			
			request.setAttribute("results", rsObj);
			RequestDispatcher rd = request.getRequestDispatcher("advancedSearch.jsp");

			rd.forward(request, response);
			System.out.println("ResultSet object has been forwarded");
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block 
			e.printStackTrace();
			response.sendRedirect("somethingWentWrong.jsp");
		}
	}
}
