package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List; 

/**
 * It stores general information of a bill (Bill Entity).
 */
public class Bill {
    private int billId;
    private String customerAccNo; 
    private double totalAmount;   
    private LocalDateTime billDate;
    
    private List<BillDetail> billDetails;

    public Bill() {}

    // Getters and Setters
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public String getCustomerAccNo() {
        return customerAccNo;
    }

    public void setCustomerAccNo(String customerAccNo) {
        this.customerAccNo = customerAccNo;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public LocalDateTime getBillDate() {
        return billDate;
    }

    public void setBillDate(LocalDateTime billDate) {
        this.billDate = billDate;
    }

    public List<BillDetail> getBillDetails() {
        return billDetails;
    }

    public void setBillDetails(List<BillDetail> billDetails) {
        this.billDetails = billDetails;
    }
    
    public String getFormattedDate() {
        if (billDate != null) {
            return billDate.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss"));
        }
        return "";
    }
}
