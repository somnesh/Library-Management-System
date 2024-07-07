package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class UpdateProfileService {

	public static boolean UpdateStudentData(String firstName, String lastName, String email, String phone, String dob, String village, String district, String post, int pin) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		System.out.println("\n\nEmail in UpdateStudentData : "+email);
		//generating student id
		String sid = CommonServices.getStudentId(email);
		
		//inserting all values
		PreparedStatement ps = con.prepareStatement(QueryInterface.updateProfileDetails("SID","students"));
		
		ps.setString(1, firstName);
		ps.setString(2, lastName);
		ps.setString(3, dob);
		ps.setString(4, phone);

		ps.setString(5, village);
		ps.setString(6, post);
		ps.setString(7, district);
		ps.setInt(8, pin);
		ps.setString(9, sid);
		
		int status = ps.executeUpdate();
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean UpdateTeacherData(String firstName, String lastName, String email, String phone, String dob, String village, String district, String post, int pin) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		//generating student id
		String tid = CommonServices.getTeacherId(email);
		
		//inserting all values
		PreparedStatement ps = con.prepareStatement(QueryInterface.updateProfileDetails("TID","teachers"));
		
		ps.setString(1, firstName);
		ps.setString(2, lastName);
		ps.setString(3, dob);
		ps.setString(4, phone);

		ps.setString(5, village);
		ps.setString(6, post);
		ps.setString(7, district);
		ps.setInt(8, pin);
		ps.setString(9, tid);
		
		int status = ps.executeUpdate();
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean UpdateLibrarianData(String firstName, String lastName, String email, String phone, String dob, String village, String district, String post, int pin) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		//generating student id
		String tid = CommonServices.getTeacherId(email);
		
		//inserting all values
		PreparedStatement ps = con.prepareStatement(QueryInterface.updateProfileDetails("LID","librarian"));
		
		ps.setString(1, firstName);
		ps.setString(2, lastName);
		ps.setString(3, dob);
		ps.setString(4, phone);

		ps.setString(5, village);
		ps.setString(6, post);
		ps.setString(7, district);
		ps.setInt(8, pin);
		ps.setString(9, tid);
		
		int status = ps.executeUpdate();
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean isPhoneUnique( String tableName, String idField, String phone, String id) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniquePhone(tableName,idField));
		psmt.setString(1, phone);
		psmt.setString(2, id);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
				
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
}
