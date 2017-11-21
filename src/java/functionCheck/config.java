/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package functionCheck;

/**
 *
 * @author cardo
 */
public class config {
     //email details
     public static String DomainName = "localhost"; //jsp server domain
     public static String mailFrom = "noreply@yourdomain.com";
     public static String smtpRelay = "smtp-relay.gmail.com";
     //MySQL Details
     public static String JDBC_DRIVER = "com.mysql.jdbc.Driver";
     public static String DB_URL = "jdbc:mysql://localhost/javacodecheck?allowMultiQueries=true";
     public static String USER = "user";
     public static String PASS = "pass";
}
