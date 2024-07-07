package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class ForgotPassService {
	
	public static boolean validateForgotPass(String email, String dob) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();

		int type = CommonServices.UserType(email);
		PreparedStatement psmt;
		
		// admin = 1; teacher = 2; librarian = 3; student = 4
		if(type==4)
			psmt = con.prepareStatement(QueryInterface.forgotPass("STUDENTS", "SID"));
		
		else if(type == 3) //librarian
			psmt = con.prepareStatement(QueryInterface.forgotPass("LIBRARIAN", "LID"));
		
		else if(type == 2) //teacher
			psmt = con.prepareStatement(QueryInterface.forgotPass("TEACHERS", "TID"));
		
		else
			return false;
		
		psmt.setString(1, email);
		psmt.setString(2, dob);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 1)
			return true;
		else
			return false;
	}
	
	public static boolean changePassword(String email, String newPass) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.changePassQuery);
		psmt.setString(1, newPass);
		psmt.setString(2, email);
		
		System.out.println(newPass+"\t"+email);
		int updateStatus = psmt.executeUpdate();
		
		con.close();
		
		if(updateStatus == 1)
			return true;
		else
			return false;
	}
}
