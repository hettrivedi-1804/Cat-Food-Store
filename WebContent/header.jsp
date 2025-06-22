<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>

<!-- Navbar -->
<nav class="bg-cover bg-center bg-no-repeat shadow-md px-6 py-4 flex justify-between items-center"
     style="background-image: url('https://wallpapershome.com/images/pages/pic_h/26365.jpg'); background-attachment: fixed;">
    <div class="text-xl font-bold text-white flex items-center bg-black bg-opacity-50 p-2 rounded-lg">
        <!-- Add Cat GIF to the left of the welcome message -->
        <img src="https://media.tenor.com/Az64YfoL7JcAAAAj/rawr.gif" alt="Cat GIF" class="w-12 h-12 mr-3" />
      
        <%
            Object usernameObj = session.getAttribute("username");
            if (usernameObj != null) {
        %>
            <a class="mr-4">Welcome to </a>
            <a href="home.jsp" class="text-red-500 hover:underline mr-4">Cat Food Store </a>  <%= usernameObj.toString().toUpperCase()%>
        <%
            } else {
        %>
            <a href="home.jsp" class="text-red-500 hover:underline">Cat Food Store</a>
        <%
            }
        %>
    </div>
    <div class="text-xl font-bold text-white flex items-center bg-black bg-opacity-50 p-2 rounded-lg">
        <a href="home.jsp" class="text-white hover:text-blue-500 mr-4">Home</a>
        <a href="cart.jsp" class="text-white hover:text-blue-500 font-semibold mr-4">Cart</a>
        <%
            if (usernameObj != null) {
        %>
            <a href="logout.jsp" class="text-red-500 hover:underline">Logout</a>
        <%
            } else {
        %>
            <a href="login.jsp" class="text-blue-500 hover:underline mr-4">Login</a>
            <a href="register.jsp" class="text-green-500 hover:underline">Register</a>
        <%
            }
        %>
    </div>
</nav>
