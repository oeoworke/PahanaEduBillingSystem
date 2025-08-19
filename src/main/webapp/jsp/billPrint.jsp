<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Bill, model.Customer, model.BillDetail, model.Book, java.util.List" %>
<%
    // Session verification.
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    // Receiving the data sent from the Servlet
    Bill bill = (Bill) request.getAttribute("bill");
    Customer customer = (Customer) request.getAttribute("customer");
    boolean printMode = request.getAttribute("printMode") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #<%= bill != null ? bill.getBillId() : "N/A" %> - Pahana Bookshop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/print.css" media="print">
</head>
<body>
    <% if (!printMode) { %>
    <nav class="navbar no-print">
        <div class="nav-container">
            <div class="nav-brand"><h2>Pahana Bookshop</h2></div>
            <div class="nav-user">
                <a href="${pageContext.request.contextPath}/jsp/dashboard.jsp" class="btn btn-outline">Dashboard</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline">Logout</a>
            </div>
        </div>
    </nav>
    <% } %>

    <div class="container">
        <% if (!printMode) { %>
        <div class="page-header no-print">
            <h1>Invoice Details</h1>
            <div class="header-actions">
                <button onclick="window.print()" class="btn btn-primary">Print Invoice</button>
                <a href="${pageContext.request.contextPath}/BillServlet?action=list" class="btn btn-outline">Back to Bills</a>
            </div>
        </div>
        <% } %>

        <% if (bill != null && customer != null && bill.getBillDetails() != null) { %>
        <div class="bill-print">
            <div class="bill-header">
                <h1>Pahana Bookshop</h1>
                <p>Official Invoice</p>
                <div class="bill-info">
                    <span>Invoice No: #<%= bill.getBillId() %></span>
                    <span>Date: <%= bill.getFormattedDate() %></span>
                </div>
            </div>

            <div class="bill-customer">
                <h3>Billed To:</h3>
                <div class="customer-info">
                    <div class="info-row"><span class="label">Customer ID:</span><span class="value"><%= customer.getAccNo() %></span></div>
                    <div class="info-row"><span class="label">Name:</span><span class="value"><%= customer.getName() %></span></div>
                    <div class="info-row"><span class="label">Address:</span><span class="value"><%= customer.getAddress() %></span></div>
                    <div class="info-row"><span class="label">Phone:</span><span class="value"><%= customer.getPhone() %></span></div>
                </div>
            </div>

            <div class="bill-details">
                <h3>Purchased Items</h3>
                <table class="bill-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Book Title</th>
                            <th>Quantity</th>
                            <th>Price per Unit</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int counter = 1; for (BillDetail detail : bill.getBillDetails()) { %>
                        <tr>
                            <td><%= counter++ %></td>
                            <td>
                                <%-- 
                                  If the book name is not sent from BillServlet, here we are displaying a temporary solution as "Book ID: ...".
                                --%>
                                <% 
                                    String bookTitle = (String) request.getAttribute("book_" + detail.getBookId());
                                    if (bookTitle == null) {
                                        bookTitle = "Book ID: " + detail.getBookId();
                                    }
                                %>
                                <%= bookTitle %>
                            </td>
                            <td><%= detail.getQuantity() %></td>
                            <td>₹<%= String.format("%.2f", detail.getPricePerUnit()) %></td>
                            <td>₹<%= String.format("%.2f", detail.getQuantity() * detail.getPricePerUnit()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="4"><strong>Total Amount</strong></td>
                            <td><strong>₹<%= String.format("%.2f", bill.getTotalAmount()) %></strong></td>
                        </tr>
                    </tfoot>
                </table>
            </div>

            <div class="bill-footer">
                <p><strong>Thank you for your purchase!</strong></p>
                <p>For any queries, please contact Pahana Bookshop.</p>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-error">Invoice information is not available or incomplete.</div>
        <% } %>
    </div>

    <script>
        <% if (printMode) { %>
        window.onload = function() {
            window.print();
            window.onafterprint = function() {
                window.history.back();
            };
        };
        <% } %>
    </script>
</body>
</html>
