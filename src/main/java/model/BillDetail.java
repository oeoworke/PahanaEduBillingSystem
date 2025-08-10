package model;

/**
 * It refers to each line item in a bill.
 * That is, it stores the number and price of a particular book.
 */
public class BillDetail {
    
    private int billDetailId;
    private int billId; 
    private int bookId; 
    private int quantity; 
    private double pricePerUnit; 

    public BillDetail() {}

    // Getters and Setters
    public int getBillDetailId() {
        return billDetailId;
    }

    public void setBillDetailId(int billDetailId) {
        this.billDetailId = billDetailId;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }
}
