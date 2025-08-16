package model;

/**
 * This class stores all the information of a book (Book Entity).
 * This is the Model part of our MVC architecture.
 */
public class Book {
    
    private int bookId;
    private String title;
    private String author; 
    private double price;
    private int stock;
    private String isbn;   

    // Default constructor
    public Book() {}

    // Constructor with all fields
    public Book(int bookId, String title, String author, double price, int stock, String isbn) {
        this.bookId = bookId;
        this.title = title;
        this.author = author;
        this.price = price;
        this.stock = stock;
        this.isbn = isbn;
    }

    // ---- Getters and Setters ----

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }
}
