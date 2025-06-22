<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // Invalidate the current session
  	session.invalidate();

    // Redirect to home page (or login page, depending on your application logic)
    response.sendRedirect("home.jsp");  // or "login.jsp"
%>
