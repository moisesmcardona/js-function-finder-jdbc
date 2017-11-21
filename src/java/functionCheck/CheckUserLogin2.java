/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package functionCheck;

import java.sql.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
/**
 *
 * @author cardona_76937
 */
public class CheckUserLogin2 {

    //Database Connection

    public int checkLogin(String username, String password) {
        int uservalid = 0;
        try {
            Connection conn;
            Statement stmt;
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt = conn.createStatement();
            String sql = "SELECT users.*, passwords.* FROM users INNER JOIN passwords ON passwords.userid = users.ID WHERE users.username='" + username + "'";
            ResultSet rs = stmt.executeQuery(sql);
            String userexist = null;
            String UserPassword;
            while (rs.next()) {
                userexist = rs.getString("username");
                UserPassword = rs.getString("password");
                int useractive = rs.getInt("activated");
                if (userexist != null && useractive == 0) {
                    uservalid = 3;
                } else if (userexist != null && useractive == 1) {
                    if (UserPassword.equals(password)) {
                        uservalid = 1;
                    } else {
                        uservalid = 4;
                    }
                }
            }
            if (userexist == null)
                uservalid = 2;
        } catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
            uservalid = 5;
        } catch (Exception e) {
            //Handle errors for Class.forName
            e.printStackTrace();
            uservalid = 6;
        }
        return uservalid;
    }

    public String register(String name, String lastname, String username, String password, String email) {
        String ok = "1";
        try {
            Connection conn, conn2;
            Statement stmt, stmt2;
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt = conn.createStatement();
            String sql = "SELECT * FROM users WHERE username='" + username + "'";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                String userexist = rs.getString("username");
                int useractive = rs.getInt("activated");
                if (userexist != null && useractive == 0) {
                    ok = "2";
                } else if (userexist != null && useractive == 1) {
                    ok = "3";
                } else {
                    ok = "1";
                }
            }
            if (ok.equals("1")) {
                conn2 = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
                stmt2 = conn2.createStatement();
                String sql2 = "INSERT INTO users (name, lastname, username, email) VALUES ('" + name + "', '" + lastname + "', '" + username + "', '" + email + "'); INSERT INTO passwords (password, userid) VALUES ('" + password + "', (SELECT id from users WHERE username='" + username + "')); INSERT INTO uses (userid, uses) VALUES ((SELECT ID from users WHERE username='" + username + "'), 0);";
                stmt2.execute(sql2);
            }
        } catch (SQLException se) {
            //Handle errors for JDBC
            ok = String.valueOf(se);
        } catch (Exception e) {
            //Handle errors for Class.forName
            ok = String.valueOf(e);
        }
        if (ok.equals("1")) {
            //sends email
            String to = email;
            String from = config.mailFrom;
            String host = config.smtpRelay;
            Properties properties = System.getProperties();
            properties.setProperty("mail.smtp.host", host);
            Session session = Session.getDefaultInstance(properties);
            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(from));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject("Activate your account");
                message.setText("Hi, " + username + "," + "\n" + "You recently made an account to use our function locator program." + "\n" + "Please go to the following link to activate your account: "+ config.DomainName + "/activate.jsp?user=" + username);

                Transport.send(message);
                System.out.println("Sent message successfully....");
                ok = "1";
            } catch (MessagingException mex) {
                ok = String.valueOf(mex);
            }
        }
        return ok;
    }

    public int activate(String username) {
        int ok = 0;
        Connection conn, conn2 = null;
        Statement stmt, stmt2 = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
            stmt = conn.createStatement();
            String sql = "SELECT * FROM users WHERE username='" + username + "'";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                String userexist = rs.getString("username");
                int useractive = rs.getInt("activated");
                if (userexist != null && useractive == 0) {
                    ok = 1;
                } else if (userexist != null && useractive == 1) {
                    ok = 2;
                } else {
                    ok = 3;
                }
            }
            if (ok == 1) {
                conn2 = DriverManager.getConnection(config.DB_URL, config.USER, config.PASS);
                stmt2 = conn2.createStatement();
                String sql2 = "Update users SET activated=1";
                stmt2.executeUpdate(sql2);
            }
        } catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
        } catch (Exception e) {
            //Handle errors for Class.forName
            e.printStackTrace();
        }
        return ok;
    }
}
