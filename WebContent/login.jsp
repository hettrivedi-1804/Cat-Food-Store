<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
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

    /* Style for the login container to create blending effect */
    .login-container {
        background-color: rgba(255, 255, 255, 0.85); /* Semi-transparent white background */
        border-radius: 10px;
        padding: 40px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    /* Label and input field styles */
    .input-label {
        font-weight: 600;
        color: #333;
    }

    .input-field {
        width: 100%;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        padding: 12px;
        font-size: 1rem;
        outline: none;
        transition: all 0.3s;
    }

    .input-field:focus {
        border-color: #4c51bf; /* Blue on focus */
        box-shadow: 0 0 0 2px rgba(67, 56, 202, 0.4);
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

    /* Links */
    .link {
        color: #4c51bf;
        transition: color 0.3s;
    }

    .link:hover {
        color: #434190;
    }
</style>

<body class="bg-gray-100 font-sans min-h-screen flex items-center justify-center">

    <div class="login-container">
        <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">Login</h2>

        <form method="post" action="MainServlet" class="space-y-4">
            <input type="hidden" name="action" value="login" />
            
            <div>
                <label class="input-label block mb-1">Username</label>
                <input type="text" name="username" required class="input-field" />
            </div>
            
            <div>
                <label class="input-label block mb-1">Password</label>
                <input type="password" name="password" required class="input-field" />
            </div>
            
            <button type="submit" class="button">
                Login
            </button>
        </form>

        <!-- Register Link -->
        <p class="text-center text-gray-600 mt-4">
            Don't have an account? 
            <a href="register.jsp" class="link">Register here</a>
        </p>

        <!-- Home page redirect -->
        <p class="text-center text-gray-600 mt-4">
            Continue without login 
            <a href="home.jsp" class="link">Click here</a>
        </p>
    </div>

</body>
</html>
