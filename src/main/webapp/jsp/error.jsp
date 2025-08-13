<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- The isErrorPage="true" attribute tells the JSP container that this page is an error-handling page, and it allows the use of the implicit object exception to access the details of the exception that occurred.--%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Pahana Bookshop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    
     <style>
        .error-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            padding: 2rem;
        }
        
        .error-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem 3rem;
            box-shadow: var(--shadow-lg);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        
        .error-card h1 {
            color: var(--danger-color);
            margin-bottom: 1rem;
            font-size: 2rem;
        }
        
        .error-details {
            background: #f8f9fa; 
            padding: 1rem;
            border-radius: var(--border-radius);
            margin: 1.5rem 0;
            text-align: left;
            border: 1px solid #dee2e6;
        }
        
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
    </style>
    
</head>
<body>
    <div class="container">
        <div class="error-container">
            <div class="error-card">
                <h1>Oops! Something Went Wrong</h1>
                <p>We apologize for the inconvenience. An unexpected error has occurred.</p>
                
                <%-- If the exception object is present, display the error message. --%>
                <% if (exception != null) { %>
                    <div class="error-details">
                        <strong>Error Details:</strong>
                        <p><%= exception.getMessage() %></p>
                    </div>
                <% } %>
                
                <div class="error-actions">
                    <a href="javascript:history.back()" class="btn btn-outline">Go Back</a>
                    <a href="${pageContext.request.contextPath}/jsp/dashboard.jsp" class="btn btn-primary">Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
