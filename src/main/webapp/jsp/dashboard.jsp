<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Session verification.
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    String username = (String) userSession.getAttribute("username");
    String role = (String) userSession.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Pahana Bookshop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <h2>Pahana Bookshop</h2>
            </div>
            <div class="nav-user">
                <span>Welcome, <%= username %> (<%= role %>)</span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="dashboard-header">
            <h1>Dashboard</h1>
            <p>Bookshop Management Portal</p>
        </div>

        <div class="dashboard-grid">
            
            <!-- Customer Management Card -->
            <div class="dashboard-card">
                <div class="card-icon customer-icon">👥</div>
                <h3>Customer Management</h3>
                <p>Add, edit, and manage customer accounts.</p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=new" class="btn btn-primary">Add Customer</a>
                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=list" class="btn btn-outline">View All</a>
                </div>
            </div>

            <!-- Book Management Card -->
            <div class="dashboard-card">
                <div class="card-icon item-icon">📚</div>
                <h3>Book Management</h3>
                <p>Manage book inventory and information.</p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/BookServlet?action=new" class="btn btn-primary">Add Book</a>
                    <a href="${pageContext.request.contextPath}/BookServlet?action=list" class="btn btn-outline">View All</a>
                </div>
            </div>

            <!-- Bill Generation Card -->
            <div class="dashboard-card">
                <div class="card-icon bill-icon">🧾</div>
                <h3>Bill / Invoice</h3>
                <p>Generate new invoices for customers.</p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/BillServlet?action=new" class="btn btn-primary">Generate Bill</a>
                    <a href="${pageContext.request.contextPath}/BillServlet?action=list" class="btn btn-outline">View History</a>
                </div>
            </div>

            <!-- Search Card (Optional) -->
            <div class="dashboard-card">
                <div class="card-icon view-icon">🔍</div>
                <h3>Search</h3>
                <p>Quickly find customers or books.</p>
                <div class="card-actions">
                    <a href="#" class="btn btn-primary">Search Now</a>
                </div>
            </div>

            <!-- Help Card -->
            <div class="dashboard-card">
                <div class="card-icon help-icon">❓</div>
                <h3>Help and Support</h3>
                <p>System documentation and help.</p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/jsp/help.jsp" class="btn btn-primary">View Help</a>
                </div>
            </div>

            <!-- Logout Card -->
            <div class="dashboard-card">
                <div class="card-icon exit-icon">🚪</div>
                <h3>Exit System</h3>
                <p>Safely logout from the system.</p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>
