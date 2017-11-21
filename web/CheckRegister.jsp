<%-- 
    Document   : CheckRegister
    Created on : May 19, 2015, 7:04:12 PM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    String name=request.getParameter("name");
    String lastName=request.getParameter("lastname");
    String username=request.getParameter("username");
    String pass=request.getParameter("password");
    String email=request.getParameter("email");
    session.setAttribute("name", name);
    session.setAttribute("lastName", lastName);
    session.setAttribute("username", username); 
    session.setAttribute("password", pass);
    session.setAttribute("email", email);
%>
<jsp:useBean id="Check" class="functionCheck.CheckUserLogin2" scope="session" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Validating Username</title>
    </head>
    <body>
        <h1>Validating Username... Please wait</h1>
        <% 
            String url = "";
            String regOk = Check.register(name, lastName, username, pass, email);
            if (regOk == "1")
                url="RegSuccess.jsp";
            else
                url="register.jsp?error=" + regOk;
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", url); 
        %>
        
    </body>
</html>

