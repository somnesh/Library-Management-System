package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class AdvancedSearchServices {
	
	public static ResultSet getAlreadyBorrowedSearchResults(String email,String bookName, String author, String department, String edition, String publisher) throws SQLException, ClassNotFoundException
	{
		String sid =null,tid=null;
		
		int userType = CommonServices.UserType(email);
		if(userType == 2) //teacher
			tid = CommonServices.getTeacherId(email);
		else if(userType == 4) //student
			sid = CommonServices.getStudentId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.advancedSearchAlreadyBorrowedBookInfo(sid, tid),ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		psmt.setString(1,"%"+bookName+"%");
		psmt.setString(2, "%"+author+"%");
		
		String deptId = CommonServices.getDepartmentId(department);
		
		psmt.setString(3, deptId); //dept_id
		psmt.setString(4, edition);
		psmt.setString(5, publisher);
		
		ResultSet rs = psmt.executeQuery();

		return rs;
	}
	
	public static ResultSet getNotBorrowedSearchResults(String email,String bookName, String author, String department, String edition, String publisher) throws SQLException, ClassNotFoundException
	{
		String sid =null,tid=null;
		
		int userType = CommonServices.UserType(email);
		if(userType == 2) //teacher
			tid = CommonServices.getTeacherId(email);
		else if(userType == 4) //student
			sid = CommonServices.getStudentId(email);
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.advancedSearchNotBorrowedBookInfo(sid, tid),ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		psmt.setString(1,"%"+bookName+"%");
		psmt.setString(2, "%"+author+"%");
		
		String deptId = CommonServices.getDepartmentId(department);
		
		psmt.setString(3, deptId); //dept_id
		psmt.setString(4, edition);
		psmt.setString(5, publisher);
		psmt.setString(6,"%"+bookName+"%");
		
		ResultSet rs = psmt.executeQuery();

		return rs;
	}
	
}
