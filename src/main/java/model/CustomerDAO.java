package model;

import java.util.List;

/**
 * This is the Interface of CustomerDAO Pattern.
 * All functions required to handle customers in database
 * It defines a contract.
 */
public interface CustomerDAO {
    
    List<Customer> getAllCustomers();
    
    Customer getCustomerByAccNo(String accNo);
    
    boolean addCustomer(Customer customer);
    
    boolean updateCustomer(Customer customer);
    
    boolean deleteCustomer(String accNo);
}
