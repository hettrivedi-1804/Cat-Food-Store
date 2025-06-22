<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.HashMap, catfoodstore.DBUtil" %> <!-- Add java.util.HashMap import here -->

<%
    String message = "";
    String orderId = request.getParameter("id");
    HashMap<String, String> order = new HashMap<String, String>();  // Now this should work

    // Fetch the order details if the orderId is provided
    if (orderId != null && !orderId.isEmpty()) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection(); // Make sure DBUtil returns a valid connection
            String sql = "SELECT * FROM orders WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(orderId));
            rs = stmt.executeQuery();

            // If the order exists, populate the fields
            if (rs.next()) {
                order.put("id", rs.getString("id"));
                order.put("user_id", rs.getString("user_id"));
                order.put("product_id", rs.getString("product_id"));
                order.put("quantity", rs.getString("quantity"));
                order.put("total_price", rs.getString("total_price"));
                order.put("status", rs.getString("status"));
                order.put("order_date", rs.getString("order_date"));
            } else {
                message = "Order not found!";
            }
        } catch (SQLException e) {
            message = "Error fetching order: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Log to a log file instead
            }
        }
    }

    // Handle the form submission to update the order
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("user_id");
        String productId = request.getParameter("product_id");
        String quantity = request.getParameter("quantity");
        String totalPrice = request.getParameter("total_price");
        String status = request.getParameter("status");

        if (orderId != null && !orderId.isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DBUtil.getConnection(); // Ensure DBUtil returns a valid connection
                String updateSql = "UPDATE orders SET user_id = ?, product_id = ?, quantity = ?, total_price = ?, status = ? WHERE id = ?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setString(1, userId);
                stmt.setString(2, productId);
                stmt.setInt(3, Integer.parseInt(quantity));
                stmt.setString(4, totalPrice);
                stmt.setString(5, status);
                stmt.setInt(6, Integer.parseInt(orderId));

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    message = "Order updated successfully!";
                } else {
                    message = "Error: Order not found!";
                }
            } catch (SQLException e) {
                message = "Error updating order: " + e.getMessage();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace(); // Log to a log file instead
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit and Update Order</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-10">
<%@ include file="header.jsp" %>

    <h2 class="text-2xl font-bold mb-6">Edit Order</h2>

    <% if (!message.isEmpty()) { %>
        <div class="bg-red-100 text-red-800 p-4 rounded mb-4">
            <%= message %>
        </div>
    <% } %>

    <!-- Order Edit Form -->
    <form method="post" action="edit_order.jsp" class="space-y-4">
        <input type="hidden" name="id" value="<%= order.get("id") != null ? order.get("id") : "" %>" />

        <label class="block">
            <span class="text-gray-700">User ID:</span>
            <input type="text" name="user_id" value="<%= order.get("user_id") != null ? order.get("user_id") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
        </label>

        <label class="block">
            <span class="text-gray-700">Product ID:</span>
            <input type="text" name="product_id" value="<%= order.get("product_id") != null ? order.get("product_id") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
        </label>

        <label class="block">
            <span class="text-gray-700">Quantity:</span>
            <input type="number" name="quantity" value="<%= order.get("quantity") != null ? order.get("quantity") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
        </label>

        <label class="block">
            <span class="text-gray-700">Total Price:</span>
            <input type="text" name="total_price" value="<%= order.get("total_price") != null ? order.get("total_price") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
        </label>

        <label class="block">
            <span class="text-gray-700">Status:</span>
            <input type="text" name="status" value="<%= order.get("status") != null ? order.get("status") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
        </label>

        <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">Update Order</button>
    
    	 <!-- Back to Manage Users Button -->
            <div class="mt-4">
                <a href="manage-orders.jsp" class="inline-block bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">Back to Manage Orders</a>
            </div>
    </form>

</body>
</html>
