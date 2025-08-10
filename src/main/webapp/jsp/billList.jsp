<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Bill" %>
<%
    // Session verification.
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill History - Pahana Bookshop</title>
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
            <h1>Bill / Invoice History</h1>
            <%-- The link is now directing to /BillServlet?action=new. --%>
            <a href="${pageContext.request.contextPath}/BillServlet?action=new" class="btn btn-primary">Generate New Bill</a>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Customer ID</th>
                        <th>Total Amount</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bills != null && !bills.isEmpty()) { %>
                        <% for (Bill bill : bills) { %>
                            <tr>
                                <td>#<%= bill.getBillId() %></td>
                                <%-- Correct getter methods are being used. --%>
                                <td><%= bill.getCustomerAccNo() %></td>
                                <td>₹<%= String.format("%.2f", bill.getTotalAmount()) %></td>
                                <td><%= bill.getFormattedDate() %></td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/BillServlet?action=view&billId=<%= bill.getBillId() %>" 
                                       class="btn btn-sm btn-outline">View</a>
                                    <a href="${pageContext.request.contextPath}/BillServlet?action=print&billId=<%= bill.getBillId() %>" 
                                       class="btn btn-sm btn-primary">Print</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="5" class="text-center">No bills found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/table.js"></script>
</body>
</html>
