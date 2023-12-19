<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Revenue Filter</title>

<style>
	 td {
        padding: 12px; /* Adjust this value as needed for spacing */
    }
</style>

</head>
<body>
	<%!ResultSet rs; %>
	<%
		String filter = request.getParameter("filter");
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
		PreparedStatement p;
		if(filter.equals("Name")) {
			out.println("Revenue by customer");
			p = con.prepareStatement(
				"select c.username filter, format(sum(totalfare),2) totalfare, format(sum(bookingfee),2) bookingfee from customersforticket join customer c using (username) join ticket using (ticketnumber) group by c.username"
			);
			rs = p.executeQuery();
		}
		else if(filter.equals("Ticket Number")) {
			out.println("Revenue by ticket number");
			p = con.prepareStatement(
				"select ticketnumber filter, format(sum(totalfare),2) totalfare, format(sum(bookingfee),2) bookingfee from customersforticket join customer using(username) join ticket using (ticketnumber) group by ticketnumber"
			);
			rs = p.executeQuery();
		}
		else {
			out.println("Revenue by airline");
			p = con.prepareStatement(
				"select AirlineID filter, sum(TotalFare) totalfare, sum(BookingFee) bookingfee from (select t.TicketNumber, t.TotalFare, t.BookingFee, ft.AirlineID, Username from customersforticket ct join ticket t using (ticketnumber) join flightsforticket ft using (ticketnumber) group by t.Ticketnumber, Username) tabule group by AirlineID"
			);
			rs = p.executeQuery();		
		}
	%>
	
		
	<table>
		<tr>    
			<td><%out.println(filter);%></td>
			<td>Total Fares </td>
			<td>Booking Fees </td>			
		</tr>
					<%
			while (rs.next()) { %>
				<tr>
					<td><%= rs.getString("filter") %></td>    
					<td><%= ("$" + rs.getString("totalfare")) %></td>
					<td><%= ("$" + rs.getString("bookingfee")) %></td>
					
			<% } %>
				</tr>
	</table>
	
	<br><br><form action=admin.jsp method=post>
		<input type="submit" value="Back">
	</form>
	
	<c:choose> </c:choose> 

</body>
</html>