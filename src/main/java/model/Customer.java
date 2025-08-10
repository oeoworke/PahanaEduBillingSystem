package model;

/**
 * It stores information about a customer (Customer Entity).
 * Removed redundant field 'units'.
 */
public class Customer {
    private String accNo;
    private String name;
    private String address;
    private String phone;

    // Default constructor
    public Customer() {}

 
    public Customer(String accNo, String name, String address, String phone) {
        this.accNo = accNo;
        this.name = name;
        this.address = address;
        this.phone = phone;
    }

    // --- Getters and Setters ---

    public String getAccNo() {
        return accNo;
    }

    public void setAccNo(String accNo) {
        this.accNo = accNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
