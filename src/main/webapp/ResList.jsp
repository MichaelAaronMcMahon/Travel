<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservation List</title>

<style>
	 td {
        padding: 12px; /* Adjust this value as needed for spacing */
    }
</style>

</head>
<body>

	<%!
		String sortBy, value;
		ResultSet rs;
		Connection con;
		PreparedStatement p;
	%>
	
	<% try {
		
			Class.forName("com.mysql.cj.jdbc.Driver");
			con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			sortBy = request.getParameter("sortBy");
			value = request.getParameter("value");
			if(sortBy.equals("flightNumber")){ 
				out.println("Reservations For Flight Number " + value);
				p = con.prepareStatement(
					"select * from customersforticket join flightsforticket using(ticketnumber) join customer using(username) join ticket using(ticketnumber) where FlightNumber = ?"
				);
			}
			else{ 
				out.println("Reservations for " + value);
				p = con.prepareStatement(
					"select * from customersforticket join flightsforticket using(ticketnumber) join customer c using(username) join ticket using(ticketnumber) where c.Username = ? group by ticketnumber"
				);
			}
			p.setString(1, value);
			rs=p.executeQuery();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	%>
	
	<table>
		<tr>    
			<td>Ticket number </td>
			<td>Name </td>
			<td>Username </td>
			<td>Seat Number </td>
			<td>Class </td>			
			<td>Total Fare </td>
			<td>Booking Fee </td>
		</tr>
					<%
			while (rs.next()) { %>
				<% String t = rs.getString("TicketNumber"); %>
				<tr>
					<td><%= rs.getString("TicketNumber") %></td>
					<td><%= rs.getString("CustomerName") %></td>    
					<td><%= rs.getString("UserName") %></td>
					<td><%= rs.getString("SeatNumber") %></td>
					<td><%= rs.getString("Class") %></td>
					<td><%= rs.getString("TotalFare") %></td>
					<td><%= rs.getString("BookingFee") %></td>
					
			<% } %>
				</tr>
	</table>
	<%
		rs.close();
		p.close();
		con.close();
	%>
	
	<br><form action=admin.jsp method=post>
		<input type="submit" value="Back">
	</form>

</body>
</html>