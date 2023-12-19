<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin</title>
</head>
<body>

<%!String maxUserName = "", customerName = ""; double max; LinkedList<String> maxSold; int size; PreparedStatement p; ResultSet rs; Connection con;%>

	<%
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
		out.println("Logged in as admin");
	%>
	<br><br>
	Select Month For Sales Report
	<form method=get>
		<input type="date" name="date" min="2023-01-01" max="2024-12-31" />
		<input type="submit" formaction=SalesReport.jsp value = "Go"><br><br>
	</form>
		
	Search Reservations By: <br>
	<form action=ResList.jsp method=get>
		<input type="radio" name="sortBy" value="flightNumber"/>Flight Number
		<input type="radio" name="sortBy" value="customerName"/>Customer Username
		<br>
		
		Value: <input type=text name="value">
		<br>
		<input type="submit" value="Search">
	</form>
	
	
	<%
	
		
			
			p = con.prepareStatement(
			" select username, format(sum(totalfare),2) total from customersforticket join ticket using (ticketnumber) group by username "
				); 
			rs=p.executeQuery();
			while (rs.next()) {
        		double rev = rs.getDouble("total");
        		String userName = rs.getString("username");
        		if(rev > max) {
        			max = rev;
        			maxUserName = userName;
        		}
        	}
			p = con.prepareStatement("select CustomerName from Customer where Username = ?");
			p.setString(1, maxUserName);
			rs = p.executeQuery();
			while(rs.next()) {
				customerName = rs.getString("CustomerName");
			}
			p = con.prepareStatement("drop table if exists temp");
			p.executeUpdate();
			p = con.prepareStatement(
				"create table temp as select ticketnumber, count(*) numSold from customersforticket join ticket using (ticketnumber) group by ticketnumber"
			);
			p.executeUpdate();
			p = con.prepareStatement("select ticketnumber maxTickets from temp where numSold = (select max(numSold) from temp);");
			rs = p.executeQuery();
			maxSold = new LinkedList<>();
			while(rs.next()) {
				maxSold.add(rs.getString("maxTickets"));
			}
			size = maxSold.size();
			rs.close();
			p = con.prepareStatement("drop table temp");
			p.executeUpdate();
			p.close();

	
	%>

	
	<br><br>
	Filter Revenue By: <br>
	<form action=RevenueFilter.jsp method=get>
		<input type="radio" name="filter" value="Ticket Number"/>Ticket Number
		<input type="radio" name="filter" value="Name"/>Customer Name
		<input type="radio" name="filter" value="Airline"/>Airline
		<br>
		<input type="submit" value="Filter">
	</form>
	
	<%! 
		String name, username, password;
	%>
	
	<%
	

			p = con.prepareStatement(
				"select customername name, Username, password from customer"
			); 
			rs=p.executeQuery();
			
			
			

	
	%>
	<br><% out.println(customerName + " brought in the most revenue at $" + max); %>
	<br><br><% out.println("Best selling ticket numbers: "); 
		for(int i=0; i<size; i++) {
			out.print(maxSold.get(i));
			if(i != size-1) out.println(", ");
		}
	%>
	
	<br><br>
	Edit Customer Information
	<br>
	<table>
	<tr>    
		<td>Username</td>
		<td>New Name </td>
		<td>New Password </td>			
	</tr>
				<%
		PreparedStatement pCust = con.prepareStatement("select * from customer");
		ResultSet rCust = pCust.executeQuery();
		while (rCust.next()) { %>
			<tr>
				<form action=EditAccounts.jsp method=post>
						<td><input value=<% out.println(rCust.getString("Username")); %> name=CustomerUsername value=<% out.println(rCust.getString("Username")); %> readonly>
						<td><input type=text name=NewCustomerName>
						<td><input type=text name=NewCustomerPassword>
						<input type=submit name=val value="Edit name and password">
				</td>
				</form>
				<form action=EditAccounts.jsp method=post>
				<td><input value=<% out.println(rCust.getString("Username")); %> name=DeleteCustomerUsername value=<% out.println(rCust.getString("Username")); %> readonly>
				<input type=submit value="Delete User">
				</form>
		<% } %>
			</tr>
	</table>
	<br><br>
	Add Customer
	<br>
	<table>
	<tr>    
		<td>Username</td>
		<td>Name </td>
		<td>Password </td>			
	</tr>
	<form action=EditAccounts.jsp method=post>
	<td><input name=AddCustomerUsername >
	<td><input name=AddCustomerName >
	<td><input name=AddCustomerPassword >
	<input type=submit value="Add">
	</form>
	</table>
	
	<br><br>
	Edit Customer Representative Information
	<br>
	<table>
	<tr>    
		<td>Username </td>
		<td>New Password </td>			
	</tr>
				<%
		PreparedStatement p2 = con.prepareStatement("select * from customerrep");
		ResultSet rrep=p2.executeQuery();
		while (rrep.next()) { %>
			<tr>
				<form action=EditAccounts.jsp method=post>
						<td><input value=<% out.println(rrep.getString("Username")); %> name=RepUserName value=<% out.println(rrep.getString("Username")); %> readonly>
						<td><input type=text name=NewRepPassword>
						<input type=submit value="Edit password">
				</td>
				
				</form>
		<% } %>
			</tr>
	</table>
	
	<br><br><form action=home.jsp method=post>
		<input type="submit" value="Log out">
	</form>
	
	<%		
		rs.close();
		p.close();
		con.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	%>
	
</body>
</html>