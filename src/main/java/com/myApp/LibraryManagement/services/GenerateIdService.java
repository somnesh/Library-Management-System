package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class GenerateIdService {
	
	public static String generateDepatmentId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("DEPT_ID", "DEPARTMENT"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String did = rs.getString(1);
		
		con.close();
		
		if(did == null)
			return "1";
		else
			return did;
	}
	
	public static String generateStudentId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("SID", "STUDENTS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String sid = rs.getString(1);
		
		con.close();
		
		if(sid == null)
			return "1";
		else
			return sid;
	}
	
	public static String generateTeacherId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("TID", "TEACHERS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String tid = rs.getString(1);
		
		con.close();
		
		if(tid == null)
			return "1";
		else
			return tid;
	}
	
	public static String generateLibrarianId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("LID", "LIBRARIAN"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String lid = rs.getString(1);
		
		con.close();
		
		if(lid == null)
			return "1";
		else
			return lid;
	}
	
	public static String generateBookId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("BID", "BOOKS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String bookId = rs.getString(1);
		
		con.close();
		
		if(bookId == null)
			return "1";
		else
			return bookId;
	}
	
	public static String generatePublisherId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("PID", "PUBLISHERS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String pId = rs.getString(1);
		
		con.close();
		
		if(pId == null)
			return "1";
		else
			return pId;
	}
	
	public static String generateRecordId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("recordId", "RECORDS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String rId = rs.getString(1);
		
		con.close();
		
		if(rId == null)
			return "1";
		else
			return rId;
	}
	
	public static String generateRequestBookId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("rid", "request_book"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String rid = rs.getString(1);
		
		con.close();
		
		if(rid==null)
			return "1";
		else
			return rid;
	}
}