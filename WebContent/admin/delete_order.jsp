<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, catfoodstore.DBUtil" %>
<%
    String message = "";
    String orderId = request.getParameter("id");

    if (orderId != null && !orderId.isEmpty()) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM orders WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(orderId));

            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                message = "Order deleted successfully!";
            } else {
                message = "Error: Order not found!";
            }
        } catch (SQLException e) {
            message = "Error deleting order: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        }
    }

    response.sendRedirect("manage-orders.jsp?message=" + message);
%>
