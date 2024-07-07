package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class LoginService {

	public static boolean ValidateLogin(String email, String password) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.loginValidate);
		psmt.setString(1, email);
		psmt.setString(2, password);
		System.out.println(psmt.toString());
		ResultSet rs = psmt.executeQuery();
//		rs.next();
		
//		int check = rs.getInt(1);
//		con.close();
//		if(check == 1)
		if(rs.next())
			return true;
		else
			return false;
	}
}
