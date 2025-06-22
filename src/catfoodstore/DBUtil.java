package catfoodstore;

import java.sql.*;

public class DBUtil {
    
    public static Connection getConnection() {
        Connection con = null;
        String url = "jdbc:mysql://localhost:3306/catshop?useSSL=false&serverTimezone=UTC";
        String username = "root"; // Replace with your DB username
        String password = ""; // Replace with your DB password

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            // Attempt to establish a connection
            con = DriverManager.getConnection(url, username, password);
            System.out.println("Connection successful!"); // Debugging message
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("SQL Exception occurred while trying to connect.");
            e.printStackTrace();
        }
        
        return con; 
    }
}
