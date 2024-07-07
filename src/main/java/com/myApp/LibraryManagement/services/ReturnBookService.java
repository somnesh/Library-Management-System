package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class ReturnBookService {

	public static boolean ReturnBook(String recordId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.returnBookQuery);
		psmt.setString(1, recordId);
		
		int check = psmt.executeUpdate();
		con.close();
		
		if(check == 1)
			return true;
		else
			return false;
	}
}
