<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<%
    // Session verification.
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    Customer customer = (Customer) request.getAttribute("customer");
    boolean isEdit = customer != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit" : "Add" %> Customer - Pahana Bookshop</title>
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
            <h1><%= isEdit ? "Edit" : "Add New" %> Customer</h1>
            <a href="${pageContext.request.contextPath}/CustomerServlet?action=list" class="btn btn-outline">View All Customers</a>
        </div>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/CustomerServlet" method="post" class="customer-form">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="accNo">Customer ID / Membership No *</label>
                        <input type="text" id="accNo" name="accNo" required 
                               value="<%= isEdit ? customer.getAccNo() : "" %>"
                               <%= isEdit ? "readonly" : "" %>>
                    </div>
                    
                    <div class="form-group">
                        <label for="name">Customer Name *</label>
                        <input type="text" id="name" name="name" required 
                               value="<%= isEdit ? customer.getName() : "" %>">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="address">Address *</label>
                    <textarea id="address" name="address" required rows="3"><%= isEdit ? customer.getAddress() : "" %></textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone Number *</label>
                        <input type="tel" id="phone" name="phone" required 
                               value="<%= isEdit ? customer.getPhone() : "" %>">
                    </div>
                                        
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <%= isEdit ? "Update" : "Add" %> Customer
                    </button>
                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
        
        <%-- The section for displaying messages coming from the Servlet. --%>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </div>

    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
