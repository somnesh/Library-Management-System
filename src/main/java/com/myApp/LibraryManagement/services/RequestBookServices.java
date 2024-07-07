package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class RequestBookServices {

	public static boolean isbookAlreadyExists(String bookName, String author, String edition, String publisher) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.bookCheck);
		
		psmt.setString(1, bookName);
		psmt.setString(2, author);
		psmt.setString(3, edition);
		psmt.setString(4, publisher);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static String duplicateRequestBook(String bookName, String author, String edition, String publisher) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.duplicateRequest);

		psmt.setString(1, bookName);
		psmt.setString(2, author);
		psmt.setString(3, edition);
		psmt.setString(4, publisher);
		
		ResultSet rs = psmt.executeQuery();
		if(rs.next())		
		{
			String rid = rs.getString(1);
			con.close();
			
			return rid;
		}
		else
		{
			con.close();
			return null;
		}
	}
	
	public static boolean insertDataRequestBook(String email, String bookName, String author, String edition, String publisher) throws ClassNotFoundException, SQLException
	{
		String isDuplicate = RequestBookServices.duplicateRequestBook(bookName, author, edition, publisher);
		String rid=null;
		
		String sid = CommonServices.getStudentId(email);
		String tid = CommonServices.getTeacherId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.insertRequestBook);
		
		if(isDuplicate==null)
		{
			rid = GenerateIdService.generateRequestBookId();
			psmt.setString(1, rid);
		}
		else
			psmt.setString(1, isDuplicate);

		psmt.setString(2, sid);
		psmt.setString(3, tid);
		psmt.setString(4, bookName);
		psmt.setString(5, author);
		psmt.setString(6, edition);
		psmt.setString(7, publisher);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean duplicateRequestFromSameUser(String email, String bookName, String author, String edition, String publisher) throws ClassNotFoundException, SQLException
	{
		String sid = CommonServices.getStudentId(email);
		String tid = CommonServices.getTeacherId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.duplicateRequest+"and(sid = "+sid+" or tid ="+tid+" )");
		
		psmt.setString(1, bookName);
		psmt.setString(2, author);
		psmt.setString(3, edition);
		psmt.setString(4, publisher);
		
		ResultSet rs = psmt.executeQuery();
		if(rs.next())
		{
			con.close();
			return false;
		}
		else
		{
			con.close();
			return true;
		}
	}
	
	public static ResultSet requestedBooks(String email) throws ClassNotFoundException, SQLException 
	{
		String sid = CommonServices.getStudentId(email);
		String tid = CommonServices.getTeacherId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.requestedBooks+" where (sid = ? or tid  = ?)",ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		
		psmt.setString(1, sid);
		psmt.setString(2, tid);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static boolean cancelRequest(String email, String rid) throws ClassNotFoundException, SQLException
	{
		String sid = CommonServices.getStudentId(email);
		String tid = CommonServices.getTeacherId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.cancelRequestQuery);
		
		psmt.setString(1, rid);
		psmt.setString(2, sid);
		psmt.setString(3, tid);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean deleteRequest(String rid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deleteRequestQuery);
		
		psmt.setString(1, rid);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static ResultSet requestedBooks() throws ClassNotFoundException, SQLException 
	{
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.distinctRequestBooks,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static ResultSet studentRequests(String rid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.studentRequests,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		psmt.setString(1, rid);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static ResultSet teacherRequests(String rid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.teacherRequests,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		psmt.setString(1, rid);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static ResultSet getRequestedBookDetails(String rid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.requestedBookDetails);
		psmt.setString(1, rid);
		
		ResultSet rs = psmt.executeQuery();
		
		return rs;
	}
	
	public static boolean requestGranted(String rid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		//Granting request
		PreparedStatement psmt = con.prepareStatement(QueryInterface.grantRequest);
		psmt.setString(1, rid);
		
		int check = psmt.executeUpdate();
		System.out.println("\n\n======================== Debug ====================\n\n check : "+check);
		if(check == 1)
		{
			
			//Creating delete event for granted request
			PreparedStatement psmt2 = con.prepareStatement(QueryInterface.generateEventName);
			
			ResultSet rs = psmt2.executeQuery();
			rs.next();
			
			//Event name
			String event = rs.getString(1);
			System.out.println("event name : "+event);
			//Deleting Event
			PreparedStatement psmt3 = con.prepareStatement(QueryInterface.requestDeleteCountdown(event));
			psmt3.setString(1, rid);
			
			int status = psmt3.executeUpdate();
			System.out.println("status : "+status);
			con.close();
			
			if(status == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else 
		{
			con.close();
			return false;
		}
	}
}
