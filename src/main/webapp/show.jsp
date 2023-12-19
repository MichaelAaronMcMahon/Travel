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
			String button = request.getParameter("buttonClicked");
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			String username=request.getParameter("userName");
			String password=request.getParameter("password");
			PreparedStatement p;
			if(button.equals("customer")) p = con.prepareStatement("select Username from Customer where username=? and password=?");
			else if(button.equals("admin")) p = con.prepareStatement("select Username from Admin where username=? and password=?");
			else p = con.prepareStatement("select Username from CustomerRep where username=? and password=?");
			p.setString(1, username);
			p.setString(2,  password);
			ResultSet rs=p.executeQuery();
			if(rs.next()) {
				session.setAttribute("user", username);
				RequestDispatcher rd;
				if(button.equals("customer")) rd = request.getRequestDispatcher("welcome.jsp");
				else if(button.equals("admin")) rd = request.getRequestDispatcher("admin2.jsp");
				else rd = request.getRequestDispatcher("CustomerRep.jsp");
				rd.forward(request, response);
			}
			else {
				out.println("Wrong login<br>");
				out.println("<a href=home.jsp>Back</a>");
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
</body>
</html>