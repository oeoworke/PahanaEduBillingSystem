<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Book" %>
<%
    // Session verification.
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    
    Book book = (Book) request.getAttribute("book");
    boolean isEdit = book != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    
    <title><%= isEdit ? "Edit" : "Add" %> Book - Pahana Bookshop</title>
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
            <h1><%= isEdit ? "Edit" : "Add New" %> Book</h1>
            <%-- The link has been changed to BookServlet. --%>
            <a href="${pageContext.request.contextPath}/BookServlet?action=list" class="btn btn-outline">View All Books</a>
        </div>

        <div class="form-container">
            <%-- The form action has been changed to BookServlet. --%>
            <form action="${pageContext.request.contextPath}/BookServlet" method="post" class="book-form">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                <% } %>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="title">Book Title *</label>
                        <input type="text" id="title" name="title" required 
                               value="<%= isEdit ? book.getTitle() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="author">Author *</label>
                        <input type="text" id="author" name="author" required 
                               value="<%= isEdit ? book.getAuthor() : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="price">Price (₹) *</label>
                        <input type="number" id="price" name="price" step="0.01" min="0" required 
                               value="<%= isEdit ? String.valueOf(book.getPrice()) : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="stock">Stock Quantity *</label>
                        <input type="number" id="stock" name="stock" min="0" required 
                               value="<%= isEdit ? String.valueOf(book.getStock()) : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="isbn">ISBN</label>
                    <input type="text" id="isbn" name="isbn"
                           value="<%= isEdit ? (book.getIsbn() != null ? book.getIsbn() : "") : "" %>">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <%= isEdit ? "Update" : "Add" %> Book
                    </button>
                    <a href="${pageContext.request.contextPath}/BookServlet?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
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

    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</body>
</html>
