<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Book" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Book> books = (List<Book>) request.getAttribute("books");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book List - Pahana Bookshop</title>
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
            <h1>Book List</h1>
            <%-- The link has been changed to BookServlet. --%>
            <a href="${pageContext.request.contextPath}/BookServlet?action=new" class="btn btn-primary">Add New Book</a>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Book ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Price (₹)</th>
                        <th>Stock</th>
                        <th>ISBN</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (books != null && !books.isEmpty()) { %>
                        <% for (Book book : books) { %>
                            <tr>
                                <td>#<%= book.getBookId() %></td>
                                <td><%= book.getTitle() %></td>
                                <td><%= book.getAuthor() %></td>
                                <td><%= String.format("%.2f", book.getPrice()) %></td>
                                <td><%= book.getStock() %></td>
                                <td><%= book.getIsbn() %></td>
                                <td class="actions">
                                    <%-- The action links have been changed to BookServlet. --%>
                                    <a href="${pageContext.request.contextPath}/BookServlet?action=edit&bookId=<%= book.getBookId() %>" 
                                       class="btn btn-sm btn-primary">Edit</a>
                                    <a href="${pageContext.request.contextPath}/BookServlet?action=delete&bookId=<%= book.getBookId() %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" class="text-center">No books found</td>
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
