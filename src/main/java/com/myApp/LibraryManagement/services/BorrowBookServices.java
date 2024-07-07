package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class BorrowBookServices {
	
	public static boolean insertBorrowBookDetailsForStudent(String email, String bookId) throws ClassNotFoundException, SQLException
	{
		String studentId = CommonServices.getStudentId(email);
		String recordId = GenerateIdService.generateRecordId();
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.recordsInsertQuery);
		
		String eventName = BorrowBookServices.startBorrowCountdown();
		
		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.dateOfReturn);
		psmt2.setString(1, "e"+eventName);
		
		
		ResultSet rs = psmt2.executeQuery();
		rs.next();
		
		System.out.println("\n\nStudent id in borrow book service = "+studentId);
		
		psmt.setString(1, recordId);
		psmt.setString(2, studentId);
		psmt.setString(3, null); // Teacher id
		psmt.setString(4, bookId);
		psmt.setString(5, rs.getString("Execute at"));
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean insertBorrowBookDetailsForTeacher(String email, String bookId) throws ClassNotFoundException, SQLException
	{
		String teacherId = CommonServices.getTeacherId(email);
		String recordId = GenerateIdService.generateRecordId();
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.recordsInsertQuery);
		
		String eventName = BorrowBookServices.startBorrowCountdown();
		
		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.dateOfReturn);
		psmt2.setString(1, "e"+eventName);
		
		
		ResultSet rs = psmt2.executeQuery();
		rs.next();
		
		psmt.setString(1, recordId);
		psmt.setString(2, null); //Student id
		psmt.setString(3, teacherId);
		psmt.setString(4, bookId);
		psmt.setString(5, rs.getString("Execute at"));
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static String startBorrowCountdown() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.generateEventName);
		ResultSet rs = psmt2.executeQuery();
		rs.next();
		String eventName = rs.getString(1);
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.borrowCountdown(eventName));
		
		String recordId = CommonServices.getRecordId();
		
		System.out.println("\n\n\nrecord id = "+recordId);
		if(recordId!=null)
			psmt.setString(1, recordId);
		else
			psmt.setString(1, "1");
		
		psmt.executeUpdate();
		
		con.close();
		
		return eventName;
	}
	
	public static boolean checkUniqueRecord(String email,int userType ,String bookId) throws SQLException, ClassNotFoundException
	{
		String sid = null, tid = null;
		
		if(userType == 2)	//teacher
			tid = CommonServices.getTeacherId(email);
		else if(userType == 4)	//student
			sid = CommonServices.getStudentId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.checkDuplicate(sid, tid, bookId));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check > 0)
			return false;
		else
			return true;
	}
	
	public static boolean limitCheck(String email) throws ClassNotFoundException, SQLException
	{
		String sid = CommonServices.getStudentId(email);
		String tid = CommonServices.getTeacherId(email);
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.countAlreadyBorrowedBookQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
   		psmt2.setString(1, sid);
   		psmt2.setString(2, tid);
   		
   		ResultSet rs2 = psmt2.executeQuery();
   		rs2.next();
		
		int borrowedBooks = rs2.getInt(1);
   		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getBorrowLimit);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
   		rs.next();
   		
   		int borrowLimit = rs.getInt(1);
   		
   		System.out.println("\nborrowedBooks = "+borrowedBooks+"\nborrowLimit = "+borrowLimit);
   		
   		con.close();
   		
   		if(borrowLimit > borrowedBooks)
   			return true;
   		else
   			return false;
	}
	
}
