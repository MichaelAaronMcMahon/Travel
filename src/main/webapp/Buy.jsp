<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
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
			String dtn = request.getParameter("DeleteTicketNumber");
			String tn = request.getParameter("TicketNumber");
			String un = (String)session.getAttribute("user");
			String UserReservedFor = request.getParameter("UserReservedFor");
			if (UserReservedFor != null && UserReservedFor.length()>=1){
				un = UserReservedFor;
			}
			if(tn != null && dtn == null){	
				PreparedStatement p=con.prepareStatement("select RemainingSeats from ticket where TicketNumber = ?");
				p.setString(1, tn);
				ResultSet rsRem=p.executeQuery();
				int rem;
				if(rsRem.next()){
					rem = rsRem.getInt("RemainingSeats");
					PreparedStatement p1=con.prepareStatement("select count(*) from CustomersForTicket where TicketNumber = ?");
					p1.setString(1, tn);
					ResultSet rsReg=p1.executeQuery();
					if(rsReg.next()){
						int reg = rsReg.getInt("count(*)");
						if (reg + 1 > rem){
							out.println("The flight is booked, you have been added to the waiting list.");
							PreparedStatement p2=con.prepareStatement("insert into WaitingListForTicket value (?, ?)");
							p2.setString(1, un);
							p2.setString(2, tn);
							p2.executeUpdate();
							p2.close();
						}
						else{
							out.println("Purchase successful, this ticket has been added to your reservations.");
							PreparedStatement p2=con.prepareStatement("insert into CustomersForTicket value (?, ?)");
							p2.setString(1, un);
							p2.setString(2, tn);
							p2.executeUpdate();
							p2.close();
							PreparedStatement pWait=con.prepareStatement("delete from WaitingListForTicket where Username = ? AND TicketNumber = ?");
							pWait.setString(1, un);
							pWait.setString(2, tn);
							pWait.executeUpdate();
							//PreparedStatement p3=con.prepareStatement("insert into FlightsForTicket value (?, ?)");
							/*PreparedStatement pWait=con.prepareStatement("select TicketNumber from WaitingListForTicket where Username = ?");
							pWait.setString(1, un);
							ResultSet rsWait = pWait.executeQuery();
							while(rsWait.next()){
								String waitTN = rsWait.getString("TicketNumber");
								if(tn==waitTN){
									PreparedStatement pRemove=con.prepareStatement("delete from WaitingListForTicket where TicketNumber = ? AND ");
									pRemove.setString(1, tn);
									pRemove.executeUpdate();
								}
							}*/
							pWait.close();
						}
					}
					%>
					<form action=flights.jsp method=post>
					<input type="submit" value="Back to flights">
					</form>
					<form action=welcome.jsp method=post>
					<input type="submit" value="Back to home">
					</form>
					<% 
					rsReg.close();
					p1.close();
					
				}

				
				
				p.close();
				rsRem.close();
				con.close();
			}
			if(tn == null && dtn != null){
				out.println("Your reservation has been canceled.");
				PreparedStatement pDel = con.prepareStatement("delete from CustomersForTicket where Username = ? AND TicketNumber = ?");
				pDel.setString(1, un);
				pDel.setString(2, dtn);
				pDel.executeUpdate();
				%>
				<form action=flights.jsp method=post>
				<input type="submit" value="Back to flights">
				</form>
				<form action=welcome.jsp method=post>
				<input type="submit" value="Back to home">
				</form>
				<% 
				pDel.close();
				
			}
			
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
		%>
</body>
</html>


