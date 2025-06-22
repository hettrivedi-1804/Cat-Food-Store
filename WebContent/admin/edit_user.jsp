<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("/catfood/home.jsp");
        return;
    }

    String message = "";
    int userId = Integer.parseInt(request.getParameter("id"));
    String username = "";
    boolean isAdminUser = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        username = request.getParameter("username");
        isAdminUser = "on".equals(request.getParameter("is_admin"));

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/catshop", "root", "");

            String query = "UPDATE users SET username = ?, is_admin = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setBoolean(2, isAdminUser);
            ps.setInt(3, userId);
            ps.executeUpdate();

            ps.close();
            conn.close();
            message = "User updated successfully!";
            response.sendRedirect("manage-users.jsp"); // Redirect to manageuser page after successful edit
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    } else {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/anime_figures", "root", "");

            String query = "SELECT username, is_admin FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                username = rs.getString("username");
                isAdminUser = rs.getBoolean("is_admin");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans min-h-screen">
    <div class="flex min-h-screen">
        <%@ include file="/admin/header.jsp" %>

        <div class="flex-1 p-10">
            <h2 class="text-2xl font-bold mb-6">Edit User</h2>

            <form method="POST" class="space-y-4">
                <div>
                    <label for="username" class="block">Username</label>
                    <input type="text" id="username" name="username" value="<%= username %>" required class="border px-4 py-2 rounded w-full">
                </div>
                <div>
                    <label for="is_admin" class="inline-flex items-center">
                        <input type="checkbox" id="is_admin" name="is_admin" <%= isAdminUser ? "checked" : "" %> class="mr-2">
                        Admin
                    </label>
                </div>
                <div>
                    <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Update User</button>
                </div>
            </form>

            <% if (message != "") { %>
                <p class="text-green-600 mt-4"><%= message %></p>
            <% } %>

            <!-- Back to Manage Users Button -->
            <div class="mt-4">
                <a href="manage-users.jsp" class="inline-block bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Manage Users</a>
            </div>
        </div>
    </div>
</body>
</html>
