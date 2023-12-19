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
	String username = request.getParameter("username");
	String Answer = request.getParameter("password");
	out.println(username);
	out.println(Answer);
%>



		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			if(username != null && username.length() >=1){
				PreparedStatement p = con.prepareStatement("update questionsandanswers set Answer = ? where Username = ?");
				p.setString(1, Answer);
				p.setString(2, username);
				p.executeUpdate();
			}

	%>

		<%		
			
		con.close();
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
		%>


<br>
Update Successful
<br>Back to Customer Representative home page<br>
<form action=CustomerRep.jsp method=post>
<input type=submit value=Back>
</form><br>
</body>
</html>