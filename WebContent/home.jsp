<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="catfoodstore.DBUtil" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Cat Food Products</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        /* Custom background image for the body */
        body {
            background-image: url('https://wallpapershome.com/images/pages/pic_h/26365.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            font-family: 'Arial', sans-serif;
            color: #333;
        }

        /* Header Section Styling */
        .header-container {
            background-color: rgba(0, 0, 0, 0.5);
            padding: 3rem 0;
            border-radius: 0 0 1rem 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        .header-title {
            font-size: 3rem;
            font-weight: bold;
            color: #fff;
            text-align: center;
            font-family: 'Cursive', sans-serif; /* Fun, pet-like font */
        }

        /* Product card improvements */
        .product-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(10px);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 1rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        /* Adding subtle paw print overlay */
        .product-card::after {
            content: url('https://example.com/paw-icon.png'); /* Replace with paw icon URL */
            position: absolute;
            top: 10px;
            right: 10px;
            opacity: 0.2;
            pointer-events: none;
        }

        /* Image fix */
        .product-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 0.75rem;
        }

        /* Text styling */
        h3 {
            color: #2c3e50;
            font-size: 1.2rem;
            font-weight: bold;
        }

        .product-description {
            color: #7f8c8d;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .price {
            color: #e74c3c;
            font-size: 1.2rem;
            font-weight: bold;
        }

        /* Add to Cart Button */
        .add-to-cart-btn {
            background-color: #ff6347; /* A warm, pet-friendly color */
            color: white;
            padding: 0.75rem;
            border-radius: 0.5rem;
            transition: background-color 0.3s ease;
            font-weight: bold;
        }

        .add-to-cart-btn:hover {
            background-color: #ff4500;
        }

        /* Grid Layout */
        .grid-container {
            margin-top: 3rem;
        }

        .category-title {
            font-size: 2rem;
            font-weight: bold;
            color: #fff;
            text-align: center;
            text-decoration: underline;
            padding-bottom: 2rem;
        }

        /* Overlay effect for better readability */
        .overlay {
            background-color: rgba(0, 0, 0, 0.4);
            padding: 2rem;
            border-radius: 0.5rem;
        }

    </style>
</head>

<body class="font-sans">

    <!-- Header Section -->
    <div class="header-container">
        <h2 class="header-title">Explore Our Cat Food Products</h2>
    </div>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 py-10 grid-container">
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <%
                try (Connection conn = DBUtil.getConnection()) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM products");

                    while (rs.next()) {
            %>
                <div class="product-card">
                    <!-- Product Image -->
                    <img src="<%= rs.getString("image_url") %>" alt="Product Image" class="product-image mb-4" />

                    <!-- Product Title -->
                    <h3><%= rs.getString("name") %></h3>

                    <!-- Product Description -->
                    <p class="product-description truncate" style="max-height: 3rem; overflow: hidden; text-overflow: ellipsis;">
                        <%= rs.getString("description") %>
                    </p>

                    <!-- Product Price -->
                    <p class="price mb-4">₹<%= rs.getDouble("price") %></p>

                    <!-- Add to Cart Button -->
                    <form action="AddToCartServlet" method="post" class="w-full">
                        <input type="hidden" name="productId" value="<%= rs.getInt("id") %>" />
                        <button type="submit" class="w-full add-to-cart-btn">
                            Add to Cart
                        </button>
                    </form>
                </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p class='text-red-500'>Error loading products: " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>

</body>

</html>
