package catfoodstore;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class MainServlet
 */
@WebServlet("/MainServlet")
public class MainServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MainServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		
		 String action = request.getParameter("action");
	        String username = request.getParameter("username");
	        String email = request.getParameter("email");
	        String password = request.getParameter("password");

	        try (Connection conn = DBUtil.getConnection()) {
	            PreparedStatement stmt;
	            if ("register".equals(action)) {
	                stmt = conn.prepareStatement("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
	                stmt.setString(1, username);
	                stmt.setString(2, email);
	                stmt.setString(3, password);
	                stmt.executeUpdate();
	                response.sendRedirect("login.jsp");
	            } else if ("login".equals(action)) {
	                stmt = conn.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
	                stmt.setString(1, username);
	                stmt.setString(2, password);
	                ResultSet rs = stmt.executeQuery();
	                if (rs.next()) {
	                    HttpSession session = request.getSession();
	                    session.setAttribute("username", username);
	                    session.setAttribute("is_admin", rs.getBoolean("is_admin"));
	                    if(rs.getBoolean("is_admin") == true)
                        {
                            response.sendRedirect("admin/admin.jsp");
                        }
                    else{
                        response.sendRedirect("home.jsp");
                    }
	                } else {
	                    response.sendRedirect("login.jsp?error=true");
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	}

}
