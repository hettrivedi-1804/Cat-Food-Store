<!-- Tailwind CSS CDN (only include once globally) -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- Fixed Top Navigation Bar -->
<nav class="bg-blue-500 fixed top-0 w-full z-50 shadow-md">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">

      <!-- Logo or Brand -->
      <div class="flex-shrink-0">
        <a href="admin.jsp" class="text-white text-2xl font-bold hover:text-gray-200">
          Admin Panel
        </a>
      </div>

      <!-- Navigation Links -->
      <div class="flex space-x-4">
        <a href="admin.jsp" class="text-white hover:bg-blue-600 px-3 py-2 rounded-md text-sm font-medium">
          Dashboard
        </a>
        <a href="manage-users.jsp" class="text-white hover:bg-blue-600 px-3 py-2 rounded-md text-sm font-medium">
          Manage Users
        </a>
        <a href="manage-orders.jsp" class="text-white hover:bg-blue-600 px-3 py-2 rounded-md text-sm font-medium">
          Manage Orders
        </a>
        <a href="manage-product.jsp" class="text-white hover:bg-blue-600 px-3 py-2 rounded-md text-sm font-medium">
          Manage Products
        </a>
        <a href="/catfood/logout.jsp" class="bg-red-500 hover:bg-red-600 text-white px-3 py-2 rounded-md text-sm font-medium">
          Logout
        </a>
      </div>

    </div>
  </div>
</nav>

<!-- Spacer to push content below the fixed navbar -->
<div class="pt-20"></div>
