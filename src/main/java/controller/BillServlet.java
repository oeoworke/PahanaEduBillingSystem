package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Bill;
import model.BillDAO;
import model.BillDetail;
import model.Book;
import model.BookDAO;
import model.Customer;
import model.CustomerDAO;
import model.DAOFactory;

/**
 * It handles all billing related functions.
 * It implements a Shopping Cart logic using Session.
 */
@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BillDAO billDAO;
    private CustomerDAO customerDAO;
    private BookDAO bookDAO;
    
    public void init() {
        billDAO = DAOFactory.getBillDAO();
        customerDAO = DAOFactory.getCustomerDAO();
        bookDAO = DAOFactory.getBookDAO();
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
                    showNewBillPage(request, response);
                    break;
                case "view":
                    viewBill(request, response);
                    break;
                case "print":
                    printBill(request, response);
                    break;
                case "removeFromCart":
                    removeFromCart(request, response);
                    break;
                default: // "list"
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/billList.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/BookServlet?action=list");
            return;
        }

        try {
            switch (action) {
                case "addToCart":
                    addToCart(request, response);
                    break;
                case "createBill":
                    createBill(request, response);
                    break;
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/bill.jsp").forward(request, response);
        }
    }
    
    // --- Private Helper Methods ---

    private void listBills(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Bill> bills = billDAO.getAllBills();
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/jsp/billList.jsp").forward(request, response);
    }

    private void showNewBillPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Sending list of required books and customers to billing side
        request.setAttribute("allBooks", bookDAO.getAllBooks());
        request.setAttribute("allCustomers", customerDAO.getAllCustomers());
        request.getRequestDispatcher("/jsp/bill.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        List<BillDetail> cart = (List<BillDetail>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Book book = bookDAO.getBookById(bookId);
            if (book != null && quantity > 0) {
                // Checking if this book already exists in the cart
                boolean itemExists = false;
                for (BillDetail item : cart) {
                    if (item.getBookId() == bookId) {
                        item.setQuantity(item.getQuantity() + quantity); // Increasing the number
                        itemExists = true;
                        break;
                    }
                }

                if (!itemExists) {
                    BillDetail newItem = new BillDetail();
                    newItem.setBookId(bookId);
                    newItem.setQuantity(quantity);
                    newItem.setPricePerUnit(book.getPrice());
                    cart.add(newItem);
                }
            }
            session.setAttribute("cart", cart);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid book ID or quantity.");
        }
        
        showNewBillPage(request, response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        List<BillDetail> cart = (List<BillDetail>) session.getAttribute("cart");

        if (cart != null) {
            try {
                int bookIdToRemove = Integer.parseInt(request.getParameter("bookId"));
                cart.removeIf(item -> item.getBookId() == bookIdToRemove);
                session.setAttribute("cart", cart);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid book ID for removal.");
            }
        }
        
        showNewBillPage(request, response);
    }


    private void createBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        List<BillDetail> cart = (List<BillDetail>) session.getAttribute("cart");
        String customerAccNo = request.getParameter("customerAccNo");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Your cart is empty. Please add books to create a bill.");
            showNewBillPage(request, response);
            return;
        }

        if (customerAccNo == null || customerAccNo.trim().isEmpty()) {
            request.setAttribute("error", "Please select a customer.");
            showNewBillPage(request, response);
            return;
        }
        
        // Calculating the total amount
        double totalAmount = 0;
        for (BillDetail item : cart) {
            totalAmount += item.getQuantity() * item.getPricePerUnit();
        }

        // Creating a new Bill object
        Bill bill = new Bill();
        bill.setCustomerAccNo(customerAccNo);
        bill.setTotalAmount(totalAmount);
        bill.setBillDate(LocalDateTime.now());
        bill.setBillDetails(cart); // Linking the card to the bill

        // Saving to Database with DAO (with Transaction)
        if (billDAO.addBill(bill)) {
            // If successful, empty the cart and send to bill list
            session.removeAttribute("cart");
            request.setAttribute("success", "Bill created successfully!");
            response.sendRedirect(request.getContextPath() + "/BillServlet?action=list");

        } else {
            request.setAttribute("error", "Failed to create bill. Please try again.");
            showNewBillPage(request, response);
        }
    }

    private void viewBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int billId = Integer.parseInt(request.getParameter("billId"));
        Bill bill = billDAO.getBillById(billId);
        if (bill == null) {
            request.setAttribute("error", "Bill not found!");
            listBills(request, response);
            return;
        }
        Customer customer = customerDAO.getCustomerByAccNo(bill.getCustomerAccNo());
        
        request.setAttribute("bill", bill);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/jsp/billPrint.jsp").forward(request, response);
    }
    
    private void printBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        viewBill(request, response); // Calling viewBill and setting printMode only
        request.setAttribute("printMode", true);
    }
}
