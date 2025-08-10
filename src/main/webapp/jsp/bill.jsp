<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, model.Book, model.Customer, model.BillDetail" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Book> allBooks = (List<Book>) request.getAttribute("allBooks");
    @SuppressWarnings("unchecked")
    List<Customer> allCustomers = (List<Customer>) request.getAttribute("allCustomers");

    @SuppressWarnings("unchecked")
    List<BillDetail> cart = (List<BillDetail>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }
    
    double cartTotal = 0;
    for(BillDetail detail : cart) {
        cartTotal += detail.getQuantity() * detail.getPricePerUnit();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill - Pahana Bookshop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand"><h2>Pahana Bookshop</h2></div>
            <div class="nav-user">
                <a href="${pageContext.request.contextPath}/jsp/dashboard.jsp" class="btn btn-outline">Dashboard</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1>Generate New Bill</h1>
            <a href="${pageContext.request.contextPath}/BillServlet?action=list" class="btn btn-outline">View All Bills</a>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <div class="billing-container">
            <div class="billing-form-card">
                <h2>Add Books to Bill</h2>
                <form action="${pageContext.request.contextPath}/BillServlet" method="post" class="bill-form">
                    <input type="hidden" name="action" value="addToCart">
                    
                    <div class="form-group">
                        <label for="bookId">Select Book *</label>
                        <select id="bookId" name="bookId" required>
                            <option value="">-- Choose a book --</option>
                            <% if (allBooks != null) { for (Book book : allBooks) { %>
                                <%--
                                  JavaScript will use this for stock validation.
                                --%>
                                <option value="<%= book.getBookId() %>" data-stock="<%= book.getStock() %>">
                                    <%= book.getTitle() %> by <%= book.getAuthor() %> (Stock: <%= book.getStock() %>)
                                </option>
                            <% }} %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="quantity">Quantity *</label>
                        <input type="number" id="quantity" name="quantity" min="1" value="1" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Add to Bill</button>
                </form>
            </div>
            
            <div class="billing-cart-card">
                <h3>Current Bill (Shopping Cart)</h3>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Book Title</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Subtotal</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (cart.isEmpty()) { %>
                                <tr><td colspan="5" class="text-center">Your cart is empty.</td></tr>
                            <% } else { for (BillDetail detail : cart) { %>
                                <tr>
                                    <td>
                                        <% 
                                        String title = "N/A";
                                        if (allBooks != null) {
                                            for (Book b : allBooks) {
                                                if (b.getBookId() == detail.getBookId()) {
                                                    title = b.getTitle();
                                                    break;
                                                }
                                            }
                                        }
                                        %>
                                        <%= title %>
                                    </td>
                                    <td><%= detail.getQuantity() %></td>
                                    <td>₹<%= String.format("%.2f", detail.getPricePerUnit()) %></td>
                                    <td>₹<%= String.format("%.2f", detail.getQuantity() * detail.getPricePerUnit()) %></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/BillServlet?action=removeFromCart&bookId=<%= detail.getBookId() %>" class="btn btn-sm btn-danger">Remove</a>
                                    </td>
                                </tr>
                            <% }} %>
                        </tbody>
                        <tfoot>
                            <tr class="total-row">
                                <td colspan="3"><strong>Total Amount</strong></td>
                                <td colspan="2"><strong>₹<%= String.format("%.2f", cartTotal) %></strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <% if (!cart.isEmpty()) { %>
                <form action="${pageContext.request.contextPath}/BillServlet" method="post" class="final-bill-form">
                    <input type="hidden" name="action" value="createBill">
                    <div class="form-group">
                        <label for="customerAccNo">Select Customer *</label>
                        <select id="customerAccNo" name="customerAccNo" required>
                            <option value="">-- Choose a customer --</option>
                             <% if (allCustomers != null) { for (Customer c : allCustomers) { %>
                                <option value="<%= c.getAccNo() %>"><%= c.getName() %> (<%= c.getAccNo() %>)</option>
                            <% }} %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success btn-full">Create Final Bill</button>
                </form>
                <% } %>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/billing.js"></script>
</body>
</html>
