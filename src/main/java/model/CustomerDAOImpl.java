package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * This is a class that implements the CustomerDAO interface
 * It handles actual database operations (SQL queries).
 * It uses Singleton DatabaseConnection.
 */
public class CustomerDAOImpl implements CustomerDAO {

    private Connection getConnection() throws SQLException {
        return DatabaseConnection.getInstance().getConnection();
    }

    @Override
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT * FROM Customers ORDER BY name";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Customer customer = new Customer(
                    rs.getString("acc_no"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("phone")
                );
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    
    @Override
    public Customer getCustomerByAccNo(String accNo) {
        String query = "SELECT * FROM Customers WHERE acc_no = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setString(1, accNo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                        rs.getString("acc_no"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public boolean addCustomer(Customer customer) {
        String query = "INSERT INTO Customers (acc_no, name, address, phone) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setString(1, customer.getAccNo());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getPhone());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean updateCustomer(Customer customer) {
        String query = "UPDATE Customers SET name = ?, address = ?, phone = ? WHERE acc_no = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getAddress());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getAccNo());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean deleteCustomer(String accNo) {
        String query = "DELETE FROM Customers WHERE acc_no = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(query)) {
            stmt.setString(1, accNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
