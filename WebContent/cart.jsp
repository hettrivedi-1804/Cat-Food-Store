<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="catfoodstore.DBUtil" %>
<%@ include file="header.jsp" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<style>
    /* Custom background image for the body */
    body {
        background-image: url('https://wallpapershome.com/images/pages/pic_h/26365.jpg'); /* Replace with your cat background image URL */
        background-size: cover; /* Makes sure the image covers the entire background */
        background-position: center; /* Center the background image */
        background-attachment: fixed; /* Makes the background fixed during scrolling */
        font-family: 'Arial', sans-serif;
        color: #333; /* Default text color */
    }

    /* Style for elements inside the cart to ensure readability on background */
    .cart-container {
        background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent white background */
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .product-card {
        background-color: rgba(255, 255, 255, 0.7); /* Slightly transparent product card background */
        border-radius: 10px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .button {
        background-color: #6b46c1; /* Purple button for action items */
        color: white;
        padding: 10px 20px;
        border-radius: 5px;
        text-align: center;
        font-weight: bold;
        cursor: pointer;
    }

    .button:hover {
        background-color: #5a36a0; /* Darker purple on hover */
    }
</style>

<body class="bg-gray-100 font-sans min-h-screen">

<div class="max-w-4xl mx-auto py-10 px-4 cart-container">
    <h2 class="text-3xl font-bold mb-8 text-center text-gray-800">Your Cart</h2>

<%
    double total = 0;
    boolean hasItems = false;

    try (Connection conn = DBUtil.getConnection()) {
        PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE username=?");
        userStmt.setString(1, username);
        ResultSet userRs = userStmt.executeQuery();

        if (userRs.next()) {
            int userId = userRs.getInt("id");

            PreparedStatement cartStmt = conn.prepareStatement(
                "SELECT p.id as product_id, p.name, p.price, p.image_url, c.quantity FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?");
            cartStmt.setInt(1, userId);
            ResultSet rs = cartStmt.executeQuery();
%>
            <div class="space-y-4">
<%
            while (rs.next()) {
                hasItems = true;
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                double itemTotal = price * quantity;
                total += itemTotal;
%>
                <div class="product-card flex justify-between items-center border">
                    <div class="flex items-center space-x-4">
                        <img src="<%= rs.getString("image_url") %>" class="w-16 h-16 object-cover rounded-md" alt="Product Image" />
                        <div>
                            <p class="font-medium text-lg text-gray-800"><%= rs.getString("name") %></p>
                            <p class="text-sm text-gray-600">₹<%= price %> × <%= quantity %></p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-blue-600 font-bold">₹<%= String.format("%.2f", itemTotal) %></p>
                        <form action="RemoveFromCartServlet" method="get">
                            <input type="hidden" name="productId" value="<%= rs.getInt("product_id") %>" />
                            <button type="submit" class="text-red-500 text-sm hover:underline">Remove</button>
                        </form>
                    </div>
                </div>
<%
            }
%>
            </div>
<%
        }
    } catch (Exception e) {
%>
        <p class="text-red-500 text-center">Something went wrong: <%= e.getMessage() %></p>
<%
    }

    if (hasItems) {
%>
    <div class="mt-8 text-right">
        <p class="text-xl font-semibold mb-4">Total: ₹<%= String.format("%.2f", total) %></p>
        <form id="payment-form">
            <button type="button" onclick="payNow()" class="button">
                Pay with Razorpay
            </button>
        </form>
    </div>
    <div class="mt-4 text-center">
        <a href="home.jsp" class="button">
            Continue Shopping
        </a>
    </div>
<%
    } else {
%>
    <p class="text-center text-gray-500">Your cart is empty.</p>
    <div class="text-center mt-4">
        <a href="home.jsp" class="button">
            Go to Home Page
        </a>
    </div>
<%
    }
%>
</div>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
function payNow() {
    var options = {
        "key": "rzp_test_A7KkCgs2jMawov", // Replace with your Razorpay Key
        "amount": <%= (int)(total * 100) %>,
        "currency": "INR",
        "name": "Cat Food Store",
        "description": "Payment for your cart items",
        "handler": function (response){
            // After successful payment, hit PlaceOrderServlet
            fetch('PlaceOrderServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'payment_id=' + response.razorpay_payment_id
            })
            .then(res => {
                if (res.redirected) {
                    window.location.href = res.url;
                } else {
                    window.location.href = "success.jsp";
                }
            })
            .catch(error => {
                console.error('Payment succeeded but order failed:', error);
                alert('Payment done, but something went wrong with order processing.');
            });
        },
        "prefill": {
            "name": "<%= username %>",
            "email": "test@example.com",
            "contact": "9999999999"
        },
        "theme": {
            "color": "#3399cc"
        }
    };
    var rzp1 = new Razorpay(options);
    rzp1.open();
}
</script>

</body>
</html>
