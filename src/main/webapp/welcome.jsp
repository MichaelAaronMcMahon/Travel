<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Welcome</title>
</head>
<body>
<p>Login Successful<br></p>
<% String un = (String)session.getAttribute("user");
out.println("Logged in user:");
out.print(un);
%>

		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			PreparedStatement p=con.prepareStatement("select TicketNumber from WaitingListForTicket where Username = ?");
			p.setString(1, un);
			ResultSet rsWait = p.executeQuery();
			while (rsWait.next()){
				String tn = rsWait.getString("TicketNumber");
				PreparedStatement pRem=con.prepareStatement("select RemainingSeats from ticket where TicketNumber = ?");
				pRem.setString(1, tn);
				ResultSet rsRem=pRem.executeQuery();
				int rem;
				if(rsRem.next()){
					rem = rsRem.getInt("RemainingSeats");
					PreparedStatement pReg=con.prepareStatement("select count(*) from CustomersForTicket where TicketNumber = ?");
					pReg.setString(1, tn);
					ResultSet rsReg=pReg.executeQuery();
					if(rsReg.next()){
						int reg = rsReg.getInt("count(*)");
						if(rem > reg){
							%> <br> <%
							out.println("!!! NOTIFICATION !!!");
							%> <br> <%
							out.println("Ticket number " + tn + " which you are on the waiting list for now has availability. Would you like to buy the ticket?");
							%> <form action=Buy.jsp method=post>
								<input value=<% out.println(tn); %> name=TicketNumber>
								<input type=submit value=Buy>
								</form> 
							<%
							
						}
					}
					pReg.close();
					rsReg.close();
				}
				pRem.close();
				rsRem.close();
			}
			PreparedStatement pAirportID = con.prepareStatement("select AirportID from Airport");
			ResultSet rAirportID = pAirportID.executeQuery();
			%> <br><br> <%
			out.println("AirportIDs: ");
			while(rAirportID.next()){
				out.println(rAirportID.getString("AirportID"));
			}
			
			p.close();
			rsWait.close();
			con.close();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
		%>

<p>Shop Flights<br></p>
<p>Filters:<br></p>
<form method="post" action="flights.jsp">

			
			<p>Search flights between two airports</p>
		  <input name="DepartureAirportID" />Departure Airport ID<br>
		  <input name="ArrivalAirportID" />Arrival Airport ID<br>
		  <br>
			
			<p>Round Trip or One Way</p>
		  <input type="radio" name="roundorone" value="OneWay"/>One Way
		  <input type="radio" name="roundorone" value="RoundTrip"/>Round Trip<br>
		  <br>
		  
		  

		   Departure Date

		   +/- 3 days flexibility 
		   <input type="checkbox" name="error" value="Yes"/><br>
		   <input type="date" name="date" min="2023-01-01" max="2024-12-31" /> <br><br>
		   <input type="text" name="price"/>Max Price <br><br>
		   <input type="text" name="NumStops"/>Number of stops <br><br>
		   <input type="time" name="takeofftime"/>Take off time <br><br>
		   <input type="time" name="landingtime"/>Landing time <br><br>
		   Airline<br>
		   <input type="checkbox" name="AA" value="AA"/>AA
		   <input type="checkbox" name="DA" value="DA"/>DA
		   <input type="checkbox" name="FA" value="FA"/>FA
		   <input type="checkbox" name="JA" value="JA"/>JA
		   <input type="checkbox" name="SA" value="SA"/>SA<br><br>
		   Sort by: <br>
		   <input type="radio" name="Sort" value="PriceSort"/>Price
		   <input type="radio" name="Sort" value="TakeoffSort"/>Takeoff time
		   <input type="radio" name="Sort" value="LandingSort"/>Landing Time
		   <input type="radio" name="Sort" value="DurationSort"/>Duration of flight
		   
		  <br><br><input type="submit" value="View Flights" />
		</form>
			
			<br><br><form action=CustomerReservations.jsp method=post>
			<input type="submit" value="View Your Reservations">
			</form><br>
			
			<br><br><form action=Questions.jsp method=post>
			<input type="submit" value="Questions and Answers">
			</form><br>
			

<br><form action=home.jsp method=post>
	<input type="submit" value="Log out">
	
</form>

</body>
</html>