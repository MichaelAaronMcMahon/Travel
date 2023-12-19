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
String Question = request.getParameter("Question");
String Answer = request.getParameter("Answer");
String Search = request.getParameter("Search");
%>



		<% try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/travelregistration", "root", "#Neshanic2850");
			

if (Search != null && Search.length() >= 1){
	%>
	<table>
	<tr>    
		<td>User </td>
		<td>Question </td>
		<td>Answer </td>

	</tr>
	
	<%		
	PreparedStatement p=con.prepareStatement("Select * from QuestionsAndAnswers WHERE Question LIKE ?");
	p.setString(1, "%" + Search + "%");
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
}
if (Question != null && Question.length() >= 1){
	PreparedStatement p=con.prepareStatement("Insert into QuestionsAndAnswers value(?, ?, ?)");
	p.setString(1, un);
	p.setString(2, Question);
	p.setString(3, "no answer");
	p.executeUpdate();
}

%>
<br>
Post Successful
<br>Back to Questions and Answers<br>
<form action=Questions.jsp method=post>
<input type=submit value=Back>
</form><br>
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