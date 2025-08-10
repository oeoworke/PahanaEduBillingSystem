package model;

/**
 * It uses the Factory Design Pattern to create DAO objects.
 */
public class DAOFactory {

    public static BookDAO getBookDAO() {
        return new BookDAOImpl();
    }

    public static CustomerDAO getCustomerDAO() {
        return new CustomerDAOImpl();
    }
    
    public static BillDAO getBillDAO() {
        return new BillDAOImpl();
    }
    
    
    public static UserDAO getUserDAO() {
        return new UserDAOImpl();
    }
}
