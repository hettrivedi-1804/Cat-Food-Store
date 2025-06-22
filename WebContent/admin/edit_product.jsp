<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.HashMap" %>
<%@ page import="catfoodstore.DBUtil" %>

<%
    String message = "";
    String productId = request.getParameter("id");
    HashMap<String, String> product = new HashMap<>();

    // Fetch product details if an ID is provided
    if (productId != null && !productId.isEmpty()) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM products WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(productId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                product.put("id", rs.getString("id"));
                product.put("name", rs.getString("name"));
                product.put("description", rs.getString("description"));
                product.put("price", rs.getString("price"));
                product.put("image_url", rs.getString("image_url"));
            } else {
                message = "Product not found!";
            }
        } catch (SQLException e) {
            message = "Error fetching product: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-10">
<%@ include file="header.jsp" %>

<h2 class="text-2xl font-bold mb-6">Edit Product</h2>

<% if (!message.isEmpty()) { %>
    <div class="bg-red-100 text-red-800 p-4 rounded mb-4">
        <%= message %>
    </div>
<% } %>

<!-- Edit Product Form -->
<form method="post" action="edit_product.jsp?id=<%= product.get("id") %>" class="space-y-4">
    <input type="hidden" name="id" value="<%= product.get("id") != null ? product.get("id") : "" %>" />

    <label class="block">
        <span class="text-gray-700">Name:</span>
        <input type="text" name="name" value="<%= product.get("name") != null ? product.get("name") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
    </label>

    <label class="block">
        <span class="text-gray-700">Description:</span>
        <input type="text" name="description" value="<%= product.get("description") != null ? product.get("description") : "" %>" class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
    </label>

    <label class="block">
        <span class="text-gray-700">Price:</span>
        <input type="text" name="price" value="<%= product.get("price") != null ? product.get("price") : "" %>" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
    </label>

    <label class="block">
        <span class="text-gray-700">Image URL:</span>
        <input type="text" name="image_url" value="<%= product.get("image_url") != null ? product.get("image_url") : "" %>" class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
    </label>

    <button type="submit" name="action" value="update" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
        Update Product
    </button>
</form>

<% 
    // Handle form submission
    String action = request.getParameter("action");
    if ("update".equals(action)) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");
        String imageUrl = request.getParameter("image_url");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE products SET name = ?, description = ?, price = ?, image_url = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setString(3, price);
            stmt.setString(4, imageUrl);
            stmt.setInt(5, Integer.parseInt(productId));

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("manage-product.jsp");
            } else {
                message = "Error updating product!";
            }
        } catch (SQLException e) {
            message = "Error updating product: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
