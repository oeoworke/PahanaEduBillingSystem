package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Customer;
import model.CustomerDAO;
import model.DAOFactory; 

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;
    
    public void init() {
        customerDAO = DAOFactory.getCustomerDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // default action
        }
        
        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                case "view": 
                    viewCustomer(request, response);
                    break;
                default: // "list"
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/customerList.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addCustomer(request, response);
                    break;
                case "update":
                    updateCustomer(request, response);
                    break;
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/customerForm.jsp").forward(request, response);
        }
    }
    
    // --- Private Helper Methods ---

    private void listCustomers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/jsp/customerList.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/customerForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accNo = request.getParameter("accNo");
        Customer customer = customerDAO.getCustomerByAccNo(accNo);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/jsp/customerForm.jsp").forward(request, response);
    }
    
    private void viewCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accNo = request.getParameter("accNo");
        Customer customer = customerDAO.getCustomerByAccNo(accNo);
        if (customer == null) {
            request.setAttribute("error", "Customer with ID '" + accNo + "' not found.");
        }
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/jsp/viewCustomer.jsp").forward(request, response);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accNo = request.getParameter("accNo");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        Customer customer = new Customer(accNo, name, address, phone);
        
        if (customerDAO.addCustomer(customer)) {
            request.setAttribute("success", "Customer added successfully!");
        } else {
            request.setAttribute("error", "Failed to add customer. Customer ID may already exist.");
        }
        
        listCustomers(request, response); // After adding successfully, show the list
    }
    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accNo = request.getParameter("accNo");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        Customer customer = new Customer(accNo, name, address, phone);
        
        if (customerDAO.updateCustomer(customer)) {
            request.setAttribute("success", "Customer updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update customer.");
        }
        
        listCustomers(request, response);
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accNo = request.getParameter("accNo");
        
        if (customerDAO.deleteCustomer(accNo)) {
            request.setAttribute("success", "Customer deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete customer.");
        }
        
        listCustomers(request, response);
    }
}
