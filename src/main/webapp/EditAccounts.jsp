<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Center</title>
</head>
<body>

<%
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
		String CustomerUsername = request.getParameter("CustomerUsername");
		String NewCustomerPassword = request.getParameter("NewCustomerPassword");
		String NewCustomerName = request.getParameter("NewCustomerName");
		String RepUserName = request.getParameter("RepUserName");
		String NewRepPassword = request.getParameter("NewRepPassword");
		String DeleteCustomerUsername = request.getParameter("DeleteCustomerUsername");
		String AddCustomerUsername = request.getParameter("AddCustomerUsername");
		String AddCustomerName = request.getParameter("AddCustomerName");
		String AddCustomerPassword = request.getParameter("AddCustomerPassword");
		String AddRepUsername = request.getParameter("AddRepUsername");
		String AddRepPassword = request.getParameter("AddRepPassword");
		String DeleteRepUsername = request.getParameter("DeleteRepUsername");
		
		
		if(CustomerUsername != null && CustomerUsername.length() >= 1) {
			PreparedStatement pCustomer = con.prepareStatement(
				"update customer set Password=?, CustomerName = ? where username =?"
			); 
			pCustomer.setString(1, NewCustomerPassword);
			pCustomer.setString(2, NewCustomerName);
			pCustomer.setString(3, CustomerUsername);
			pCustomer.executeUpdate();
		}
		if(DeleteCustomerUsername != null && DeleteCustomerUsername.length() >= 1) {
			PreparedStatement pDelCustomer = con.prepareStatement(
				"delete from customer where username = ?"
			); 
			pDelCustomer.setString(1, DeleteCustomerUsername);
			pDelCustomer.executeUpdate();
		}
		if(DeleteRepUsername != null && DeleteRepUsername.length() >= 1) {
			PreparedStatement pDelRep = con.prepareStatement(
				"delete from customerrep where username = ?"
			); 
			pDelRep.setString(1, DeleteRepUsername);
			pDelRep.executeUpdate();
		}
		if(AddCustomerName != null && AddCustomerName.length() >= 1) {
			PreparedStatement pAddCustomer = con.prepareStatement(
				"insert into customer value (?, ?, ?)"
			); 
			pAddCustomer.setString(1, AddCustomerName);
			pAddCustomer.setString(2, AddCustomerUsername);
			pAddCustomer.setString(3, AddCustomerPassword);
			pAddCustomer.executeUpdate();
		}
		if(RepUserName != null && RepUserName.length() >= 1) {
			PreparedStatement pRep = con.prepareStatement(
				"update customerrep set Password=? where username =?"
			); 
			pRep.setString(1, NewRepPassword);
			pRep.setString(2, RepUserName);
			pRep.executeUpdate();
		}
		if(AddRepUsername != null && AddRepUsername.length() >= 1) {
			PreparedStatement pAddrep = con.prepareStatement(
				"insert into customerrep value (?, ?)"
			); 
			pAddrep.setString(1, AddRepUsername);
			pAddrep.setString(2, AddRepPassword);
			pAddrep.executeUpdate();
		}
		
		con.close();
		
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
	} 

%>
	<%out.println("Success");%>
	<br><br><form action=home.jsp method=post>
		<input type="submit" value="Log out">
	</form>

</body>
</html>