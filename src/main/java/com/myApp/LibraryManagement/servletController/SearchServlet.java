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
import java.util.ArrayList;

import com.myApp.LibraryManagement.services.SearchServices;

/**
 * Servlet implementation class SearchServlet
 */ 
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String bookName = request.getParameter("bName"); //Searched book name
		System.out.println("search Servlet book name : "+bookName);
		if(bookName==null)
			bookName = (String) request.getAttribute("bName");
		System.out.println("bookName after getAttribute : "+bookName);
		
		HttpSession session = request.getSession(); // creating a session object
		session.setAttribute("bName", bookName);
		
		bookName = (String)session.getAttribute("bName");
		System.out.println("search Servlet book name session : "+bookName);
		String sessionEmail = (String)session.getAttribute("SessionUserEmail");
		
		System.out.println("search servlet : bookName added in session");
		
		ResultSet rs = SearchServices.getNotBorrowedBookInfo(bookName, sessionEmail);
		ResultSet rs2 = SearchServices.getAlreadyBorrowedBookInfo(bookName, sessionEmail);
		
		ArrayList<ResultSet> rsObj = new ArrayList<ResultSet>();
		rsObj.add(rs);
		rsObj.add(rs2);
		
		request.setAttribute("results", rsObj);
		RequestDispatcher rd = request.getRequestDispatcher("search.jsp");

		rd.forward(request, response);
		System.out.println("search servlet : ResultSet object has been forwarded");
	}

}
