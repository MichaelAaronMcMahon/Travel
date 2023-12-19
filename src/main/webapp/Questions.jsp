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
<% String un = (String)session.getAttribute("user");
out.println("Logged in user:");
out.print(un);
%>
<br><br>
<form method="post" action="QProcessor.jsp">
<input type="text" name="Question"/>Post a question <br><br>
<input type="submit" value="Submit" />
</form>
<br>
<form method="post" action="QProcessor.jsp">
<input type="text" name="Search"/>Search questions <br><br>
<input type="submit" value="Submit" />
</form>

		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			%>
			
<table>
		<tr>    
			<td>User </td>
			<td>Question </td>
			<td>Answer </td>

		</tr>
		
<%		
PreparedStatement p=con.prepareStatement("Select * from QuestionsAndAnswers");
ResultSet qna=p.executeQuery();
while(qna.next()){ %>
	<tr>
		<td><%= qna.getString("Username") %></td>
		<td><%= qna.getString("Question") %></td>
		<td><%= qna.getString("Answer") %></td>
	</tr>
	<%} %>

</table>
			
			<%
			con.close();
			
} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		
		
		%>



</body>
</html>