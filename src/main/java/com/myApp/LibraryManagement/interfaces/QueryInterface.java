package com.myApp.LibraryManagement.interfaces;

public interface QueryInterface 
{	
	//****************************************** Login Validation ********************************************
	
	public final static String loginValidate = "SELECT COUNT(EMAIL) FROM USERS WHERE EMAIL = ? AND PASSWORD = ?";
	
	//******************************************** Insert Query **********************************************
	
	String studentInsertQuery = "INSERT INTO STUDENTS(SID, DEPT_ID, FIRST_NAME, LAST_NAME, DOB, "
			+ "PHONE, ROLL_NO, REG_NO, VILLAGE, POST, DISTRICT, PIN) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
	
	String teacherInsertQuery = "INSERT INTO TEACHERS(TID, DEPT_ID, FIRST_NAME, LAST_NAME, DOB, "
			+ "PHONE, VILLAGE, POST, DISTRICT, PIN) VALUES (?,?,?,?,?,?,?,?,?,?)";
	
	String librarianInsertQuery = "INSERT INTO LIBRARIAN(LID, FIRST_NAME, LAST_NAME, DOB, "
			+ "PHONE, VILLAGE, POST, DISTRICT, PIN) VALUES (?,?,?,?,?,?,?,?,?)";
	
	String userEmailPassInsertQuery = "INSERT INTO USERS(TYPE,TID,SID,LID,EMAIL,PASSWORD,BORROWLIMIT) VALUES(?,?,?,?,?,?,?)";
	
	String departmentInsertQuery = "INSERT INTO DEPARTMENT(DEPT_ID, DEPT_NAME) VALUES(?,?)";
	
	String bookInsertQuery = "INSERT INTO BOOKS(BID,PID,DEPT_ID,BOOKNAME,YEAROFPUBLISHING,AUTHOR,EDITION,BOOKPATH) "
			+ "VALUES(?,?,?,?,?,?,?,?)";
	
	String publisherInsertQuery = "INSERT INTO PUBLISHERS(PID,PNAME) VALUES(?,?)";
	
	String recordsInsertQuery = "INSERT INTO RECORDS(RECORDID, SID, TID, BID, DATE_OF_ISSUE, DATE_OF_RETURN) "
			+ "values(?,?,?,?,curdate(),?)";
	
	String insertRequestBook = "insert into request_book(rid, sid, tid, book_name, author, edition, publisher) values(?,?,?,?,?,?,?)";
	
	//************** Date of return ****************
	
	String dateOfReturn = "SHOW EVENTS FROM library_management WHERE NAME = ?";
	
	//********************* Type of the user **************************
	
	String userType = "SELECT TYPE FROM USERS WHERE EMAIL = ?";
	// admin = 1; teacher = 2; librarian = 3; student = 4
	
	//*********************************** Getting id's **********************************
	
	//Department id
	String getDepartmentId = "SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_NAME = ?";
	
	//Publisher id
	String getPublisherId = "SELECT PID FROM PUBLISHERS WHERE PNAME = ?";
	
	//*********************************** Generate ID *********************************
	
	public static String generateId(String id, String tName)
	{
		String generateIdQuery = "SELECT MAX("+id+")+1 FROM "+tName;
		
		return generateIdQuery;
	}
	
	
	//************************* Forgot Password User Validation ****************************
	public static String forgotPass(String tName,String id)
	{
		String forgotPassQuery = "SELECT COUNT(EMAIL) FROM "+tName+" A, USERS B "
				+ "WHERE B.EMAIL = ? AND A.DOB = ? AND A."+id+"=B."+id;
		
		return forgotPassQuery;
	}
	
	//Change User Password
	String changePassQuery = "UPDATE USERS SET PASSWORD = ? WHERE EMAIL = ?";
	
	/****************************** Validating Unique fields *********************************/
	
	String validateUniqueEmail = "SELECT COUNT(TYPE) FROM USERS WHERE EMAIL = ?";
	
	//DEPARTMENT
	String validateUniqueDepartment = "SELECT COUNT(DEPT_ID) FROM DEPARTMENT WHERE DEPT_NAME = ?";

	//STUDENT
	public static String validateUniqueStudent(String field)
	{
		String validateUniqueStudent = "SELECT COUNT(SID) FROM STUDENTS WHERE "+field+" = ?";
		
		return validateUniqueStudent;
	}
	
	//TEACHER 
	String validateUniqueTeacherPhone = "SELECT COUNT(TID) FROM TEACHERS WHERE PHONE = ?";
	
	//LIBRARIAN
	String validateUniqueLibrarianPhone = "SELECT COUNT(LID) FROM USERS WHERE PHONE_NUMBER = ?";
	
	//BOOKS 
	String isDuplicateBookInfo = "SELECT COUNT(BID) FROM BOOKS WHERE BOOKNAME = ? AND AUTHOR = ? AND EDITION = ?";
	
	//PUBLISHERS
	String isDuplicatePublisher = "SELECT COUNT(PID) FROM PUBLISHERS WHERE PNAME = ?";
	
	//update unique phone check
	public static String validateUniquePhone(String table, String id)
	{
		String validateUniquePhone = "SELECT COUNT(SID) FROM "+table+" WHERE phone = ? and "+id+" != ?";
		
		return validateUniquePhone;
	}
	
	public static String checkDuplicate(String sid,String tid, String bookId)
	{
		String checkRecord = "SELECT COUNT(RECORDID) FROM RECORDS WHERE (SID = "+sid+" OR TID = "+tid+") AND BID = "+bookId;
		return checkRecord;
	}
	
	//************************************ Get user details by email **************************************
	
	String getTeacherDetails = "SELECT * FROM TEACHERS A, USERS B, DEPARTMENT C WHERE B.EMAIL = ? AND A.TID = B.TID AND A.DEPT_ID = C.DEPT_ID";
	
	String getStudentsDetails = "SELECT * FROM STUDENTS A, USERS B, DEPARTMENT C WHERE B.EMAIL = ? AND A.SID = B.SID AND A.DEPT_ID = C.DEPT_ID";
	
	String getLibrarianDetails = "SELECT * FROM LIBRARIAN A, USERS B WHERE B.EMAIL = ? AND A.LID = B.LID";
	
	String getUserDetails = "SELECT * FROM USERS WHERE EMAIL = ?";
	
	//*************************************** details **********************************
	
	String allStudentsDetails ="SELECT * FROM STUDENTS A, USERS B, DEPARTMENT C WHERE A.SID = B.SID AND A.DEPT_ID = C.DEPT_ID";
	
	String allTeachersDetails ="SELECT * FROM TEACHERS A, USERS B, DEPARTMENT C WHERE A.TID = B.TID AND A.DEPT_ID = C.DEPT_ID";
	
	String allLibrariansDetails = "SELECT * FROM librarian A, USERS B WHERE A.LID = B.LID";
	
	String allDepartmentsDetails = "SELECT * FROM department";
	
	String allBooksDetails = "SELECT * FROM books a, publishers b, department c where a.pid = b.pid and c.Dept_Id = a.Dept_Id order by bid desc";
	
	String allPublisherDetails = "SELECT * FROM publishers";
	
	String DepartmentsDetails = "SELECT * FROM department where Dept_Id = ?";
	
	String PublisherDetails = "SELECT * FROM publishers where pid = ?";
	
	//********************************************** Searching Books **********************************************
	
	public final static String searchFormAlreadyBorrowedBookInfoQuery = "SELECT * FROM BOOKS a, publishers b, records c "
			+ "WHERE a.bookName like ? and (c.sid = ? or c.tid = ?) and a.pid = b.pid and a.bid = c.bid;";
	
	String searchFormNotBorrowedBookInfoQuery = "SELECT * FROM BOOKS a, publishers b "
			+ "WHERE a.bookName like ? and a.bid Not in(SELECT a.bid from BOOKS a, records b "
			+ "WHERE a.bookName like ? and (b.sid = ? or b.tid = ?) and a.bid = b.bid) and a.pid=b.pid;";
	
	public static String advancedSearchAlreadyBorrowedBookInfo(String sid, String tid)
	{
		String advancedSearchAlreadyBorrowedBookInfoQuery = "SELECT * FROM BOOKS a, publishers b, records c "
				+ "WHERE a.bookName like ? AND a.AUTHOR LIKE ? and A.DEPT_ID = ? AND "
				+ "A.EDITION LIKE ? AND B.PNAME = ? and (c.sid = "+sid+" or c.tid = "+tid+") and"
				+ " a.pid=b.pid and a.bid = c.bid";
		
		return advancedSearchAlreadyBorrowedBookInfoQuery;
	}
	
	public static String advancedSearchNotBorrowedBookInfo(String sid, String tid) 
	{
		String advancedSearchNotBorrowedBookInfo = "SELECT * FROM BOOKS a, publishers b "
				+ "WHERE a.bookName LIKE ? AND a.AUTHOR LIKE ? and A.DEPT_ID = ? AND A.EDITION LIKE ? AND"
				+ " B.PNAME = ? and a.bid Not in(SELECT a.bid from BOOKS a, records b WHERE"
				+ " a.bookName like ? and (b.sid = "+sid+" or b.tid = "+tid+") and a.bid = b.bid) and a.pid=b.pid";
		
		return advancedSearchNotBorrowedBookInfo;
	}
	
	//*********************** List of department ***************************
	
	String getDepartmentNamesQuery = "SELECT * FROM DEPARTMENT";
	
	//*********************** List of publishers ***************************
	
	String getPublishersNamesQuery = "SELECT PNAME FROM PUBLISHERS";

	
	//*************************** Borrow countdown ****************************
	
	String generateEventName = "select LEFT(UUID(), 8)";
	public static String borrowCountdown(String eventName)
	{
		String startBorrowCountdownQuery = "CREATE EVENT e"+eventName
			+ " ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL  5 minute "
			+ "DO delete from records where recordId = ?";
		
		return startBorrowCountdownQuery;
	}
	
	//************************************ Get book details by book id ***********************************
	
	String getBookInfo = "SELECT * FROM BOOKS A, PUBLISHERS B WHERE A.BID = ? AND A.PID=B.PID";
	
	//************************* Update book info PID, DEPT_ID, BOOKNAME, YEAROFPUBLISHING, AUTHOR, EDITION ********************
	
	String updateBookInfo = "UPDATE BOOKS "
			+ "SET PID = ? , DEPT_ID = ?, BOOKNAME = ?, YEAROFPUBLISHING = ?, AUTHOR = ?, EDITION = ? "
			+ "WHERE BID = ?";
	
	//*********************** Delete **************************
	
	String deleteBookQuery = "delete from books where bid = ?";
	
	String deleteUser = "DELETE FROM users WHERE (Email = ?)";
	
	public static String deleteUserDetails(String field, String table)
	{
		String deleteDetailsQuery = "DELETE FROM "+table+" WHERE ("+field+" = ?)";
		
		return deleteDetailsQuery;
	}
	
	String deleteDepartmentQuery = "DELETE FROM department WHERE Dept_Id = ?";
	
	String deletePublisherQuery = "DELETE FROM publishers WHERE pid = ?";
	
	//********************************* Counting ************************************
	public static String count(String tableName)
	{
		String count = "SELECT COUNT(*) FROM "+tableName;
		return count;
	}
	
	public final static String countAlreadyBorrowedBookQuery = "SELECT count(*) FROM BOOKS a, publishers b, records c "
			+ "WHERE (c.sid = ? or c.tid = ?) and a.pid = b.pid and a.bid = c.bid";
	
	//*************************** Return Book ******************************
	String returnBookQuery = "DELETE FROM records WHERE recordId = ?";
	
	public static String getAlreadyBorrowedBookInfo(String sidOrTid, String id)
	{
		String getAlreadyBorrowedBookInfoQuery = "SELECT * FROM BOOKS a, publishers b, records c where c."+sidOrTid+" = "+id+" and a.bid = c.bid and a.pid=b.pid";
		return getAlreadyBorrowedBookInfoQuery;
	}
	
	//********************************* Book Recommendation ***************************
	
	String recommendBook = "SELECT * FROM books where Dept_Id = ? and bid not in("
			+ "select a.bid FROM BOOKS a, records c "
			+ "WHERE (c.sid = ? or c.tid = ?) and  a.bid = c.bid"
			+ ") ORDER BY RAND () LIMIT 5";
	
	//************************************* UPDATE PROFILE ********************************
	
	public static String updateProfileDetails(String id, String table)
	{
		String updateProfileDetails = "UPDATE "+table+" SET First_name = ?, Last_name = ?, Dob = ?, Phone = ?, "
			+ "village = ?, post = ?, district = ?, pin = ? "
			+ "WHERE "+id+" = ?";
		
		return updateProfileDetails;
	}
	
	//************************************** Admin Dashboard tables ***************************
	String newTeachers = "SELECT * FROM TEACHERS A, USERS B, DEPARTMENT C WHERE A.TID = B.TID AND A.DEPT_ID = C.DEPT_ID order by a.tid desc limit 5"; 
	String newStudents = "SELECT * FROM STUDENTS A, USERS B, DEPARTMENT C WHERE A.SID = B.SID AND A.DEPT_ID = C.DEPT_ID order by a.sid desc limit 5";
	
	//**************************** Ban User ********************************
	
	String banUserQuery = "UPDATE users SET status = false WHERE (Email = ?)";
	String activateUserQuery = "UPDATE users SET status = true WHERE (Email = ?)";
	
	//************************** User active status *************************
	
	String isUserActiveQuery = "select status from users where email = ?";
	
	//****************************** User email by Id ************************************
	
	public static String getUserEmailById(String field)
	{
		String getUserEmailByIdQuery = "SELECT EMAIL FROM users WHERE "+field+" = ?";
		return getUserEmailByIdQuery;
	}
	
	//********************************* Set Borrow Limit *******************************
	
	String setBorrowLimit = "UPDATE users SET borrowLimit = ? WHERE (Email = ?)";
	
	//******************************* Update Department name *************************
	String updateDepartment = "UPDATE DEPARTMENT SET Dept_Name = ? WHERE Dept_Id = ?";
	
	//******************************* Update Publisher name ***************************
	String updatePublisher = "UPDATE publishers SET pName = ? WHERE pid = ?";
	
	//****************************** User Limit check ********************************
	
	String getBorrowLimit = "SELECT borrowLimit FROM USERS WHERE EMAIL = ?";
	
	//********************************* Request Book *******************************
	
	String bookCheck = "select count(*) from books a, publishers b where a.bookName = ? and  a.author = ? and a.edition = ? and b.pName = ? and a.pid = b.pid";
	
	String duplicateRequest = "select rid from request_book where book_name = ?  and author = ? and edition = ? and publisher = ?";
	
	String requestedBooks = "select * from request_book";
	
	String requestedBookDetails = "SELECT distinct rid, book_name, author, edition, publisher FROM request_book where rid = ?";
	
	String distinctRequestBooks = "select distinct rid, book_name, author, edition, publisher from request_book";
	
	String cancelRequestQuery = "delete from request_book where rid = ? and (sid = ? or tid = ?)";
	
	String deleteRequestQuery = "delete from request_book where rid = ?";
	
	String notifyNewBookRequest = "select distinct rid, a_notify, l_notify from request_book order by rid desc";
	
	String notifyDone = "update request_book set a_notify = ?, l_notify = ?";
	
	String studentRequests = "SELECT * FROM request_book a, students b, department c where a.rid = ? and a.sid=b.sid and b.Dept_Id=c.Dept_Id";
	
	String teacherRequests = "SELECT * FROM request_book a, teachers b, department c where a.rid = ? and a.tid=b.tid and b.Dept_Id=c.Dept_Id";
	
	// ********************************* Request Granted ********************************
	
	String grantRequest = "update library_management.request_book set status = 1 where rid = ?";
	
	public static String requestDeleteCountdown(String eventName)
	{
		String startDeleteCountdownQuery = "CREATE EVENT e"+eventName
			+ " ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 10 second "
			+ "DO delete from request_book where rid = ?";
		
		return startDeleteCountdownQuery;
	}
}
