package controller.sales;

import dao.CustomerDAO;
import dao.impl.CustomerDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.entity.Customer;
import model.entity.User;
import dao.OpportunityDAO;
import dao.impl.OpportunitiesDaoImpl;
import util.Constants;

@WebServlet(name = "CustomerListBySaleServlet", urlPatterns = {"/sales/customers"})
public class CustomerListBySaleServlet extends HttpServlet {

    private final CustomerDAO customerDAO;

    public CustomerListBySaleServlet() {
        this.customerDAO = new CustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("createOpportunity".equals(action)) {
            try {
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                String companyName = request.getParameter("companyName");
                
                OpportunityDAO opportunityDAO = new OpportunitiesDaoImpl();
                opportunityDAO.createFromCustomer(customerId, companyName, user.getId());
                
                response.sendRedirect(request.getContextPath() + "/sales/opportunities");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Filter parameters
        String searchQuery = request.getParameter("search");
        String tierFilter = request.getParameter("tier");
        String statusFilter = request.getParameter("status");

        int offset = (page - 1) * pageSize;

        List<Customer> customers = customerDAO.getCustomersBySalesId(user.getId(), offset, pageSize, searchQuery, tierFilter, statusFilter);
        int totalCustomers = customerDAO.getTotalCustomersCountBySalesId(user.getId(), searchQuery, tierFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

        request.setAttribute("customerList", customers);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
        request.setAttribute("tierFilter", tierFilter != null ? tierFilter : "");
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.setAttribute("currentPage", "customers");

        request.getRequestDispatcher("/views/sales/customer-list.jsp").forward(request, response);
    }
}
