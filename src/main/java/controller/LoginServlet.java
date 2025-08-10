package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DAOFactory; 
import model.User;
import model.UserDAO;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    public void init() {
        userDAO = DAOFactory.getUserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            User user = userDAO.validateUser(username, password);
            
            if (user != null) {
                // If the user is valid, create a new Session and store the user information
                HttpSession session = request.getSession();
                session.setAttribute("user", user); 
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                
                response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");
            } else {
                // If the user is invalid, redirecting to the login page with an error message
                request.setAttribute("error", "Invalid username or password. Please try again.");
                request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "A database error occurred. Please contact the administrator.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }
}
