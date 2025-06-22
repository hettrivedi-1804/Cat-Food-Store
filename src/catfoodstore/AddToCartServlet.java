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

/**
 * Servlet implementation class AddToCartServlet
 */
@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddToCartServlet() {
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
		 String username = (String) request.getSession().getAttribute("username");
	        int productId = Integer.parseInt(request.getParameter("productId"));

	        try (Connection conn = DBUtil.getConnection()) {
	            PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE username=?");
	            userStmt.setString(1, username);
	            ResultSet rs = userStmt.executeQuery();
	            if (rs.next()) {
	                int userId = rs.getInt("id");

	                PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM cart WHERE user_id=? AND product_id=?");
	                checkStmt.setInt(1, userId);
	                checkStmt.setInt(2, productId);
	                ResultSet checkRs = checkStmt.executeQuery();

	                if (checkRs.next()) {
	                    PreparedStatement updateStmt = conn.prepareStatement(
	                            "UPDATE cart SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?");
	                    updateStmt.setInt(1, userId);
	                    updateStmt.setInt(2, productId);
	                    updateStmt.executeUpdate();
	                } else {
	                    PreparedStatement insertStmt = conn.prepareStatement(
	                            "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, 1)");
	                    insertStmt.setInt(1, userId);
	                    insertStmt.setInt(2, productId);
	                    insertStmt.executeUpdate();
	                }
	            }
	            response.sendRedirect("cart.jsp");
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	}

}
