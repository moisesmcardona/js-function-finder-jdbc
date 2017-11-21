<%-- 
    Document   : analyze
    Created on : May 2, 2015, 6:03:01 AM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%
    String code = request.getParameter("codefield");
    String sessiondate = request.getParameter("session");
    String sessionid = request.getParameter("id");
    session.setAttribute("codefield", code);
    session.setAttribute("session", sessiondate);
    session.setAttribute("id", sessionid);
%>
<jsp:useBean id="Analyze" class="functionCheck.CodeAnalyzer2" scope="session" />
<jsp:useBean id="Config" class="functionCheck.config" scope="session" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Analyzing Code</title>
    </head>
    <body>
        <h1>Analyzing Code</h1>
        <%
            java.util.Date dNow = new java.util.Date();
            SimpleDateFormat ft = new SimpleDateFormat("MM-dd-yyyy - hh-mm-ss");
            String DateNow = ft.format(dNow);
            int sessionfinished = 0;
            try {
                Connection conn, conn2, conn3;
                Statement stmt, stmt2, stmt3;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM sessionfinished WHERE sessionid='" + sessiondate + sessionid + "'";
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    sessionfinished = rs.getInt("complete");
                }
                if (sessionfinished == 1) {
                    conn2 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                    stmt2 = conn2.createStatement();
                    String sql2 = "INSERT INTO sessionid (sessionid, userid) VALUES ('" + DateNow + sessionid + "', '" + sessionid + "')";
                    stmt2.executeUpdate(sql2);
                    conn3 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                    stmt3 = conn3.createStatement();
                    String sql3 = "INSERT INTO sessionfinished (sessionid, complete) VALUES ('" + DateNow + sessionid + "', 0)";
                    stmt3.executeUpdate(sql3);
                    sessiondate = DateNow;
                }
            } catch (SQLException se) {
                //Handle errors for JDBC
                se.printStackTrace();
            } catch (Exception e) {
                //Handle errors for Class.forName
                e.printStackTrace();
            }
            String url = "";
            ;
            Analyze.codeAnalyze(sessiondate, sessionid, code);
            url = "results.jsp?session=" + sessiondate + "&id=" + sessionid + "&result=" + sessiondate + sessionid; //relative url for display jsp page
            try {
                Connection conn;
                Statement stmt;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "UPDATE sessionfinished SET complete=1 WHERE sessionid='" + sessiondate + sessionid + "'";
               stmt.executeUpdate(sql);
               
            } catch (SQLException se) {
                //Handle errors for JDBC
                se.printStackTrace();
            } catch (Exception e) {
                //Handle errors for Class.forName
                e.printStackTrace();
            }
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", url);
        %>
    </body>
</html>
