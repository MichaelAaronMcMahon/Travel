<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%!
	String sales, bookingFees, unsoldSeats, saleRev, date, year, month;
%>

<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			date=request.getParameter("date");
			year = date.substring(0, 4);
			month = date.substring(5, 7);
			//out.println("Month: " + month);
			//out.println("year: " + year);
			PreparedStatement p = con.prepareStatement(
			"SELECT  FORMAT(SUM(totalfare), 2) totalFares, FORMAT(SUM(bookingfee), 2) bookingFees, FORMAT((SUM(totalFare) - SUM(bookingFee)), 2) saleRev FROM (SELECT t.TicketNumber AS TicketNumber, t.SeatNumber, t.class, t.TotalFare, t.BookingFee, t.RoundTripOrOneWay, ft.TicketNumber AS TicketNum, ft.Seats AS Seatsft, ft.AirlineID AS AirlineIDft, ft.FlightNumber AS FlightNumberft, f.OperationDays, f.DomesticOrInternational, f.Seats AS Seats, f.AirlineID AS AirlineID, f.FlightNumber AS FlightNumber, f.DepartureTime, f.ArrivalTime FROM ticket t, flightsforticket ft, flight f WHERE t.ticketnumber = ft.ticketnumber AND ft.Seats = f.Seats AND ft.AirlineID = f.AirlineID AND ft.FlightNumber = f.FlightNumber AND MONTH(departuretime) = ? AND YEAR(departuretime) = ? AND t.ticketnumber IN (SELECT  TicketNumber FROM customersforticket) GROUP BY t.TicketNumber) abcde"
				); 
			p.setString(1, month);
			p.setString(2, year);
			ResultSet rs=p.executeQuery();
			
			 while (rs.next()) {
	                sales = rs.getString("totalFares");
	                bookingFees = rs.getString("bookingFees");
	                saleRev = rs.getString("saleRev");
	            }
			rs.close();
			p.close();
			con.close();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
	%>
	
	<br>
	<% 
		out.println("Total sales revenue for the month of " + Month.of(Integer.parseInt(month)) + ": $" + saleRev);
	%>
	<br><br>
	<% 
		out.println("Total booking fees revenue for the month of " + Month.of(Integer.parseInt(month)) + ": $" + bookingFees);
	%>
	<br><br>
	<% 
		out.println("Total revenue for the month of " + Month.of(Integer.parseInt(month)) + ": $" + sales);
	%>
	
	<br><br><br><form action=admin.jsp method=get>
		<input type="submit" value="Back to Dashboard">
	</form>

</body>
</html>