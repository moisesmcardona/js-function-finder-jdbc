<%-- 
    Document   : welcome
    Created on : May 1, 2015, 2:55:46 PM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%
    String name = request.getParameter("name");
    session.setAttribute("name", name);
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
            java.util.Date dNow = new java.util.Date();
            SimpleDateFormat ft = new SimpleDateFormat("MM-dd-yyyy - hh-mm-ss");
            String DateNow = ft.format(dNow);
            int userId = 0;
            try {
                Connection conn, conn2, conn3;
                Statement stmt, stmt2, stmt3;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM users WHERE username='" + name + "'";
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    userId = rs.getInt("ID");
                }
                conn2 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt2 = conn2.createStatement();
                String sql2 = "INSERT INTO sessionid (sessionid, userid) VALUES ('" + DateNow + userId + "', '" + userId + "')";
                stmt2.executeUpdate(sql2);
                conn3 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt3 = conn3.createStatement();
                String sql3 = "INSERT INTO sessionfinished (sessionid, complete) VALUES ('" + DateNow + userId + "', 0)";
                stmt3.executeUpdate(sql3);
            } catch (SQLException se) {
                //Handle errors for JDBC
                se.printStackTrace();
            } catch (Exception e) {
                //Handle errors for Class.forName
                e.printStackTrace();
            }
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", "welcome.jsp?session=" + DateNow + "&id=" + userId);
        %>

    </form>

</body>
</html>
