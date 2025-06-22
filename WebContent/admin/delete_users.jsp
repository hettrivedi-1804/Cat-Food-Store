<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%
    // Check if the user is an admin
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("/catfood/home.jsp");
        return;
    }

    String message = "";
    String userIdParam = request.getParameter("id");

    if (userIdParam == null || userIdParam.isEmpty()) {
        message = "Invalid user ID.";
    } else {
        try {
            int userId = Integer.parseInt(userIdParam);

            // Establish database connection
            Class.forName("com.mysql.jdbc.Driver"); // Updated MySQL driver
            String url = "jdbc:mysql://localhost:3306/anime_figures"; // your DB name
            String username = "root"; // your MySQL username
            String password = ""; // your MySQL password

            Connection conn = DriverManager.getConnection(url, username, password);

            // Delete user from the database
            String deleteQuery = "DELETE FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(deleteQuery);
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                message = "User deleted successfully!";
            } else {
                message = "Error: User not found.";
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    // URL encode the message before redirecting to ensure safe URL
    String encodedMessage = URLEncoder.encode(message, "UTF-8");

    // Redirect with message after deletion
    response.sendRedirect("manage-users.jsp?message=" + encodedMessage);
%>
