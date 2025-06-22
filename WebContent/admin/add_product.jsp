<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder, catfoodstore.DBUtil" %>

<%
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String price = request.getParameter("price");
    String imageUrl = request.getParameter("image_url");

    if (name != null && price != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        String message = "";

        try {
            if (name.isEmpty() || price.isEmpty()) {
                message = "Name and Price are required fields.";
            } else {
                conn = DBUtil.getConnection();
                String sql = "INSERT INTO products (name, description, price, image_url) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, description);
                stmt.setString(3, price);
                stmt.setString(4, imageUrl);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    message = "Product added successfully!";
                } else {
                    message = "Error adding product.";
                }
            }
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Redirect after inserting
        response.sendRedirect("manage-product.jsp?message=" + URLEncoder.encode(message, "UTF-8"));
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<%@ include file="header.jsp" %>

<!-- Always show the form (no hidden class) -->
<div id="productFormModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-md">
        <h3 class="text-xl font-bold mb-4">Add New Product</h3>

        <form method="post" action="add_product.jsp" class="space-y-4">
            <label class="block">
                <span class="text-gray-700">Name:</span>
                <input type="text" name="name" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
            </label>

            <label class="block">
                <span class="text-gray-700">Description:</span>
                <input type="text" name="description" class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
            </label>

            <label class="block">
                <span class="text-gray-700">Price:</span>
                <input type="text" name="price" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
            </label>

            <label class="block">
                <span class="text-gray-700">Image URL:</span>
                <input type="text" name="image_url" class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
            </label>

            <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                Add Product
            </button>
        </form>

        <a href="manage-product.jsp" class="block mt-4 text-center text-red-500 hover:text-red-700">Cancel</a>
    </div>
</div>

</body>
</html>
