<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder, java.net.URLDecoder" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("/catfood/home.jsp");
        return;
    }

    List<Map<String, Object>> users = new ArrayList<>();
    String message = request.getParameter("message"); // Get message from URL

    // Decode message if exists
    if (message != null) {
        try {
            message = URLDecoder.decode(message, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace(new java.io.PrintWriter(out)); // Show error for debugging
        }
    }

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Updated JDBC driver for newer versions

        // ✅ Update with your actual DB credentials
        String url = "jdbc:mysql://localhost:3306/catshop"; // Your DB name
        String username = "root"; // Your MySQL username
        String password = ""; // Your MySQL password

        Connection conn = DriverManager.getConnection(url, username, password);
        String query = "SELECT id, username, is_admin FROM users";
        PreparedStatement ps = conn.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> user = new HashMap<>();
            user.put("id", rs.getInt("id"));
            user.put("username", rs.getString("username"));
            user.put("is_admin", rs.getBoolean("is_admin"));
            users.add(user);
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out)); // Show error for debugging
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel – Manage Users</title>
	<%@ include file="header.jsp" %>
    <style>
        body {
            background-color: #1a202c; /* Dark background */
            color: white;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding: 2rem;
        }

        h2 {
            font-size: 2.5rem;
            font-weight: 600;
            color: #e2e8f0;
            margin-bottom: 2rem;
        }

        .message {
            background-color: #38a169; /* Green background */
            color: white;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .add-user-btn {
            background-color: #5a67d8; /* Indigo background */
            color: white;
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 2rem;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }

        .add-user-btn:hover {
            background-color: #434190; /* Darker Indigo on hover */
        }

        .table-container {
            background-color: #2d3748; /* Dark table background */
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #4a5568;
        }

        th {
            background-color: #4c51bf; /* Indigo header background */
            color: white;
        }

        td {
            color: #e2e8f0;
        }

        tr:hover {
            background-color: #4a5568; /* Hover effect on rows */
        }

        .edit-btn {
            color: #63b3ed; /* Light blue */
            text-decoration: none;
        }

        .edit-btn:hover {
            color: #3182ce; /* Darker blue on hover */
        }

        .delete-btn {
            color: #f56565; /* Red */
            text-decoration: none;
        }

        .delete-btn:hover {
            color: #e53e3e; /* Darker red on hover */
        }
    </style>
</head>
<body>

    <div class="container">
        

        <div class="flex-1">
            <!-- Displaying the message -->
            <%
                if (message != null && !message.isEmpty()) {
            %>
            <div class="message">
                <%= message %>
            </div>
            <% 
                }
            %>

            <h2>Manage Users</h2>

            <a href="add_user.jsp" class="add-user-btn">
                + Add New User
            </a>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Map<String, Object> user : users) {
                                int id = (int) user.get("id");
                                String uname = (String) user.get("username");
                                boolean admin = (boolean) user.get("is_admin");
                        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= uname %></td>
                            <td class="<%= admin ? "text-green-500 font-semibold" : "text-gray-400" %>">
                                <%= admin ? "Admin" : "User" %>
                            </td>
                            <td>
                                <a href="edit_user.jsp?id=<%= id %>" class="edit-btn">Edit</a> 
                                | 
                                <a href="delete_users.jsp?id=<%= id %>" class="delete-btn">Delete</a>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>
