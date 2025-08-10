package model;

import java.util.List;

/**
 * This is the Interface of BillDAO Pattern.
 * All functions required to handle bills in database
 * It defines a contract.
 */
public interface BillDAO {

    boolean addBill(Bill bill);

    Bill getBillById(int billId);

    List<Bill> getAllBills();
    
    List<Bill> getBillsByCustomer(String customerAccNo);
}
