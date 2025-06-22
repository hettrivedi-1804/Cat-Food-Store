<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("home.jsp");
        return;
    }

    int userId = Integer.parseInt(request.getParameter("id"));
    String message = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/anime_figures", "root", "");

        String query = "DELETE FROM users WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, userId);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            message = "User deleted successfully!";
        } else {
            message = "User not found.";
        }

        ps.close();
        conn.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }

    response.sendRedirect("manage_users.jsp?message=" + message);
%>
