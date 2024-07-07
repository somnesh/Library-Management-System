package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class StudentSignUpService {
	//checking unique fields
	public static boolean isEmailUnique(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueEmail);
		psmt.setString(1, email);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		System.out.println("Email = "+rs.getInt(1));
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isPhoneUnique(String phone) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueStudent("PHONE"));
		psmt.setString(1, phone);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isRollUnique(String roll) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueStudent("ROLL_NO"));
		psmt.setString(1, roll);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isRegUnique(String reg) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueStudent("REG_NO"));
		psmt.setString(1, reg);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	//inserting data into the database
	public static boolean insertStudentData(String firstName, String lastName, String email, String phone, String roll, String reg, String department, String dob, String village, String district, String post, int pin, String password) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		//generating student id
		String sid = GenerateIdService.generateStudentId();
	
		//getting department id
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getDepartmentId);
		
		psmt.setString(1, department);
		
		ResultSet rs2 = psmt.executeQuery();
		rs2.next();
		
		String deptId = rs2.getString(1);
		
		//inserting all values
		PreparedStatement ps = con.prepareStatement(QueryInterface.studentInsertQuery);
		
		ps.setString(1, sid);
		ps.setString(2, deptId);
		ps.setString(3, firstName);
		ps.setString(4, lastName);
		ps.setString(5, dob);
		ps.setString(6, phone);
		ps.setString(7, roll);
		ps.setString(8, reg);
		ps.setString(9, village);
		ps.setString(10, post);
		ps.setString(11, district);
		ps.setInt(12, pin);
		
		int status = ps.executeUpdate();
		if(status == 1)
		{
			PreparedStatement psmt2 = con.prepareStatement(QueryInterface.userEmailPassInsertQuery);
			// admin = 1; teacher = 2; librarian = 3; student = 4
			
			psmt2.setInt(1, 4);
			psmt2.setString(2, null);
			psmt2.setString(3, sid);
			psmt2.setString(4, null);
			psmt2.setString(5, email);
			psmt2.setString(6, password);
			psmt2.setInt(7, 5);
			
			int insertCheck = psmt2.executeUpdate();
			con.close();
			
			if(insertCheck == 1)
				return true;
			else
				return false;
		}
		else
		{
			con.close();
			return false;
		}
	}
}
