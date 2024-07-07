package com.myApp.LibraryManagement.services;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SearchServices {
	
	public static ResultSet getNotBorrowedBookInfo(String name, String email)
	{
		ResultSet rs=null;
		String tid,sid;
		try {
			Connection con = DbImplementation.dbConnect();
			PreparedStatement psmt = con.prepareStatement(QueryInterface.searchFormNotBorrowedBookInfoQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			psmt.setString(1, "%"+name+"%");
			psmt.setString(2, "%"+name+"%");
			
			int userType = CommonServices.UserType(email); // admin = 1; teacher = 2; librarian = 3; student = 4
			if(userType == 2)
			{
				tid = CommonServices.getTeacherId(email);
				psmt.setString(3, null);
				psmt.setString(4, tid);
			}
			else if(userType == 4)
			{
				sid = CommonServices.getStudentId(email);
				psmt.setString(3, sid);
				psmt.setString(4, null);
			}
			else 
			{
				psmt.setString(3, null);
				psmt.setString(4, null);
			}
			
			rs = psmt.executeQuery();

		} 
		catch (ClassNotFoundException | SQLException e) 
		{
			e.printStackTrace();
		}
		return rs;
	}
	
	public static ResultSet getAlreadyBorrowedBookInfo(String name, String email)
	{
		ResultSet rs=null;
		String tid,sid;
		try {
			Connection con = DbImplementation.dbConnect();
			PreparedStatement psmt = con.prepareStatement(QueryInterface.searchFormAlreadyBorrowedBookInfoQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			psmt.setString(1, "%"+name+"%");
			
			int userType = CommonServices.UserType(email); // admin = 1; teacher = 2; librarian = 3; student = 4
			if(userType == 2)
			{
				tid = CommonServices.getTeacherId(email);
				psmt.setString(2, null);
				psmt.setString(3, tid);
			}
			else if(userType == 4)
			{
				sid = CommonServices.getStudentId(email);
				psmt.setString(2, sid);
				psmt.setString(3, null);
			}
			else 
			{
				psmt.setString(2, null);
				psmt.setString(3, null);
			}
			rs = psmt.executeQuery();
		} 
		catch (ClassNotFoundException | SQLException e) 
		{
			e.printStackTrace();
		}
		return rs;
	}
	
	public static void sendResultSetSizeToServlet(int size, String path, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{	
		System.out.println("in sendResultSetSizeToServlet");
		request.setAttribute("size", size);
		RequestDispatcher rd = request.getRequestDispatcher(path);
		
		rd.forward(request, response);
		System.out.println("sendResultSetSizeToServlet : Response Forwarded");
	}
	
}
