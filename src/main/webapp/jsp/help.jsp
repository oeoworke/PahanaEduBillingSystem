<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Pahana Bookshop</title>
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
            <h1>Help and Documentation</h1>
        </div>

        <div class="help-content">
            <div class="help-section">
                <h2>System Overview</h2>
                <p>The Pahana Bookshop Management System is a web-based application designed to efficiently manage customer information, book inventory, and sales invoices.</p>
            </div>

            <div class="help-section">
                <h2>Core Features</h2>
                <ul>
                    <li><strong>Customer Management:</strong> Add, edit, view, and delete customer records.</li>
                    <li><strong>Book Management:</strong> Manage the book inventory, including titles, authors, pricing, and stock levels.</li>
                    <li><strong>Invoice Generation:</strong> Create detailed invoices for customers using an interactive shopping cart system.</li>
                    <li><strong>Sales History:</strong> View and print past invoices for any customer.</li>
                    <li><strong>Secure Access:</strong> Role-based user authentication for system security.</li>
                </ul>
            </div>

            <div class="help-section">
                <h2>How to Use the System</h2>
                
                <div class="help-subsection">
                    <h3>Adding a New Book</h3>
                    <ol>
                        <li>From the Dashboard, navigate to <strong>Book Management &rarr; Add Book</strong>.</li>
                        <li>Fill in the book details (Title, Author, Price, Stock, ISBN).</li>
                        <li>Click the "Add Book" button to save the new book to the inventory.</li>
                    </ol>
                </div>

                <div class="help-subsection">
                    <h3>Generating a New Invoice (Bill)</h3>
                    <ol>
                        <li>From the Dashboard, navigate to <strong>Bill / Invoice &rarr; Generate Bill</strong>.</li>
                        <li>In the "Add Books to Bill" section, select a book from the dropdown list.</li>
                        <li>Enter the desired quantity.</li>
                        <li>Click the <strong>"Add to Bill"</strong> button. The book will appear in the "Current Bill (Shopping Cart)" section.</li>
                        <li>Repeat steps 2-4 for all books the customer is purchasing.</li>
                        <li>In the "Current Bill" section, select the customer from the dropdown list.</li>
                        <li>Click the <strong>"Create Final Bill"</strong> button to save the invoice. You will be redirected to the Bill History page.</li>
                    </ol>
                </div>

                <div class="help-subsection">
                    <h3>Viewing or Printing an Invoice</h3>
                    <ol>
                        <li>From the Dashboard, navigate to <strong>Bill / Invoice &rarr; View History</strong>.</li>
                        <li>Find the desired invoice in the list.</li>
                        <li>Click the "View" button to see the invoice details.</li>
                        <li>On the details page, click the "Print Invoice" button to open the print dialog.</li>
                    </ol>
                </div>
            </div>

            <div class="help-section">
                <h2>Support</h2>
                <p>For any technical issues or questions, please contact the system administrator through your module leader.</p>
            </div>
            <div class="help-section">
                <h2>About This Application</h2>
                <p>Application Name: <strong>Pahana Bookshop Management System</strong> <br>
Version: <strong>1.0.0</strong> <br>
Developed By: <strong>Anustan Anantharajah</strong> <br>
Date: <strong>August-21-2025</strong><p>
            </div>
        </div>
    </div>
</body>
</html>
