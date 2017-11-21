/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package functionCheck;

import java.text.*;
import java.io.*;
import java.sql.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**
 *
 * @author cardona_76937
 */
public class CodeAnalyzer2 {
    public String codeAnalyze(String sessiondate, String sessionid, String code) {
        String Status = null;
        java.util.Date dNow = new java.util.Date();
        SimpleDateFormat ft = new SimpleDateFormat("MM-dd-yyyy - hh-mm-ss");
        String DateNow = ft.format(dNow);
        String Results = "";
        try {
            Connection conn, conn2, conn3, conn4;
            Statement stmt, stmt2, stmt3, stmt4;
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt = conn.createStatement();
            String sql = "INSERT INTO timestamps (sessionid, timestamp) VALUES ('" + sessiondate + sessionid + "', '" + DateNow + "')";
            stmt.executeUpdate(sql);
            conn2 = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt2 = conn2.createStatement();
            String sql2 = "UPDATE uses SET uses=uses+1 WHERE userid='" + sessionid + "'";
            stmt2.executeUpdate(sql2);
            BufferedReader SplitCode = new BufferedReader(new StringReader(code));
            String SplitCodeStr;
            String[] SplittedCode = null;
            conn3 = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt3 = conn3.createStatement();
            String EscapedSQL = "";
            while ((SplitCodeStr = SplitCode.readLine()) != null) {
                SplittedCode = SplitCodeStr.split("(?<=\\G.{50})");
                int i = 0;
                String sql3 = "";
                while (i < SplittedCode.length) {
                    if (i == SplittedCode.length - 1) {
                        SplittedCode[i] += "\n";
                    }
                    if (SplittedCode[i].contains("'")) {
                        EscapedSQL = SplittedCode[i].replaceAll("'", "\\\\\'");
                    }
                    else
                    {
                        EscapedSQL = SplittedCode[i];
                    }

                    sql3 += "INSERT INTO sessioncontent (sessioncontent, sessionid) VALUES ('" + EscapedSQL + "', '" + sessiondate + sessionid + "');";
                    i++;
                }
                stmt3.executeUpdate(sql3);
            }
            try {
                //Regular Expression Matching Code
                Pattern regex = Pattern.compile("\\s*function\\s\\w+\\(.*\\)(.*)", Pattern.DOTALL);
                // Pattern regex = Pattern.compile("\\s*function\\s+(.*)", Pattern.DOTALL);
                BufferedReader codein = new BufferedReader(new StringReader(code));
                String codeinstr;
                int line = 1;
                int found = 0;
                while ((codeinstr = codein.readLine()) != null) {
                    Matcher regexMatcher = regex.matcher(codeinstr);
                    if (regexMatcher.find()) {
                        Results += "Function found at line " + String.valueOf(line) + ": " + regexMatcher.group(0) + "<br>";
                        found = 1;
                    }
                    line++;
                }
                if (found == 0) {
                    Results = "No matches found for the inserted code<br>";
                }
                conn4 = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
                stmt4 = conn4.createStatement();
                String sql4 = "INSERT INTO sessionresults (sessionresults, sessionid) VALUES ('" + Results + "', '" + sessiondate + sessionid + "')";
                stmt4.executeUpdate(sql4);
            } catch (IOException e) {
                Status = String.valueOf(e);
            }
        } catch (SQLException se) {
            //Handle errors for JDBC
            Status = String.valueOf(se);
        } catch (Exception e) {
            //Handle errors for Class.forName
            Status = String.valueOf(e);
        }
        Status = DateNow;
        return Status;
    }

}
