package com.myApp.LibraryManagement.dbImplementation;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.myApp.LibraryManagement.interfaces.DbProperties;

public class DbImplementation {
	//Loading Driver
	public static void loadDriver() throws ClassNotFoundException
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
	}
	
	//Database connection
	public static Connection dbConnect() throws ClassNotFoundException, SQLException
	{
		loadDriver();
		Connection con = DriverManager.getConnection(DbProperties.url+DbProperties.dbName,DbProperties.username,DbProperties.password);
		return con;
	}
}
