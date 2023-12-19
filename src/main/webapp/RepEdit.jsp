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
<% 

String UpdateAirlineID = request.getParameter("UpdateAirlineID");
String NewAirlineName = request.getParameter("NewAirlineName");
String DeleteAirlineID = request.getParameter("DeleteAirlineID");
String AddAirlineID = request.getParameter("AddAirlineID");
String AddAirlineName = request.getParameter("AddAirlineName");
String AddAircraftID = request.getParameter("AddAircraftID");
String AddAircraftName = request.getParameter("AddAircraftName");
String AddAircraftSeats = request.getParameter("AddAircraftSeats");
String UpdateAircraftID = request.getParameter("UpdateAircraftID");
String UpdateAircraftSeats = request.getParameter("UpdateAircraftSeats");
String NewAircraftName = request.getParameter("NewAircraftName");
String DeleteAircraftID = request.getParameter("DeleteAircraftID");
String DeleteAircraftSeats = request.getParameter("DeleteAircraftSeats");

String fFlightAdd = request.getParameter("fFlightAdd");
String fFlightUpdate = request.getParameter("fFlightUpdate");
String DeleteFlightNumber = request.getParameter("DeleteFlightNumber");
String fFlightNumber = request.getParameter("fFlightNumber");
String fOperationDays = request.getParameter("fOperationDays");
String fSeats = request.getParameter("fSeats");
String fAirlineID = request.getParameter("fAirlineID");
String fDepartureAirportID = request.getParameter("fDepartureAirportID");
String fDestinationAirportID = request.getParameter("fDestinationAirportID");
String fDomesticOrInternational = request.getParameter("fDomesticOrInternational");
String fDepartureTime = request.getParameter("fDepartureTime");
String fArrivalTime = request.getParameter("fArrivalTime");

String WaitFlightNumber = request.getParameter("WaitFlightNumber");
String ListAirportID = request.getParameter("ListAirportID");


%>

		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			if(WaitFlightNumber != null && WaitFlightNumber.length() >= 1){
				PreparedStatement pWaiting = con.prepareStatement("Select Username from waitinglistforticket join flightsforticket using (TicketNumber) where FlightNumber = ?");
				pWaiting.setString(1, WaitFlightNumber);
				ResultSet rWaiting = pWaiting.executeQuery();
				while(rWaiting.next()){
					out.println(rWaiting.getString("Username"));
				}
			}
			if(ListAirportID != null && ListAirportID.length() >= 1){
				PreparedStatement pListAirport = con.prepareStatement("Select * from Flight where DepartureAirportID = ? OR DestinationAirportID = ?");
				pListAirport.setString(1, ListAirportID);
				pListAirport.setString(2, ListAirportID);
				ResultSet rListAirport = pListAirport.executeQuery();
				%>
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
				<%
				while (rListAirport.next()){					
					%>

					
					<td><% out.println(rListAirport.getString("FlightNumber")); %>
					<td><% out.println(rListAirport.getString("OperationDays")); %>
					<td><% out.println(rListAirport.getString("Seats")); %>
					<td><% out.println(rListAirport.getString("AirlineID")); %>
					<td><% out.println(rListAirport.getString("DepartureAirportID")); %>
					<td><% out.println(rListAirport.getString("DestinationAirportID")); %>
					<td><% out.println(rListAirport.getString("DomesticOrInternational")); %>
					<td><% out.println(rListAirport.getString("DepartureTime")); %>
					<td><% out.println(rListAirport.getString("ArrivalTime")); %>
					<tr>
				<%} %>

			<%
			}
			if(AddAircraftID != null && AddAircraftID.length() >= 1){
				PreparedStatement pAddAircraft = con.prepareStatement("INSERT INTO Aircraft VALUE (?, ?, ?)");
				pAddAircraft.setString(1, AddAircraftSeats);
				pAddAircraft.setString(2, AddAircraftID);
				pAddAircraft.setString(3, AddAircraftName);
				pAddAircraft.executeUpdate();
			}
			if (UpdateAircraftID != null && UpdateAircraftID.length() >= 1){
				PreparedStatement pAircraftEdit = con.prepareStatement("UPDATE Aircraft SET AircraftName = ? WHERE AirlineID = ? AND Seats = ?");
				pAircraftEdit.setString(1, NewAircraftName);
				pAircraftEdit.setString(2, UpdateAircraftID);
				pAircraftEdit.setString(3, UpdateAircraftSeats);
				pAircraftEdit.executeUpdate();
			}
			if (DeleteAircraftID != null && DeleteAircraftID.length() >=1){
				PreparedStatement pAircraftDelete = con.prepareStatement("DELETE FROM Aircraft WHERE AirlineID = ? AND Seats = ?");
				pAircraftDelete.setString(1, DeleteAircraftID);
				pAircraftDelete.setString(2, DeleteAircraftSeats);
				pAircraftDelete.executeUpdate();
			}
			if(AddAirlineID != null && AddAirlineID.length() >= 1){
				PreparedStatement pAddAirline = con.prepareStatement("INSERT INTO Airport VALUE (?, ?)");
				pAddAirline.setString(1, AddAirlineID);
				pAddAirline.setString(2, AddAirlineName);
				pAddAirline.executeUpdate();
			}
			if (UpdateAirlineID != null && UpdateAirlineID.length() >=1){
				PreparedStatement pAirlineEdit = con.prepareStatement("UPDATE Airport SET AirportName = ? WHERE AirportID = ?");
				pAirlineEdit.setString(1, NewAirlineName);
				pAirlineEdit.setString(2, UpdateAirlineID);
				pAirlineEdit.executeUpdate();
			}
			if (DeleteAirlineID != null && DeleteAirlineID.length() >=1){
				PreparedStatement pAirlineDelete = con.prepareStatement("DELETE FROM Airport WHERE AirportID = ?");
				pAirlineDelete.setString(1, DeleteAirlineID);
				pAirlineDelete.executeUpdate();
			}
			if(fFlightAdd != null && fFlightAdd.length() >= 1){
				PreparedStatement pAddFlight = con.prepareStatement("INSERT INTO Flight VALUE (?, ?, ?, ?, ?, ?, ?, ?, ?)");
				pAddFlight.setString(1, fOperationDays);
				pAddFlight.setString(2, fDomesticOrInternational);
				pAddFlight.setString(3, fSeats);
				pAddFlight.setString(4, fAirlineID);
				pAddFlight.setString(5, fFlightNumber);
				pAddFlight.setString(6, fDepartureAirportID);
				pAddFlight.setString(7, fDestinationAirportID);
				pAddFlight.setString(8, fDepartureTime);
				pAddFlight.setString(9, fArrivalTime);
				pAddFlight.executeUpdate();
			}
			if (fFlightUpdate != null && fFlightUpdate.length() >=1){
				PreparedStatement pFlightEdit = con.prepareStatement("UPDATE Flight SET OperationDays = ?, DomesticOrInternational = ?, Seats = ?, AirlineID = ?, DepartureAirportID = ?, DestinationAirportID = ?, DepartureTime = ?, ArrivalTime = ? WHERE FlightNumber = ? ");
				pFlightEdit.setString(1, fOperationDays);
				pFlightEdit.setString(2, fDomesticOrInternational);
				pFlightEdit.setString(3, fSeats);
				pFlightEdit.setString(4, fAirlineID);
				pFlightEdit.setString(5, fDepartureAirportID);
				pFlightEdit.setString(6, fDestinationAirportID);
				pFlightEdit.setString(7, fDepartureTime);
				pFlightEdit.setString(8, fArrivalTime);
				pFlightEdit.setString(9, fFlightNumber);
				pFlightEdit.executeUpdate();
			}
			if (DeleteFlightNumber != null && DeleteFlightNumber.length() >=1){
				PreparedStatement pFlightDelete = con.prepareStatement("DELETE FROM Flight WHERE FlightNumber = ?");
				pFlightDelete.setString(1, DeleteFlightNumber);
				pFlightDelete.executeUpdate();
			}

		con.close();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
		%>



</body>

<%
if(WaitFlightNumber == null && ListAirportID == null){
	%>
	Update Complete
	<%
}
%>

</html>