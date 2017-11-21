<%-- 
    Document   : results
    Created on : May 2, 2015, 7:54:21 AM
    Author     : cardona_76937
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%@page import="java.sql.*" %>

<%
    String sessiondate = request.getParameter("session");
    String resultstamp = request.getParameter("result");
    String sessionid = request.getParameter("id");
    session.setAttribute("session", sessiondate);
    session.setAttribute("result", resultstamp);
    session.setAttribute("id", sessionid);
%>
<jsp:useBean id="Config" class="functionCheck.config" scope="session" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Results</title>
    </head>
    <body>
        <h1>Results!</h1>
        <%
            String sessioncontent = "";
            String sessionresult = null;
            try {
                Connection conn, conn2;
                Statement stmt, stmt2;
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM sessionresults WHERE sessionid='" + resultstamp + "'";
                ResultSet rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    sessionresult = rs.getString("sessionresults");
                }
                conn2 = DriverManager.getConnection(Config.DB_URL, Config.USER, Config.PASS);
                stmt2 = conn2.createStatement();
                String sql2 = "SELECT * FROM sessioncontent WHERE sessionid='" + resultstamp + "' ORDER BY ID ASC";
                ResultSet rs2 = stmt2.executeQuery(sql2);
                 while (rs2.next()) {
                    sessioncontent += rs2.getString("sessioncontent");
                }
            } catch (SQLException se) {
                //Handle errors for JDBC
                se.printStackTrace();
            } catch (Exception e) {
                //Handle errors for Class.forName
                e.printStackTrace();
            }
            out.print(sessionresult);
            out.print("<h2>Original Code</h2>");
            BufferedReader input2 = new BufferedReader(new StringReader(sessioncontent));
            String line2 = "";
            int linenumber = 1;
            while ((line2 = input2.readLine()) != null) {
                out.print(String.valueOf(linenumber) + ": ");
                out.println(StringEscapeUtils.escapeHtml4(line2));
                out.print("<br>");
                linenumber++;
            }
            out.flush();
            input2.close();
        %>

        </br></br> Thank you for using the JavaScript function finder. <% out.print("<a href=\"welcome.jsp?session=" + sessiondate + "&id=" + sessionid + "\"> Analyze another code.</a>"); %>
    </body>
</html>
