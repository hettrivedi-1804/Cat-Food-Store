<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*,catfoodstore.DBUtil" %>
<%@ include file="header.jsp" %>

<%
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("home.jsp");
        return;
    }

    int totalUsers = 0;
    int totalProducts = 0;
    int totalOrders = 0;

    try (Connection conn = DBUtil.getConnection()) {
        Statement stmt = conn.createStatement();

        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM users");
        if (rs1.next()) totalUsers = rs1.getInt(1);

        ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM products");
        if (rs2.next()) totalProducts = rs2.getInt(1);

        ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM orders");
        if (rs3.next()) totalOrders = rs3.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Count unique visitors using a session attribute (could also be DB-based)
    Integer visitCount = (Integer) application.getAttribute("visitorCount");
    if (visitCount == null) {
        visitCount = 0;
    }

    boolean isNewVisitor = true;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("visitor".equals(c.getName())) {
                isNewVisitor = false;
                break;
            }
        }
    }

    if (isNewVisitor) {
        Cookie newVisitor = new Cookie("visitor", java.util.UUID.randomUUID().toString());
        newVisitor.setMaxAge(60 * 60 * 24 * 365); // 1 year
        response.addCookie(newVisitor);
        visitCount++;
        application.setAttribute("visitorCount", visitCount);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<style>
        body {
            background-color: #1a202c; /* Dark background */
            color: white;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

     

        h2 {
            font-size: 2.5rem;
            font-weight: 600;
            color: #e2e8f0;
            margin-bottom: 2rem;
        }

   
        
    </style>
<body >
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-6 text-center">Admin Dashboard</h1>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-white shadow-md rounded-lg p-6 text-center">
                <p class="text-gray-500">Total Users</p>
                <p class="text-2xl font-bold text-blue-600"><%= totalUsers %></p>
            </div>
            <div class="bg-white shadow-md rounded-lg p-6 text-center">
                <p class="text-gray-500">Total Products</p>
                <p class="text-2xl font-bold text-green-600"><%= totalProducts %></p>
            </div>
            <div class="bg-white shadow-md rounded-lg p-6 text-center">
                <p class="text-gray-500">Total Orders</p>
                <p class="text-2xl font-bold text-purple-600"><%= totalOrders %></p>
            </div>
            <div class="bg-white shadow-md rounded-lg p-6 text-center">
                <p class="text-gray-500">Unique Visitors</p>
                <p class="text-2xl font-bold text-pink-600"><%= visitCount %></p>
            </div>
        </div>
    </div>
</body>
</html>
