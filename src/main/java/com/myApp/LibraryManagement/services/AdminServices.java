package com.myApp.LibraryManagement.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.myApp.LibraryManagement.dbImplementation.DbImplementation;
import com.myApp.LibraryManagement.interfaces.QueryInterface;

public class AdminServices {
	public static boolean addDepatment(String deptId, String deptName) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.departmentInsertQuery);
		psmt.setString(1, deptId);
		psmt.setString(2, deptName);
		
		int check = psmt.executeUpdate();
		con.close();
		
		if(check==1)
			return true;
		else
			return false;
	}
	
	public static boolean isDepartmentUnique(String dName) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueDepartment);
		psmt.setString(1, dName);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isEmailUnique(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueEmail);
		psmt.setString(1, email);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
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
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueTeacherPhone);
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
	
	public static boolean insertTeacherData(String firstName, String lastName, String email, String phone, String department, String dob, String village, String district, String post, String pin, String password) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		
		String tid = GenerateIdService.generateTeacherId();
		
		//getting department id
		PreparedStatement psmt = con.prepareStatement(QueryInterface.getDepartmentId);
		psmt.setString(1, department);
		
		ResultSet rs2 = psmt.executeQuery();
		rs2.next();
		
		String deptId = rs2.getString(1);
		
		PreparedStatement ps = con.prepareStatement(QueryInterface.teacherInsertQuery);
		
		ps.setString(1, tid);
		ps.setString(2, deptId);
		ps.setString(3, firstName);
		ps.setString(4, lastName);
		ps.setString(5, dob);
		ps.setString(6, phone);
		ps.setString(7, village);
		ps.setString(8, post);
		ps.setString(9, district);
		ps.setString(10, pin);
		
		int status = ps.executeUpdate();
		if(status == 1)
		{
			PreparedStatement psmt2 = con.prepareStatement(QueryInterface.userEmailPassInsertQuery);
			// admin = 1; teacher = 2; librarian = 3; student = 4
			
			psmt2.setInt(1, 2);
			psmt2.setString(2, tid);
			psmt2.setString(3, null);
			psmt2.setString(4, null);
			psmt2.setString(5, email);
			psmt2.setString(6, password);
			psmt2.setInt(7, 7);
			
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
	
	public static boolean insertLibrarianData(String firstName, String lastName, String email, String phone, String dob, String village, String district, String post, String pin, String password) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		
		String lid = GenerateIdService.generateLibrarianId();
		
		PreparedStatement ps = con.prepareStatement(QueryInterface.librarianInsertQuery);
		
		ps.setString(1, lid);
		ps.setString(2, firstName);
		ps.setString(3, lastName);
		ps.setString(4, dob);
		ps.setString(5, phone);
		ps.setString(6, village);
		ps.setString(7, post);
		ps.setString(8, district);
		ps.setString(9, pin);
		
		int status = ps.executeUpdate();
		if(status == 1)
		{
			PreparedStatement psmt2 = con.prepareStatement(QueryInterface.userEmailPassInsertQuery);
			// admin = 1; teacher = 2; librarian = 3; student = 4
			
			psmt2.setInt(1, 3);
			psmt2.setString(2, null);
			psmt2.setString(3, null);
			psmt2.setString(4, lid);
			psmt2.setString(5, email);
			psmt2.setString(6, password);
			psmt2.setString(7, null);
			
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
	
	public static boolean insertPublisherData(String pname) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.publisherInsertQuery);
		
		String pid = GenerateIdService.generatePublisherId();
		
		psmt.setString(1, pid);
		psmt.setString(2, pname);
		
		int insertCheck = psmt.executeUpdate();
		
		con.close();
		
		if(insertCheck == 1)
			return true;
		else
			return false;
	}
	
	public static boolean insertBookData(Connection con,String bookName, String author, String department, String edition, String yearOfPublishing, String publisher, String path) throws ClassNotFoundException, SQLException
	{
//		Connection con = DbImplementation.dbConnect();
		
		//retrieving department id from department name
		String departmentId = CommonServices.getDepartmentId(department);
		
		//retrieving publisher id from publisher name
		String publisherId = CommonServices.getPublisherId(publisher);
		
		//generating book id
		String bookId = GenerateIdService.generateBookId();
		
		PreparedStatement psmt3 = con.prepareStatement(QueryInterface.bookInsertQuery);
		psmt3.setString(1, bookId);
		psmt3.setString(2, publisherId);
		psmt3.setString(3, departmentId);
		psmt3.setString(4, bookName);
		psmt3.setString(5, yearOfPublishing);
		psmt3.setString(6, author);
		psmt3.setString(7, edition);
		psmt3.setString(8, path);
		
		int insertCheck = psmt3.executeUpdate();
		
//		con.close();
		
		if(insertCheck == 1)
			return true;
		else
			return false;
	}
	
	public static boolean isBookDuplicate(String bookName, String author, String edition) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.isDuplicateBookInfo);
		psmt.setString(1, bookName);
		psmt.setString(2, author);
		psmt.setString(3, edition);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isPublisherDuplicate(String pname) throws SQLException, ClassNotFoundException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.isDuplicatePublisher);
		psmt.setString(1, pname);
		
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static ResultSet getBookInfo(String bookId) throws ClassNotFoundException, SQLException
	{	
		Connection con = DbImplementation.dbConnect();
		PreparedStatement ps = con.prepareStatement(QueryInterface.getBookInfo);
		ps.setString(1, bookId);
		
		ResultSet rs = ps.executeQuery();
		return rs;
	}

	public static boolean UpdateBookData(String bookId, String bookName, String author, String department, String edition, String yearOfPublishing, String publisher) throws ClassNotFoundException, SQLException {
		
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.updateBookInfo);
		
		String departmentId = CommonServices.getDepartmentId(department);
		
		//retrieving publisher id from publisher name
		String publisherId = CommonServices.getPublisherId(publisher);
		
		psmt.setString(1, publisherId);
		psmt.setString(2, departmentId);
		psmt.setString(3, bookName);
		psmt.setString(4, yearOfPublishing);
		psmt.setString(5, author);
		psmt.setString(6, edition);
		psmt.setString(7, bookId);
		
		int insertCheck = psmt.executeUpdate();
		
		con.close();
		
		if(insertCheck == 1)
			return true;
		else
			return false;
	}
	
	public static boolean DeleteBook(String bookId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deleteBookQuery);
		psmt.setString(1, bookId);
		
		int check = psmt.executeUpdate();
		
		con.close();
		
		if(check == 1)
			return true;
		else
			return false;
	}
	
	public static boolean banUser(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.banUserQuery);
		psmt.setString(1, email);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean activateUser(String email) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.activateUserQuery);
		psmt.setString(1, email);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean setBorrowLimit(String email, String limit) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.setBorrowLimit);
		psmt.setString(1, limit);
		psmt.setString(2, email);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	/**
	 * Delete the user associated with the email from the <b>user table</b>
	 * 
	 * 
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public static boolean deleteUser(Connection con,String email) throws ClassNotFoundException, SQLException
	{		
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deleteUser);
		psmt.setString(1, email);
		
		int status = psmt.executeUpdate();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	/**
	 * Delete user details from specific table. That is, if the user is a student then delete from the student table.  
	 * 
	 * 
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public static boolean deleteUserDetails(Connection con,String id, String field, String table) throws ClassNotFoundException, SQLException
	{
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deleteUserDetails(field, table));
		psmt.setString(1, id);
		
		int status = psmt.executeUpdate();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean deleteDepartment(String deptId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deleteDepartmentQuery);
		psmt.setString(1, deptId);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean deletePublisher(String pId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.deletePublisherQuery);
		psmt.setString(1, pId);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean updateDepartment(String deptName, String deptId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.updateDepartment);
		psmt.setString(1, deptName);
		psmt.setString(2, deptId);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}
	
	public static boolean isDepartmentUnique(String dName, String deptId) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.validateUniqueDepartment+" and dept_id != "+deptId);
		psmt.setString(1, dName);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean isPublisherUnique(String pName, String pid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.isDuplicatePublisher+" and pid != "+pid);
		psmt.setString(1, pName);
		ResultSet rs = psmt.executeQuery();
		rs.next();
		
		int check = rs.getInt(1);
		con.close();
		
		if(check == 0)
			return true;
		else
			return false;
	}
	
	public static boolean updatePublisher(String pName, String pid) throws ClassNotFoundException, SQLException
	{
		Connection con = DbImplementation.dbConnect();
		PreparedStatement psmt = con.prepareStatement(QueryInterface.updatePublisher);
		psmt.setString(1, pName);
		psmt.setString(2, pid);
		
		int status = psmt.executeUpdate();
		
		con.close();
		
		if(status == 1)
			return true;
		else
			return false;
	}	
}
