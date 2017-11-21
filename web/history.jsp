<%-- 
    Document   : history
    Created on : May 2, 2015, 8:29:27 AM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%
    String sessiondate = request.getParameter("session");
    String sessionid = request.getParameter("id");
    session.setAttribute("session", sessiondate);
    session.setAttribute("id", sessionid);
%>
<!DOCTYPE html>
<jsp:useBean id="Config" class="functionCheck.config" scope="session" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usage History</title>
    </head>
    <body>
        <%
           
            String FirstName = null;
            String LastName = null;
            int uses = 0;
            try {
                Connection conn, conn2, conn3;
                Statement stmt, stmt2, stmt3;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM sessionid WHERE sessionid='" + sessiondate + sessionid + "' AND userid='" + sessionid + "'";
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
                String sql2 = "SELECT * FROM users WHERE ID='" + sessionid + "'";
                ResultSet rs2 = stmt2.executeQuery(sql2);
                while (rs2.next()) {
                    FirstName = rs2.getString("name");
                    LastName = rs2.getString("lastname");
                }
                conn3 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt3 = conn3.createStatement();
                String sql3 = "SELECT * FROM uses WHERE userid='" + sessionid + "'";
                ResultSet rs3 = stmt3.executeQuery(sql3);
                while (rs3.next()) {
                    uses = rs3.getInt("uses");
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
        <h1>Usage History for  : <% out.print(FirstName + " " + LastName); %></h1>
        Total Usage: <% out.print(uses); %>
        </br></br>
        </br>
        Select a date below to check the code and results: </br>
        <%
            try {
                Connection conn4;
                Statement stmt4;
                Class.forName("com.mysql.jdbc.Driver");
                conn4 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt4 = conn4.createStatement();
                String sql4 = "SELECT timestamps.*, sessionid.*, sessionfinished.* FROM sessionid INNER JOIN timestamps ON sessionid.sessionid = timestamps.sessionid INNER JOIN sessionfinished  ON sessionid.sessionid = sessionfinished.sessionid WHERE sessionid.userid ='" + sessionid + "'";
                ResultSet rs4 = stmt4.executeQuery(sql4);
                while (rs4.next()) {
                    if (rs4.getInt("complete") == 1) {
                        out.println("<a href=\"results.jsp?session=" + sessiondate + "&id=" + sessionid + "&result=" + rs4.getString("sessionid") + "\">" + rs4.getString("timestamp") + "</a></br>");
                    }
                }
            } catch (SQLException se) {
                out.print(String.valueOf(se));
            } catch (Exception e) {
                out.print(String.valueOf(e));
            }
        %>
    </body>
</html>
