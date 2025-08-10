package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * This is a class that implements the BillDAO interface.
 * It stores the bill and its details using transactions.
 */
public class BillDAOImpl implements BillDAO {

    private Connection getConnection() throws SQLException {
        return DatabaseConnection.getInstance().getConnection();
    }

    @Override
    public boolean addBill(Bill bill) {
        Connection conn = null;
        String billQuery = "INSERT INTO bills (customer_acc_no, total_amount, bill_date) VALUES (?, ?, ?)";
        String detailQuery = "INSERT INTO bill_details (bill_id, book_id, quantity, price_per_unit) VALUES (?, ?, ?, ?)";

        try {
            conn = getConnection();
            // step 1: Initiating a Transaction
            conn.setAutoCommit(false);

            // step 2: Get the generated bill_id by storing it in the 'bills' table
            try (PreparedStatement billStmt = conn.prepareStatement(billQuery, Statement.RETURN_GENERATED_KEYS)) {
                billStmt.setString(1, bill.getCustomerAccNo());
                billStmt.setDouble(2, bill.getTotalAmount());
                billStmt.setTimestamp(3, Timestamp.valueOf(bill.getBillDate()));
                billStmt.executeUpdate();

                // Getting the generated bill_id
                try (ResultSet generatedKeys = billStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int billId = generatedKeys.getInt(1);
                        
                        // step 3: Saving each book in 'bill_details' table
                        try (PreparedStatement detailStmt = conn.prepareStatement(detailQuery)) {
                            for (BillDetail detail : bill.getBillDetails()) {
                                detailStmt.setInt(1, billId);
                                detailStmt.setInt(2, detail.getBookId());
                                detailStmt.setInt(3, detail.getQuantity());
                                detailStmt.setDouble(4, detail.getPricePerUnit());
                                detailStmt.addBatch(); 
                            }
                            detailStmt.executeBatch();
                        }
                    } else {
                        throw new SQLException("Creating bill failed, no ID obtained.");
                    }
                }
            }
            
            // step 4: If everything goes well, confirm the transaction
            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            // step 5: Aborting Transaction in case of error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // step 6: Re-enabling auto-commit
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    @Override
    public Bill getBillById(int billId) {
        // Two codes are required to retrieve a bill and all its details
        String billQuery = "SELECT * FROM bills WHERE bill_id = ?";
        String detailQuery = "SELECT * FROM bill_details WHERE bill_id = ?";
        Bill bill = null;

        try (Connection conn = getConnection();
             PreparedStatement billStmt = conn.prepareStatement(billQuery)) {
            
            billStmt.setInt(1, billId);
            try (ResultSet rs = billStmt.executeQuery()) {
                if (rs.next()) {
                    bill = new Bill();
                    bill.setBillId(rs.getInt("bill_id"));
                    bill.setCustomerAccNo(rs.getString("customer_acc_no"));
                    bill.setTotalAmount(rs.getDouble("total_amount"));
                    bill.setBillDate(rs.getTimestamp("bill_date").toLocalDateTime());
                    
                    // Now getting details of this bill
                    List<BillDetail> details = new ArrayList<>();
                    try (PreparedStatement detailStmt = conn.prepareStatement(detailQuery)) {
                        detailStmt.setInt(1, billId);
                        try (ResultSet detailRs = detailStmt.executeQuery()) {
                            while (detailRs.next()) {
                                BillDetail detail = new BillDetail();
                                detail.setBillDetailId(detailRs.getInt("bill_detail_id"));
                                detail.setBillId(detailRs.getInt("bill_id"));
                                detail.setBookId(detailRs.getInt("book_id"));
                                detail.setQuantity(detailRs.getInt("quantity"));
                                detail.setPricePerUnit(detailRs.getDouble("price_per_unit"));
                                details.add(detail);
                            }
                        }
                    }
                    bill.setBillDetails(details);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bill;
    }

    @Override
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT * FROM bills ORDER BY bill_date DESC";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setCustomerAccNo(rs.getString("customer_acc_no"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillDate(rs.getTimestamp("bill_date").toLocalDateTime());
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    @Override
    public List<Bill> getBillsByCustomer(String customerAccNo) {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT * FROM bills WHERE customer_acc_no = ? ORDER BY bill_date DESC";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setString(1, customerAccNo);
            try(ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = new Bill();
                    bill.setBillId(rs.getInt("bill_id"));
                    bill.setCustomerAccNo(rs.getString("customer_acc_no"));
                    bill.setTotalAmount(rs.getDouble("total_amount"));
                    bill.setBillDate(rs.getTimestamp("bill_date").toLocalDateTime());
                    bills.add(bill);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }
}
