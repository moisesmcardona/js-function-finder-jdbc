<%-- 
    Document   : welcome2
    Created on : May 20, 2015, 5:56:28 PM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%
    String sessiondate = request.getParameter("session");
    String userId = request.getParameter("id");
    session.setAttribute("session", sessiondate);
    session.setAttribute("id", userId);
%>
<!DOCTYPE html>
<jsp:useBean id="Config" class="functionCheck.config" scope="session" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JavaScript Function locator</title>
    </head>
    <body>
        <%
            String FirstName = null;
            String LastName = null;
            try {
                Connection conn, conn2;
                Statement stmt, stmt2;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM sessionid WHERE sessionid='" + sessiondate + userId + "' AND userid='" + userId + "'";
                ResultSet rs = stmt.executeQuery(sql);
                int GetUserId = 0;
                String GetSessionID = null;
                while (rs.next()) {
                    GetUserId = rs.getInt("userid");
                    GetSessionID = rs.getString("sessionid");
                }
                int SessionOK = 0;
                if (GetSessionID.trim().equals(sessiondate.trim())) {
                    SessionOK = 1;
                }
                conn2 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt2 = conn2.createStatement();
                String sql2 = "SELECT * FROM users WHERE ID='" + userId + "'";
                ResultSet rs2 = stmt2.executeQuery(sql2);
                while (rs2.next()) {
                    FirstName = rs2.getString("name");
                    LastName = rs2.getString("lastname");
                }
                if (FirstName == null && LastName == null) {
                    response.setStatus(response.SC_MOVED_TEMPORARILY);
                    response.setHeader("Location", "sessionerror.jsp");
                }
            } catch (SQLException se) {
                response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", "sessionerror.jsp");
                se.printStackTrace();
            } catch (Exception e) {
                response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", "sessionerror.jsp");
                e.printStackTrace();
            }
        %>
        <h1>Hello <% out.print(FirstName + " " + LastName); %></h1>
        <% out.print("<a href=\"history.jsp?session=" + sessiondate + "&id=" + userId + "\"> Check your usage</a> <br> <br> <br>"); %>
        Please enter your JavaScript code below to analyze:
        <% out.print("<form method=\"POST\" action=\"analyze.jsp?session=" + sessiondate + "&id=" + userId + "\" id=\"codeanalyzer\">");%>
        <textarea name="codefield" form="codeanalyzer" rows="25" cols="100"></textarea><br>
        <input type="submit" value="Analyze" />
    </form>
</body>
</html>
