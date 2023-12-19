<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative</title>

<style>
    table {
        border-collapse: separate; 
        vertical-border-spacing: 35px; 
    }
    td {
        padding: 3px;
    }
</style>

</head>
<body>

	<%!PreparedStatement p; ResultSet rs; Connection con;%>
	
	<% try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
		p = con.prepareStatement("select * from questionsandanswers");
		rs=p.executeQuery();
		PreparedStatement pfinal = con.prepareStatement("select * from ticket t join flightsforticket ft using (TicketNumber) join flight using (Seats, AirlineID, FlightNumber) group by ticketnumber");
		ResultSet rflight=pfinal.executeQuery();
		//rs.close();
		//p.close();
		//con.close();
		

	
	%>
		
		<table>
		<tr>    
			<td>User</td>
			<td>Question </td>
			<td>Answer </td>			
		</tr>
					<%
			while (rs.next()) { %>
				<tr>  
					<td><form action=AnswerQuestion.jsp method=post>
							<input type=text input value=<% out.println(rs.getString("Username")); %>name=username value=<% out.println(rs.getString("Username")); %> readonly>
							
					</td>
					<td>
							<!-- <input type=text input value=
							<% //out.println(rs.getString("Question")); %> name=password value=<% //out.println(rs.getString("Question")); %> readonly>  -->
							<% out.println(rs.getString("Question"));  %>
							
					</td>
					<td>	
							<input value=<% out.println(rs.getString("Answer")); %> name=password value=<% out.println(rs.getString("Answer")); %> >
							<input type=submit name=val value="Answer">
					</td>
					</form>
			<% } %>
			</tr>
	</table>
	<br>
	Make flight reservations on behalf of users
	<br>
	Use one of these usernames in the Customer field:
	<br>
	<%
	PreparedStatement pnames = con.prepareStatement("select Username from customer");
	ResultSet rnames = pnames.executeQuery();
	while (rnames.next()){
		%> <br> <% out.println(rnames.getString("Username")); 
	}
	%>
	<br>

	<table>
		<tr>    
			<td>Customer </td>
			<td>Ticket Number </td>
			<td>Seat Number </td>
			<td>Class </td>
			<td>Total Fare </td>
			<td>Booking Fee </td>
			<td>Aircraft Name </td>
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
			while (rflight.next()) { %>
				<% String t = rflight.getString("TicketNumber"); %>
				<tr>
					<td><form action=Buy.jsp method=post>
						<input name=UserReservedFor>
						<input value=<% out.println(t); %> name=TicketNumber>
						<input type=submit value=Reserve>
					</form></td>
					
					<td><%= rflight.getString("TicketNumber") %></td>    
					<td><%= rflight.getString("SeatNumber") %></td>
					<td><%= rflight.getString("Class") %></td>
					<td><%= rflight.getString("TotalFare") %></td>
					<td><%= rflight.getString("BookingFee") %></td>
					<% 
					//String flightsforticket = "SELECT ft.Seats, ft.AirlineID, ft.FlightNumber FROM FlightsForTicket ft, Ticket t WHERE ft.TicketNumber = t.TicketNumber"; 
					//ResultSet flightset = stmt.executeQuery(flightsforticket);
					//String fftable = "Select f.DepartureAirport, f.DestinationAirport, f.DepartureTime FROM flight f join FlightsForTicket ft USING (Seats, AirlineID, FlightNumber) WHERE ft.TicketNumber = ?";
					
					//PreparedStatement p=con.prepareStatement("Select f.DepartureAirport, f.DestinationAirport, f.DepartureTime FROM flight f join FlightsForTicket ft USING (Seats, AirlineID, FlightNumber) WHERE ft.TicketNumber = ?");
					PreparedStatement p=con.prepareStatement("Select f.* FROM flight f join FlightsForTicket ft USING (Seats, AirlineID, FlightNumber) WHERE ft.TicketNumber = ?");
					String tn = rflight.getString("TicketNumber");
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
<br>
<br>
Cancel flight reservations of Customers
<br>
Customer
<form action=CustomerReservations.jsp method=post>
<input name=UserCanceledFor>
<input type=submit value=View>
</form>
<br>
<br>
Add Aircraft
<br>
<table>
	<tr>
		<td>Existing 2 Letter Airline ID - Name -------------------------- Number of Seats</td>
	</tr>
	<td><form action=RepEdit.jsp method=post>
	<input name=AddAircraftID >
	<input name=AddAircraftName>
	<input name=AddAircraftSeats>
	<input type=submit value=Submit>
	</form></td>
</table>
<br>
<br>
Edit Aircraft Information
<br>
<br>
<table>
	<tr>
		<td>AirlineID</td>
		<td>Number of Seats></td>
		<td>AircraftName</td>
		<td>Edit: AirlineID ------------------ Seats ------------------ New Aircraft Name</td>
		<td>Delete Airline</td>
	</tr>
	
	<%
	PreparedStatement pAircraft=con.prepareStatement("Select * from Aircraft");
	ResultSet rAircraft=pAircraft.executeQuery();
	while(rAircraft.next()){ 
		%>
		<td><%= rAircraft.getString("AirlineID") %>
		<td><%= rAircraft.getString("Seats") %>
		<td><%= rAircraft.getString("AircraftName") %>
		<td><form action=RepEdit.jsp method=post>
		<input type=text input value=<% out.println(rAircraft.getString("AirlineID")); %>name=UpdateAircraftID value=<% out.println(rAircraft.getString("AirlineID")); %> readonly>
		<input type=text input value=<% out.println(rAircraft.getString("Seats")); %>name=UpdateAircraftSeats value=<% out.println(rAircraft.getString("Seats")); %> readonly>
		<input name=NewAircraftName>
		<input type=submit value=Submit>
		</form></td>
		<td><form action=RepEdit.jsp method=post>
		<input type=text input value=<% out.println(rAircraft.getString("AirlineID")); %>name=DeleteAircraftID value=<% out.println(rAircraft.getString("AirlineID")); %> readonly>
		<input type=text input value=<% out.println(rAircraft.getString("Seats")); %>name=DeleteAircraftSeats value=<% out.println(rAircraft.getString("Seats")); %> readonly>
		<input type=submit value=Submit>
		</form>
		</td>
		<tr>
	<%
	}
	%>
</table>
<br>
Add Airport
<br>
<table>
	<tr>
		<td>3 Letter ID Airport ID ---------- Name</td>
	</tr>
	<td><form action=RepEdit.jsp method=post>
	<input name=AddAirlineID >
	<input name=AddAirlineName>
	<input type=submit value=Submit>
	</form></td>
</table>
<br>
Edit Airport Information
<br>
<table>
	<tr>
		<td>Airport ID</td>
		<td>Airport Name</td>
		<td>Edit: ID ------------- New Airport Name</td>
		<td>Delete Airline</td>
	</tr>
	
	<%
	PreparedStatement pAirline=con.prepareStatement("Select * from Airport");
	ResultSet rAirline=pAirline.executeQuery();
	while(rAirline.next()){ 
		%>
		<td><%= rAirline.getString("AirportID") %>
		<td><%= rAirline.getString("AirportName") %>
		<td><form action=RepEdit.jsp method=post>
		<input type=text input value=<% out.println(rAirline.getString("AirportID")); %>name=UpdateAirlineID value=<% out.println(rAirline.getString("AirportID")); %> readonly>
		<input name=NewAirlineName>
		<input type=submit value=Submit>
		</form></td>
		<td><form action=RepEdit.jsp method=post>
		<input type=text input value=<% out.println(rAirline.getString("AirportID")); %>name=DeleteAirlineID value=<% out.println(rAirline.getString("AirportID")); %> readonly>
		<input type=submit value=Submit>
		</form>
		</td>
		<tr>
	<%
	}
	%>
</table>
<br>
Add Flight
<br>
<table>
	<tr>
		<td>Flight Number</td>
		<td>Operation Days</td>
		<td>Seats</td>
		<td>Airline ID</td>
		<td>Departure Airport ID</td>
		<td>Destination Airport ID</td>
		<td>Domestic or International</td>
		<td>Departure Time</td>
		<td>Arrival Time</td>
	</tr>

		<form action=RepEdit.jsp method=post>
		<td><input type=text name=fFlightNumber >
		<td><input type=text name=fOperationDays  >
		<td><input type=text name=fSeats  >
		<td><input type=text name=fAirlineID >
		<td><input type=text name=fDepartureAirportID  >
		<td><input type=text name=fDestinationAirportID  >
		<td><input type=text name=fDomesticOrInternational  >
		<td><input type=text name=fDepartureTime  >
		<td><input type=text name=fArrivalTime  >
		<td><input type=text input value=<% out.println("Add"); %>name=fFlightAdd value=<% out.println("Add"); %> readonly>
		<input type=submit value=Submit>
		</form>

		<tr>
</table>
<br>
Edit Flight Information
<br>
<table>
	<tr>
		<td>Flight Number</td>
		<td>Operation Days</td>
		<td>Seats</td>
		<td>Airline ID</td>
		<td>Departure Airport ID</td>
		<td>Destination Airport ID</td>
		<td>Domestic or International</td>
		<td>Departure Time</td>
		<td>Arrival Time</td>
		<td>Delete Flight</td>
	</tr>
	
	<%
	PreparedStatement pFlights = con.prepareStatement("Select * from flight");
	ResultSet rFlights=pFlights.executeQuery();
	while (rFlights.next()){
		/*PreparedStatement pOp = con.prepareStatement("select OperationDays from flight where flightnumber = ?");
		pOp.setString(1, rFlights.getString("FlightNumber"));
		ResultSet opDays = pOp.executeQuery();
		String OperationDays = "x";
		if(opDays.next()){
			OperationDays = opDays.getString("OperationDays");*/
		
		%>
		<form action=RepEdit.jsp method=post>
		<td><input type=text input value=<% out.println(rFlights.getString("FlightNumber")); %>name=fFlightNumber value=<% out.println(rFlights.getString("FlightNumber")); %> readonly>
		<td><input type=text input value=<% out.println(rFlights.getString("OperationDays")); %>name=fOperationDays value=<% out.println(rFlights.getString("OperationDays")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("Seats")); %>name=fSeats value=<% out.println(rFlights.getString("Seats")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("AirlineID")); %>name=fAirlineID value=<% out.println(rFlights.getString("AirlineID")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("DepartureAirportID")); %>name=fDepartureAirportID value=<% out.println(rFlights.getString("DepartureAirportID")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("DestinationAirportID")); %>name=fDestinationAirportID value=<% out.println(rFlights.getString("DestinationAirportID")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("DomesticOrInternational")); %>name=fDomesticOrInternational value=<% out.println(rFlights.getString("DomesticOrInternational")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("DepartureTime")); %>name=fDepartureTime value=<% out.println(rFlights.getString("DepartureTime")); %> >
		<td><input type=text input value=<% out.println(rFlights.getString("ArrivalTime")); %>name=fArrivalTime value=<% out.println(rFlights.getString("ArrivalTime")); %> >
		<input type=text input value=<% out.println("Update"); %>name=fFlightUpdate value=<% out.println("Update"); %> readonly>
		<input type=submit value=Submit>
		</form>
		<td><form action=RepEdit.jsp method=post>
		<input type=text input value=<% out.println(rFlights.getString("FlightNumber")); %>name=DeleteFlightNumber value=<% out.println(rFlights.getString("FlightNumber")); %> readonly>
		<input type=submit value=Delete>
		</form>
		<tr>
		
	<%	
	}
	%>
</table>
<br>
<br>
View passengers on the waiting list of a particular flight
<br>
Flight Number:
<br>
<form action=RepEdit.jsp method=post>
<input name=WaitFlightNumber>
<input type=submit value=Sumbit>
</form>
<br>
<br>
Produce a list of all flights for a given airport (departing and arriving flights)
<br>
Airport ID:
<br>
<form action=RepEdit.jsp method=post>
<input name=ListAirportID>
<input type=submit value=Sumbit>
</form>

<%


%>

<%
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
	} 
%>
	
	
</body>
</html>