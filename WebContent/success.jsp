<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="catfoodstore.DBUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Bill</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<style>
    /* Keep original background */
    body {
        background-image: url('https://wallpapershome.com/images/pages/pic_h/26365.jpg');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        font-family: 'Arial', sans-serif;
        color: #333;
    }

    /* Center the container with a translucent background */
    .order-container {
        background-color: rgba(255, 255, 255, 0.8);
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        backdrop-filter: blur(6px);
        max-width: 900px;
        margin: auto;
    }

    .button {
        background-color: #3182ce;
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        text-align: center;
        display: inline-block;
        transition: background-color 0.3s;
        text-decoration: none;
    }

    .button:hover {
        background-color: #2b6cb0;
    }

    /* Card style for order items */
    .order-item {
        background-color: #f9fafb;
        padding: 12px;
        margin-bottom: 10px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .order-item h3 {
        font-size: 1.2rem;
        font-weight: bold;
    }

    .order-item p {
        font-size: 1rem;
    }

    .total-summary {
        background-color: #f0fdf4;
        font-weight: bold;
        padding: 12px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .total-value {
        color: #2f855a;
    }

    /* Responsive Design */
    @media (min-width: 768px) {
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-item .item-info {
            flex: 1;
        }

        .order-item .item-price {
            text-align: right;
        }
    }
</style>

<body class="min-h-screen flex items-center justify-center">

    <div class="order-container">
        <!-- Success Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-semibold text-green-600">Order Successful!</h1>
            <p class="text-gray-500 mt-4">Thank you for your purchase! Here are the details of your order:</p>
        </div>

        <%
            String username = (String) session.getAttribute("username");
            double grandTotal = 0.0;
            List<Map<String, Object>> orderItems = new ArrayList<>();

            try (Connection conn = DBUtil.getConnection()) {
                // Fetch user ID
                PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE username=?");
                userStmt.setString(1, username);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    int userId = userRs.getInt("id");

                    // Fetch cart items
                    PreparedStatement cartStmt = conn.prepareStatement(
                        "SELECT c.product_id, c.quantity, p.name, p.price " +
                        "FROM cart c INNER JOIN products p ON c.product_id = p.id WHERE c.user_id=?");
                    cartStmt.setInt(1, userId);
                    ResultSet cartRs = cartStmt.executeQuery();

                    while (cartRs.next()) {
                        int productId = cartRs.getInt("product_id");
                        int quantity = cartRs.getInt("quantity");
                        String productName = cartRs.getString("name");
                        double price = cartRs.getDouble("price");
                        double subtotal = price * quantity;

                        // Save for display
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", productName);
                        item.put("quantity", quantity);
                        item.put("price", price);
                        item.put("subtotal", subtotal);
                        orderItems.add(item);

                        grandTotal += subtotal;

                        // Insert into orders table
                        PreparedStatement orderStmt = conn.prepareStatement(
                            "INSERT INTO orders (user_id, product_id, quantity, order_date, status, total_price) " +
                            "VALUES (?, ?, ?, NOW(), 'Pending', ?)");
                        orderStmt.setInt(1, userId);
                        orderStmt.setInt(2, productId);
                        orderStmt.setInt(3, quantity);
                        orderStmt.setDouble(4, subtotal);
                        orderStmt.executeUpdate();
                    }

                    // Clear cart
                    PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM cart WHERE user_id=?");
                    deleteStmt.setInt(1, userId);
                    deleteStmt.executeUpdate();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p class='text-red-500'>Error generating bill. Please contact support.</p>");
            }
        %>

        <!-- Order Items Section -->
        <div class="mb-8">
            <% for (Map<String, Object> item : orderItems) { %>
                <div class="order-item">
                    <div class="item-info">
                        <h3><%= item.get("name") %></h3>
                        <p>Quantity: <%= item.get("quantity") %></p>
                    </div>
                    <div class="item-price">
                        <p>₹<%= String.format("%.2f", item.get("price")) %></p>
                        <p>Subtotal: ₹<%= String.format("%.2f", item.get("subtotal")) %></p>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Total Summary Section -->
        <div class="total-summary text-center mb-8">
            <h3>Grand Total:</h3>
            <p class="total-value">₹<%= String.format("%.2f", grandTotal) %></p>
        </div>

        <!-- Continue Shopping Button -->
        <div class="text-center mt-8">
            <a href="home.jsp" class="button">
                Continue Shopping
            </a>
        </div>
    </div>

</body>
</html>
