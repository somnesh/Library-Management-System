package com.myApp.LibraryManagement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class LibraryManagement {

	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		
			Connection con = DbImplementation.dbConnect();
			PreparedStatement psmt = con.prepareStatement(QueryInterface.notifyNewBookRequest);
			
			ResultSet rs = psmt.executeQuery();
			if(rs.next())
				System.out.println(rs.getBoolean("a_notify"));
		
	}
}