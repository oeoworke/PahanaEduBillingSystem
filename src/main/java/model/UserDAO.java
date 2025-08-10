package model;

/**
 * This is the UserDAO Pattern's Interface.
 * All operations required to handle users in the database
 * It defines a contract.
 */
public interface UserDAO {
    
    /**
     * Check the given username and password and check if the user is valid
     * Returns a User object.
     * @param username 
     * @param password 
     * @return User object, otherwise null
     */
    User validateUser(String username, String password);
    
    /**
     * Adds a new user to the database.
     * @param user The User object to add
     * @return true if included, false otherwise
     */
    boolean addUser(User user);
}
