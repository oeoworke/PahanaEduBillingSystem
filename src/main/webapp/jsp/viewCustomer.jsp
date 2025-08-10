<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Customer - Pahana Bookshop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <h2>Pahana Bookshop</h2>
            </div>
            <div class="nav-user">
                <a href="${pageContext.request.contextPath}/jsp/dashboard.jsp" class="btn btn-outline">Dashboard</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1>Customer Details</h1>
            <a href="${pageContext.request.contextPath}/CustomerServlet?action=list" class="btn btn-outline">Back to List</a>
        </div>

        <div class="search-container">
            <%-- The search form is now calling CustomerServlet. --%>
            <form action="${pageContext.request.contextPath}/CustomerServlet" method="get" class="search-form">
                <input type="hidden" name="action" value="view">
                <div class="form-group">
                    <label for="accNo">Enter Customer ID to Search</label>
                    <input type="text" id="accNo" name="accNo" required 
                           placeholder="Enter Customer ID / Membership No">
                </div>
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>

        <%-- After the search, if customer information is found, display it. --%>
        <% if (customer != null) { %>
            <div class="customer-details">
                <div class="details-card">
                    <h2>Customer Information</h2>
                    <div class="details-grid">
                        <div class="detail-item">
                            <label>Customer ID:</label>
                            <span><%= customer.getAccNo() %></span>
                        </div>
                        <div class="detail-item">
                            <label>Name:</label>
                            <span><%= customer.getName() %></span>
                        </div>
                        <div class="detail-item">
                            <label>Address:</label>
                            <span><%= customer.getAddress() %></span>
                        </div>
                        <div class="detail-item">
                            <label>Phone:</label>
                            <span><%= customer.getPhone() %></span>
                        </div>
                    </div>
                    
                    <div class="details-actions">
                        <a href="${pageContext.request.contextPath}/CustomerServlet?action=edit&accNo=<%= customer.getAccNo() %>" 
                           class="btn btn-primary">Edit Customer</a>
                        <a href="${pageContext.request.contextPath}/BillServlet?action=list&customerAccNo=<%= customer.getAccNo() %>" 
                           class="btn btn-success">View Bills</a>
                    </div>
                </div>
            </div>
        <% } %>
        
        <%-- If an error message comes from the Servlet, display it. --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </div>

    <script src="${pageContext.request.contextPath}/js/search.js"></script>
</body>
</html>
