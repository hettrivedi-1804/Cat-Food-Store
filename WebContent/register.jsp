<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <!-- Tailwind CSS CDN -->
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

    /* Style for the form container to make it blend better with the background */
    .form-container {
        background-color: rgba(255, 255, 255, 0.85); /* Semi-transparent white background */
        border-radius: 15px;
        padding: 40px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3); /* Adding a subtle shadow */
        backdrop-filter: blur(5px); /* Adding a blur effect to the background */
    }
    .button {
        background-color: #4c51bf;
        color: white;
        padding: 12px;
        border-radius: 8px;
        width: 100%;
        font-size: 1.125rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }

    .button:hover {
        background-color: #434190; /* Slightly darker on hover */
    }
</style>

<body class="bg-gray-100 font-sans min-h-screen flex items-center justify-center">

    <div class="form-container max-w-md w-full py-10 px-6">
        <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">Register</h2>

        <form method="post" action="MainServlet">
            <input type="hidden" name="action" value="register" />

            <div class="mb-4">
                <label for="username" class="block text-gray-700 font-medium">Username</label>
                <input type="text" name="username" id="username" class="w-full px-4 py-2 mt-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
            </div>

            <div class="mb-4">
                <label for="email" class="block text-gray-700 font-medium">Email</label>
                <input type="text" name="email" id="email" class="w-full px-4 py-2 mt-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
            </div>
            
            <div class="mb-4">
                <label for="password" class="block text-gray-700 font-medium">Password</label>
                <input type="password" name="password" id="password" class="w-full px-4 py-2 mt-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required />
            </div>

            <div class="text-center">
                <button type="submit" class="button">
                    Register
                </button>
            </div>
        </form>

        <!-- Register Link -->
        <p class="text-center text-gray-600 mt-4">
            Already have an account? 
            <a href="login.jsp" class="text-blue-500 hover:text-blue-700">Login here</a>
        </p>

        <!-- Home page redirect -->
        <p class="text-center text-gray-600 mt-4">
            Continue without login 
            <a href="home.jsp" class="text-blue-500 hover:text-blue-700">Click here</a>
        </p>
    </div>

</body>
</html>
