<%-- 
    Document   : register
    Created on : May 19, 2015, 3:55:48 PM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration</title>
    </head>
    <body>
        <%
            String errorMessage = "Please fill the form below:";
            int errorCode = 0;
            if (request.getParameter("error") != null) {
                errorCode = Integer.parseInt(request.getParameter("error"));
            }
            if (errorCode == 2) {
                errorMessage = "Username already exist but it's not activated. Did you register? Check your email for the activation link.";
            } else if (errorCode == 3) {
                errorMessage = "Username already exist.";
            }
            out.print(errorMessage);
        %>
        <form method="post" action="CheckRegister.jsp">
            First Name: <input name="name" type="text" /></br>
            Last Name: <input name="lastname" type="text" /></br>
            Username: <input name="username" type="text" /></br>
            Password: <input name="password" type="password" /></br>
            Email: <input name="email" type="text" /></br>
            <input type="submit" name="login" value="Register"/>
        </form>
    </body>
</html>
