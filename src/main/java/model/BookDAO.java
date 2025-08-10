package model;

import java.util.List;

/**
 * 
 * All operations required for handling books in database
 * It defines a contract.
 */
public interface BookDAO {
    
    List<Book> getAllBooks();
    
    Book getBookById(int bookId);
    
    boolean addBook(Book book);
    
    boolean updateBook(Book book);
    
    boolean deleteBook(int bookId);
    
  
}
