<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="catfoodstore.DBUtil" %>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    List<Map<String, String>> orders = new ArrayList<>();

    try {
        conn = DBUtil.getConnection(); // Use DBUtil for connection
        stmt = conn.prepareStatement("SELECT * FROM orders");
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> order = new HashMap<>();
            order.put("id", rs.getString("id"));
            order.put("user_id", rs.getString("user_id"));
            order.put("product_id", rs.getString("product_id"));
            order.put("quantity", rs.getString("quantity"));
            order.put("total_price", rs.getString("total_price"));
            order.put("status", rs.getString("status"));
            order.put("order_date", rs.getString("order_date"));
            orders.add(order);
        }
    } catch (SQLException e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace(new java.io.PrintWriter(out));
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Orders</title>
    <script src="https://cdn.tailwindcss.com"></script>
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

        .add-order-btn {
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

        .add-order-btn:hover {
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

        .modal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
            z-index: 50;
        }

        .modal-content {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            width: 100%;
            max-width: 500px;
        }

        .modal-header {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .close-btn {
            color: #f56565;
            cursor: pointer;
        }

        .close-btn:hover {
            color: #e53e3e;
        }
    </style>
</head>
<body>
    <div class="container">
        

        <!-- Add Order Button -->
        <button id="addOrderBtn" class="add-order-btn">
            + Add New Order
        </button>

        <!-- Order Modal -->
        <div id="orderFormModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add New Order</h3>
                    <button id="closeModalBtn" class="close-btn">Close</button>
                </div>
                <form method="post" action="AdminServlet" class="space-y-4">
                    <label class="block">
                        <span class="text-gray-700">User ID:</span>
                        <input type="text" name="user_id" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
                    </label>

                    <label class="block">
                        <span class="text-gray-700">Product ID:</span>
                        <input type="text" name="product_id" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
                    </label>

                    <label class="block">
                        <span class="text-gray-700">Quantity:</span>
                        <input type="number" name="quantity" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
                    </label>

                    <label class="block">
                        <span class="text-gray-700">Total Price:</span>
                        <input type="text" name="total_price" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
                    </label>

                    <label class="block">
                        <span class="text-gray-700">Status:</span>
                        <input type="text" name="status" value="Pending" required class="mt-1 block w-full border border-gray-300 rounded-md p-2" />
                    </label>

                    <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                        Add Order
                    </button>
                </form>
            </div>
        </div>

        <!-- Orders Table -->
        <h2>Manage Orders</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Product ID</th>
                        <th>Quantity</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th>Order Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> order : orders) { %>
                    <tr>
                        <td><%= order.get("id") %></td>
                        <td><%= order.get("user_id") %></td>
                        <td><%= order.get("product_id") %></td>
                        <td><%= order.get("quantity") %></td>
                        <td><%= order.get("total_price") %></td>
                        <td><%= order.get("status") %></td>
                        <td><%= order.get("order_date") %></td>
                        <td>
                            <a href="edit_order.jsp?id=<%= order.get("id") %>" class="edit-btn">Edit</a> |
                            <a href="delete_order.jsp?id=<%= order.get("id") %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this order?');">Delete</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        const modal = document.getElementById('orderFormModal');
        const addOrderBtn = document.getElementById('addOrderBtn');
        const closeModalBtn = document.getElementById('closeModalBtn');

        addOrderBtn.addEventListener('click', () => modal.style.display = 'flex');
        closeModalBtn.addEventListener('click', () => modal.style.display = 'none');
    </script>
</body>
</html>
