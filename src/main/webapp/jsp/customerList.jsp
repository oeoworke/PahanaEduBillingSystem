<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Customer" %>
<%
    // Session verification
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List - Pahana Bookshop</title>
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
            <h1>Customer List</h1>
            <%-- The link has been changed to CustomerServlet. --%>
            <a href="${pageContext.request.contextPath}/CustomerServlet?action=new" class="btn btn-primary">Add New Customer</a>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (customers != null && !customers.isEmpty()) { %>
                        <% for (Customer customer : customers) { %>
                            <tr>
                                <td><%= customer.getAccNo() %></td>
                                <td><%= customer.getName() %></td>
                                <td><%= customer.getAddress() %></td>
                                <td><%= customer.getPhone() %></td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=view&accNo=<%= customer.getAccNo() %>" 
                                       class="btn btn-sm btn-outline">View</a>
                                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=edit&accNo=<%= customer.getAccNo() %>" 
                                       class="btn btn-sm btn-primary">Edit</a>
                                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=delete&accNo=<%= customer.getAccNo() %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete this customer?')">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="5" class="text-center">No customers found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
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

    <script src="${pageContext.request.contextPath}/js/table.js"></script>
</body>
</html>
