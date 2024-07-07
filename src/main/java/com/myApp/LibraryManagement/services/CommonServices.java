package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class CommonServices {
	
	public static boolean isUserActive(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.isUserActiveQuery);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		boolean check =rs.getBoolean(1);
		con.close();
		
		if(check)
			return true;
		else
			return false;
	}
	
	public static int UserType(String email) throws ClassNotFoundException, SQLException
	{
		int type=0;

		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.userType);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		if(rs.getInt(1) == 1)
			type = 1; //admin
		
		else if(rs.getInt(1) == 2)
			type = 2; //teacher
		
		else if(rs.getInt(1) == 3)
			type = 3; //librarian
		
		else
			type = 4; //student
		
		con.close();
		
		return type;
	}
	
	public static String getStudentId(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getStudentsDetails);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		
		if(rs.next())
		{
			String studentId = rs.getString("sid");
			
			con.close();
			return studentId;
		}
		else
		{
			con.close();			
			return null;
		}
	}
	
	public static String getTeacherId(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getTeacherDetails);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		
		if(rs.next())
		{
			String teacherId = rs.getString("tid");
			
			con.close();
			
			return teacherId;
		}
		else
		{
			con.close();
			return null;
		}
	}
	
	public static String getLibrarianId(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getLibrarianDetails);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String librarianId = rs.getString("tid");
		con.close();
		
		return librarianId;
	}
	
	public static String getRecordId() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.generateId("recordId", "RECORDS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String recordId = rs.getString(1);
		con.close();
		
		return recordId;
	}
	
	public static String getDepartmentId(String department) throws SQLException, ClassNotFoundException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getDepartmentId);
		psmt.setString(1, department);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		//retrieving department id from department name
		String departmentId = rs.getString("dept_Id");
		con.close();
		
		return departmentId;
	}
	
	public static String getPublisherId(String publisher) throws SQLException, ClassNotFoundException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt2 = con.prepareStatement(QueryInterface.getPublisherId);
		System.out.println("publisher name : "+publisher);
		psmt2.setString(1, publisher);
		ResultSet rs2 = psmt2.executeQuery();
		rs2.next();
		
		//retrieving publisher id from publisher name
		String publisherId = rs2.getString("pid");
		con.close();
		
		return publisherId;
	}
	
	public static int getResultsetSize(ResultSet rs) throws SQLException
	{
		int size=0;
		while(rs.next())
		{
			size++; //row count in the Resultset
		}
		return size;
	}
	
	public static ResultSet getPublishersNames() throws SQLException, ClassNotFoundException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getPublishersNamesQuery);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static ResultSet getDepartmentNames() throws SQLException, ClassNotFoundException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getDepartmentNamesQuery);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static int noOfDeparments() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("DEPARTMENT"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfDeparment = rs.getInt(1);
		
		con.close();
		
		return noOfDeparment;
	}
	
	public static int noOfBooks() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("BOOKS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfBooks = rs.getInt(1);
		
		con.close();
		
		return noOfBooks;
	}
	
	public static int noOfPublishers() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("PUBLISHERS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfPublishers = rs.getInt(1);
		
		con.close();
		
		return noOfPublishers;
	}
	
	public static int noOfUsers() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("USERS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfUsers = rs.getInt(1);
		
		con.close();
		
		return noOfUsers;
	}
	
	public static int noOfStudents() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("STUDENTS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfStudents = rs.getInt(1);
		
		con.close();
		
		return noOfStudents;
	}
	
	public static int noOfTeachers() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("TEACHERS"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfTeachers = rs.getInt(1);
		
		con.close();
		
		return noOfTeachers;
	}
	
	public static int noOfLibrarians() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.count("librarian"));
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int noOfTeachers = rs.getInt(1);
		
		con.close();
		
		return noOfTeachers;
	}
	
	public static String getStudentEmail(String sid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getUserEmailById("sid"));
		psmt.setString(1, sid);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String email = rs.getString(1);
		con.close();
		
		return email;
	}
	
	public static String getTeacherEmail(String tid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getUserEmailById("tid"));
		psmt.setString(1, tid);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String email = rs.getString(1);
		con.close();
		
		return email;
	}
	
	public static String getLibrarianEmail(String lid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getUserEmailById("lid"));
		psmt.setString(1, lid);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		String email = rs.getString(1);
		con.close();
		
		return email;
	}
	
	public static void commit(Connection con) throws ClassNotFoundException, SQLException
	{
//		con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement("COMMIT");
		
		psmt.executeUpdate();
		
	}
	
	public static void rollback(Connection con) throws ClassNotFoundException, SQLException
	{
//		con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement("ROLLBACK");
		
		psmt.executeUpdate();
		
	}
	
	
	/**
	 * Takes a boolean value where <p><b>0 = auto commit off</b> and <b>1 = auto commit on</b></p>
	 * 
	 * 
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public static void setAutoCommit(Connection con,boolean onOff) throws ClassNotFoundException, SQLException
	{
//		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement("SET autocommit = "+onOff);
		
		psmt.executeUpdate();
		
	}
	
	public static ResultSet getDepartmentDetails(String id) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.DepartmentsDetails);
		psmt.setString(1, id);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
	
	public static ResultSet getPublisherDetails(String id) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.PublisherDetails);
		psmt.setString(1, id);
		
		ResultSet rs = psmt.executeQuery();
		return rs;
	}
}
