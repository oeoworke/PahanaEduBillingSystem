package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Book;
import model.BookDAO;
import model.DAOFactory;

@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BookDAO bookDAO;
    
    public void init() {
        bookDAO = DAOFactory.getBookDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.equals("list")) {
                listBooks(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteBook(request, response);
            } else { // "new" action
                showNewForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("jsp/bookForm.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action.equals("add")) {
                addBook(request, response);
            } else if (action.equals("update")) {
                updateBook(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("jsp/bookForm.jsp").forward(request, response);
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books); // "items" -> "books"
        request.getRequestDispatcher("jsp/bookList.jsp").forward(request, response); // item -> book
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("jsp/bookForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId")); // itemId -> bookId
        Book existingBook = bookDAO.getBookById(bookId);
        request.setAttribute("book", existingBook); // item -> book
        request.getRequestDispatcher("jsp/bookForm.jsp").forward(request, response);
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String isbn = request.getParameter("isbn");
        
        Book newBook = new Book(0, title, author, price, stock, isbn);
        
        if (bookDAO.addBook(newBook)) {
            request.setAttribute("success", "Book added successfully!");
        } else {
            request.setAttribute("error", "Failed to add book.");
        }
        
        listBooks(request, response); // After adding successfully, show the list
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String isbn = request.getParameter("isbn");
        
        Book book = new Book(bookId, title, author, price, stock, isbn);
        
        if (bookDAO.updateBook(book)) {
            request.setAttribute("success", "Book updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update book.");
        }
        
        listBooks(request, response);
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        if (bookDAO.deleteBook(bookId)) {
            request.setAttribute("success", "Book deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete book.");
        }
        
        listBooks(request, response);
    }
}
