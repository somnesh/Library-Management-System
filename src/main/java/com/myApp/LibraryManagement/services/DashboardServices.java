package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class DashboardServices {
	
	public static ResultSet getUserDetails(String email)
	{
		ResultSet rs=null;
		try {
			Connection con = DbImplementation.dbConnect();
			
			PreparedStatement ps = con.prepareStatement(QueryInterface.userType);
			ps.setString(1, email);
			ResultSet rs1 = ps.executeQuery();
			rs1.next();
			int type = rs1.getInt(1); // admin = 1; teacher = 2; librarian = 3; student = 4
			System.out.println(type);
			PreparedStatement psmt=null;
			if(type == 2)
				psmt = con.prepareStatement(QueryInterface.getTeacherDetails);
			else if(type == 3)
				psmt = con.prepareStatement(QueryInterface.getLibrarianDetails);
			else if(type == 4)
				psmt = con.prepareStatement(QueryInterface.getStudentsDetails);
			else
				psmt = con.prepareStatement(QueryInterface.userType);
			psmt.setString(1, email);
			rs = psmt.executeQuery();
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	public static ResultSet notifyBookRequest() throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.notifyNewBookRequest);
		
		ResultSet rs = psmt.executeQuery();
//		rs.next();
		return rs;
	}
	
	public static void notifyDone(String rid, int userType) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.notifyDone);
		
		ResultSet rs = notifyBookRequest();
		rs.next();
		if(userType==1)
		{
			psmt.setBoolean(1, false);
			psmt.setBoolean(2, rs.getBoolean("l_notify"));
		}
		else
		{
			psmt.setBoolean(1, rs.getBoolean("a_notify"));
			psmt.setBoolean(2, false);
		}
		
		psmt.executeUpdate();
		
		con.close();
	}
}
