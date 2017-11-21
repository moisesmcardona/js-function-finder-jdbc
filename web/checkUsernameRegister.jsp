<%-- 
    Document   : checkUsernameRegister
    Created on : May 1, 2015, 2:39:45 PM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    String name=request.getParameter("username");
    String pass=request.getParameter("password");
    String logaction=request.getParameter("login");
    session.setAttribute("username", name); 
    session.setAttribute("password", pass);
    session.setAttribute("login", logaction);
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
            if (logaction != null && logaction.equals("Log In"))
            {
                int isValid = Check.checkLogin(name, pass);
                if (isValid == 1)
                    url="login1.jsp?name="+ name; //relative url for display jsp page
                else
                    url="index.jsp?error=" + isValid; //relative url for display jsp page
            }
            else if (logaction != null && logaction.equals("Register"))
            {
                url="register.jsp";
            }
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", url); 
        %>
        
    </body>
</html>
