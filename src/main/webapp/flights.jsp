<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
   <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			Statement stmt = con.createStatement();
			String roundorone = request.getParameter("roundorone");
			String date = request.getParameter("date");
			String error = request.getParameter("error");
			String price = request.getParameter("price");
			String NumStops = request.getParameter("NumStops");
			String AA = request.getParameter("AA");
			String DA = request.getParameter("DA");
			String FA = request.getParameter("FA");
			String JA = request.getParameter("JA");
			String SA = request.getParameter("SA");
			String DepartureAirportIDbtwn = request.getParameter("DepartureAirportID");
			String ArrivalAirportIDbtwn = request.getParameter("ArrivalAirportID");
			String[] Airlines = {AA, DA, FA, JA, SA};
			for(int i =0; i<5; i++){
				if(Airlines[i] == null){
					Airlines[i] = "ZE";
				}
			}
			String takeofftime = request.getParameter("takeofftime");
			String landingtime = request.getParameter("landingtime");
			String Sort = request.getParameter("Sort");
			//String Year = request.getParameter("Year");
			//String Month = request.getParameter("Month");
			//String Day = request.getParameter("Day");
			/*String DayMon = request.getParameter("DayMon");
			String DayTues = request.getParameter("DayTues");
			String DayWed = request.getParameter("DayWed");
			String DayThurs = request.getParameter("DayThurs");
			String DayFri = request.getParameter("DayFri");
			String DaySat = request.getParameter("DaySat");
			String DaySun = request.getParameter("DaySun");)*/
			//String str = "SELECT * FROM Ticket WHERE RoundTripOrOneWay = ?";
			//ResultSet rs = stmt.executeQuery(str);
			
			PreparedStatement p0 = con.prepareStatement("drop table if exists rt");
			p0.executeUpdate();
			PreparedStatement pa = con.prepareStatement("drop table if exists rt2");
			pa.executeUpdate();
			PreparedStatement p1=con.prepareStatement("Create table rt select t.TicketNumber as TicketNumber, t.SeatNumber, t.class, t.TotalFare, t.BookingFee, t.RoundTripOrOneWay, ft.TicketNumber as TicketNum, ft.Seats as Seatsft, ft.AirlineID as AirlineIDft, ft.FlightNumber as FlightNumberft, f.OperationDays, f.DomesticOrInternational, f.Seats as Seats, f.AirlineID as AirlineID, f.FlightNumber as FlightNumber, f.DepartureAirportID, f.DestinationAirportID, f.DepartureTime, f.ArrivalTime from ticket t join flightsforticket ft on t.TicketNumber=ft.TicketNumber join flight f on f.FlightNumber = ft.FlightNumber");
			p1.executeUpdate();
			if (roundorone != null){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where RoundTripOrOneWay = ?");
				p2.setString(1, roundorone);
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if(DepartureAirportIDbtwn != null && DepartureAirportIDbtwn.length() >= 1){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where DepartureAirportID = ? AND DestinationAirportID = ?");
				p2.setString(1, DepartureAirportIDbtwn);
				p2.setString(2, ArrivalAirportIDbtwn);
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();
			}
			if (date != null){
				if(error != null){
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where (DepartureTime - interval '3' day like ? OR DepartureTime - interval '2' day like ? OR DepartureTime - interval '1' day like ? OR DepartureTime like ? OR DepartureTime + interval '1' day like ? OR DepartureTime + interval '2' day like ? OR DepartureTime + interval '3' day like ?)");
					p2.setString(1, "%" + date + "%");
					p2.setString(2, "%" + date + "%");
					p2.setString(3, "%" + date + "%");
					p2.setString(4, "%" + date + "%");
					p2.setString(5, "%" + date + "%");
					p2.setString(6, "%" + date + "%");
					p2.setString(7, "%" + date + "%");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
				else{
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where DepartureTime like ?");
					p2.setString(1, "%" + date + "%");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
			}
			if (price != null && price.length() >= 1){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where TotalFare <= ?");
				p2.setString(1, price);
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if (NumStops != null && NumStops.length() >= 1){
				PreparedStatement py=con.prepareStatement("Drop table if exists stopquantity");
				py.executeUpdate();
				PreparedStatement px=con.prepareStatement("Create table stopquantity SELECT count(*) quantity, TicketNumber from rt group by TicketNumber");
				px.executeUpdate();
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT t.* FROM rt t, stopquantity sq where sq.TicketNumber=t.TicketNumber AND sq.quantity = ?");
				p2.setString(1, NumStops);
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if(AA != null || DA != null || FA != null || JA != null || SA != null){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where (AirlineID LIKE ? OR AirlineID LIKE ? OR AirlineID LIKE ? OR AirlineID LIKE ? OR AirlineID LIKE ?)");
				p2.setString(1, "%" + Airlines[0] + "%");
				p2.setString(2, "%" + Airlines[1] + "%");
				p2.setString(3, "%" + Airlines[2] + "%");
				p2.setString(4, "%" + Airlines[3] + "%");
				p2.setString(5, "%" + Airlines[4] + "%");
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if(takeofftime != null && takeofftime.length() >= 1){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where DepartureTime like ?");
				p2.setString(1, "%" + takeofftime + "%");
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if(landingtime != null && landingtime.length() >= 1){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where ArrivalTime like ?");
				p2.setString(1, "%" + landingtime + "%");
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}
			if(Sort != null && Sort.length()>=1){
				if(Sort.equals("PriceSort")){
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt ORDER BY TotalFare");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
				if(Sort.equals("TakeoffSort")){
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt order by extract(hour_minute from (select dt from (select min(DepartureTime) dt, TicketNumber from rt group by TicketNumber) a where a.TicketNumber = rt.TicketNumber))");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
				if(Sort.equals("LandingSort")){
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt order by extract(hour_minute from (select dt from (select max(ArrivalTime) dt, TicketNumber from rt group by TicketNumber) a where a.TicketNumber = rt.TicketNumber))");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
				if(Sort.equals("DurationSort")){
					//PreparedStatement p2=con.prepareStatement("Create table rt2 select * from rt order by (select duration from(select sum(ArrivalTime-DepartureTime) duration, TicketNumber from rt group by TicketNumber) b where b.TicketNumber = rt.TicketNumber)");
					PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt order by (select duration from (select sum(timestampdiff(SECOND, DepartureTime, ArrivalTime)) duration, TicketNumber from rt group by TicketNumber) a where a.TicketNumber = rt.TicketNumber)");
					p2.executeUpdate();
					PreparedStatement p3=con.prepareStatement("Drop table rt");
					p3.executeUpdate();
					PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
					p4.executeUpdate();	
				}
			}
			/*if(AA == null){
				PreparedStatement p2=con.prepareStatement("Create table rt2 SELECT * FROM rt where AirlineID != ?)");
				p2.setString(1, AA);
				p2.executeUpdate();
				PreparedStatement p3=con.prepareStatement("Drop table rt");
				p3.executeUpdate();
				PreparedStatement p4=con.prepareStatement("alter table rt2 rename to rt");
				p4.executeUpdate();	
			}*/
			
			PreparedStatement pfinal = con.prepareStatement("Select * from rt group by TicketNumber");
			ResultSet rs=pfinal.executeQuery();
			//PreparedStatement p1=con.prepareStatement("SELECT * FROM Ticket WHERE RoundTripOrOneWay = ? and TicketNumber in (select t.TicketNumber from ticket t join flightsforticket ft on t.TicketNumber=ft.TicketNumber join flight f on f.FlightNumber = ft.FlightNumber where DepartureTime like ?)");
			/*p1.setString(1, roundorone);
			p1.setString(2, "%" + date + "%");
			if(error.equals("Yes")){
				p1=con.prepareStatement("SELECT * FROM Ticket WHERE RoundTripOrOneWay = ? and TicketNumber in (select t.TicketNumber from ticket t join flightsforticket ft on t.TicketNumber=ft.TicketNumber join flight f on f.FlightNumber = ft.FlightNumber where (DepartureTime - interval '3' day like ? OR DepartureTime - interval '2' day like ? OR DepartureTime - interval '1' day like ? OR DepartureTime like ? OR DepartureTime + interval '1' day like ? OR DepartureTime + interval '2' day like ? OR DepartureTime + interval '3' day like ?))");
				p1.setString(1, roundorone);
				p1.setString(2, "%" + date + "%");
				p1.setString(3, "%" + date + "%");
				p1.setString(4, "%" + date + "%");
				p1.setString(5, "%" + date + "%");
				p1.setString(6, "%" + date + "%");
				p1.setString(7, "%" + date + "%");
				p1.setString(8, "%" + date + "%");
			}	*/
			//p1.setString(2, "%" + Year + "-" + Month + "-" + Day + "%");
			//p1.setString(2, "%" + Year + "%");
			
			//p1.setString(3, "%" + DayTues + "%");
			//p1.setString(4, "%" + DayWed + "%");
			//p1.setString(5, "%" + DayThurs + "%");
			//p1.setString(6, "%" + DayFri + "%");
			//p1.setString(7, "%" + DaySat + "%");
			//p1.setString(8, "%" + DaySun + "%");
			
		%>
<br>Back to filters<br>
<form action=welcome.jsp method=post>
<input type=submit value=Back>
</form><br>
<table>
		<tr>    
			<td>Buy </td>
			<td>Ticket Number </td>
			<td>Seat Number </td>
			<td>Class </td>
			<td>Total Fare </td>
			<td>Booking Fee </td>
			<td>Aircraft Name</td>
			<td>Departure Airport </td>
			<td>Destination Airport </td>
			<td>Departure Time </td>
			<td>Arrival Time </td>
			<td>Airline </td>
			<td>Operation Days </td>
			<td>Domestic or International </td>
			<td>Seats </td>
		</tr>
			<%
			//parse out the results
			//out.println(date);
			//out.println(error);
			while (rs.next()) { %>
				<% String t = rs.getString("TicketNumber"); %>
				<tr>
					
					<td><form action=Buy.jsp method=post>
						<input value=<% out.println(t); %> name=TicketNumber>
						
						<input type=submit value=Buy>
					</form></td>
					
					<td><%= rs.getString("TicketNumber") %></td>    
					<td><%= rs.getString("SeatNumber") %></td>
					<td><%= rs.getString("Class") %></td>
					<td><%= rs.getString("TotalFare") %></td>
					<td><%= rs.getString("BookingFee") %></td>
					<% 
					//String flightsforticket = "SELECT ft.Seats, ft.AirlineID, ft.FlightNumber FROM FlightsForTicket ft, Ticket t WHERE ft.TicketNumber = t.TicketNumber"; 
					//ResultSet flightset = stmt.executeQuery(flightsforticket);
					
					PreparedStatement p=con.prepareStatement("Select f.* FROM flight f join FlightsForTicket ft USING (Seats, AirlineID, FlightNumber) WHERE ft.TicketNumber = ?");
					String tn = rs.getString("TicketNumber");
					p.setString(1, tn);
					ResultSet flighttable=p.executeQuery();
					while(flighttable.next()){ %>
						<% 
						String DepartureAirportID = flighttable.getString("DepartureAirportID");
						PreparedStatement pDeparture = con.prepareStatement("select AirportName from Airport where AirportID = ?");
						pDeparture.setString(1, DepartureAirportID);
						ResultSet rDepartureAirportName = pDeparture.executeQuery();
						String DepartureAirportName = "x";
						if(rDepartureAirportName.next()){
							DepartureAirportName = rDepartureAirportName.getString("AirportName");
						}
						String DestinationAirportID = flighttable.getString("DestinationAirportID");
						PreparedStatement pDestination = con.prepareStatement("select AirportName from Airport where AirportID = ?");
						pDestination.setString(1, DestinationAirportID);
						ResultSet rDestinationAirportName = pDestination.executeQuery();
						String DestinationAirportName = "x";
						if(rDestinationAirportName.next()){
							DestinationAirportName = rDestinationAirportName.getString("AirportName");
						}
						String Seats = flighttable.getString("Seats");
						String AirlineID = flighttable.getString("AirlineID");
						PreparedStatement pAircraftName = con.prepareStatement("select AircraftName from Aircraft where Seats = ? AND AirlineID = ?");
						pAircraftName.setString(1, Seats);
						pAircraftName.setString(2, AirlineID);
						ResultSet rAircraftName = pAircraftName.executeQuery();
						String AircraftName = "x";
						PreparedStatement pAirlineName = con.prepareStatement("Select AirlineName FROM Airline WHERE AirlineID = ?");
						pAirlineName.setString(1, AirlineID);
						ResultSet rAirlineName = pAirlineName.executeQuery();
						String AirlineName = "x";
						if(rAirlineName.next()){
							AirlineName = rAirlineName.getString("AirlineName");
						}
						if(rAircraftName.next()){
							AircraftName = rAircraftName.getString("AircraftName");
						}
						%>
						<td><% out.println(AircraftName); %></td>
						<td><% out.println(DepartureAirportName); %></td>
						<td><% out.println(DestinationAirportName); %></td>
						<td><%= flighttable.getString("DepartureTime") %>
						<td><%= flighttable.getString("ArrivalTime") %>
						<td><% out.println(AirlineName); %></td>
						<td><%= flighttable.getString("OperationDays") %>
						<td><%= flighttable.getString("DomesticOrInternational") %>
						<td><%= flighttable.getString("Seats") %></td> <tr><td><td><td><td><td><td>
					<% } %>
					
			<% } %>
				</tr>

</table>
		<%
		rs.close();
		stmt.close();
		con.close();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		%>
</body>
</html>