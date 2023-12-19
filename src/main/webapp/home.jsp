<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>



	<!--Group 62 Project Part 3: Login Page
		 Michael McMahon mam1198, Michael Israel mli29, Sean Patrick smp429, Fulton Wilcox frw14 -->
<meta charset="ISO-8859-1">
<title>Login</title>
	<style>
	form {
        .input-group {
            display: inline-block;
            margin-top: 10px;
            margin-bottom: 10px;
            width: calc(15% - 5px);
            display: flex;
            flex-direction: column;
        }
	</style>
</head>
<body>
<div>
<p>Login:</p>
<p></p>
</div>
<% session.setAttribute("user", null); %>
<% String un = (String)session.getAttribute("user");
out.println("Logged in user:");
out.print(un); %>
<form method=post>
	<div class="input-group">
		Username: <input type=text name=userName>
		Password: <input type=text name=password>
	</div>
	
	<div class="input-group">
		<input type="submit" formaction=show.jsp name = buttonClicked value="customer">
		<input type="submit" formaction=show.jsp name = buttonClicked value="admin">
		<input type="submit" formaction=show.jsp name = buttonClicked value="customer rep">
	</div>
</form>
</body>
</html>