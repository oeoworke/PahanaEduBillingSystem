package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * This is a Security Filter.
 * Prevents access to protected pages when the user is not logged in.
*/
@WebFilter("/*") // This filter intercepts all incoming requests to the application
public class AuthenticationFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Checking if a user is logged in
        HttpSession session = httpRequest.getSession(false); // false - don't create new session
        boolean isLoggedIn = (session != null && session.getAttribute("username") != null);

        // Allow access to login page, servlet, and static files (css, js).
        boolean isLoginResource = requestURI.endsWith("login.jsp") || 
                                  requestURI.endsWith("LoginServlet") ||
                                  requestURI.contains("/css/") ||
                                  requestURI.contains("/js/");
        
        // If the user is logged in or he is asking for a login resource, let him in
        if (isLoggedIn || isLoginResource) {
            chain.doFilter(request, response); 
        } else {
            // If not, redirect him to the login page
            System.out.println("Unauthorized access to " + requestURI + ". Redirecting to login.");
            httpResponse.sendRedirect(contextPath + "/jsp/login.jsp");
        }
    }

    public void destroy() {
        
    }
}
