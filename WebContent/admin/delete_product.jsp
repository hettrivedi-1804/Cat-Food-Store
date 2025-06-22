<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLDecoder, catfoodstore.DBUtil" %>

<%
    String message = "";
    String productId = request.getParameter("id");

    if (productId != null && !productId.isEmpty()) {
        try {
            // Decode the productId to handle any special characters (if any)
            productId = URLDecoder.decode(productId, "UTF-8");
        } catch (Exception e) {
            message = "Error decoding product ID.";
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();  // Get the database connection
            String sql = "DELETE FROM products WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(productId));

            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                message = "Product deleted successfully!";
            } else {
                message = "Error: Product not found!";
            }
        } catch (SQLException e) {
            message = "Error deleting product: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Log this error in a log file for better tracking in production
            }
        }
    } else {
        message = "No product ID provided!";
    }

    // URL-encode the message to avoid invalid URL characters
    String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");

    // Redirect back to the manage products page with the message as a parameter
    response.sendRedirect("manage-product.jsp?message=" + encodedMessage);
%>
