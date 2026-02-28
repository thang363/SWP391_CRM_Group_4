package controller;

import dao.CustomerDAO;
import dao.impl.CustomerDAOImpl;
import model.entity.Customer;
import model.entity.Role;
import util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = { "/customers", "/customers-vip" })
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO;

    public CustomerServlet() {
        this.customerDAO = new CustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "details":
                    showDetails(request, response);
                    break;
                case "merge":
                    showMergeForm(request, response);
                    break;
                case "export":
                    exportCSV(request, response);
                    break;
                case "history":
                    showHistory(request, response);
                    break;
                case "list":
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/customers");
            return;
        }

        try {
            switch (action) {
                case "create":
                    createCustomer(request, response);
                    break;
                case "edit":
                    updateCustomer(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                case "setTier":
                    setCustomerTier(request, response);
                    break;
                case "merge":
                    mergeCustomers(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/customers");
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private boolean hasAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);
        return Role.MANAGER.equals(role) || Role.SALE.equals(role);
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }

        String searchQuery = request.getParameter("search");
        String tierFilter = request.getParameter("tier");
        String statusFilter = request.getParameter("status");

        if ("/customers-vip".equals(request.getServletPath()) && tierFilter == null) {
            tierFilter = "VIP";
        }

        int offset = (page - 1) * pageSize;

        List<Customer> customers = customerDAO.getCustomers(offset, pageSize, searchQuery, tierFilter, statusFilter);
        int totalCustomers = customerDAO.getTotalCustomersCount(searchQuery, tierFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

        request.setAttribute("customers", customers);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchQuery != null ? searchQuery : "");
        request.setAttribute("tier", tierFilter != null ? tierFilter : "");
        request.setAttribute("status", statusFilter != null ? statusFilter : "");

        request.getRequestDispatcher("/views/customers/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/customers/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Customer customer = customerDAO.getCustomerById(Integer.parseInt(idStr));
            request.setAttribute("customer", customer);
        }
        request.getRequestDispatcher("/views/customers/form.jsp").forward(request, response);
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Customer customer = customerDAO.getCustomerById(Integer.parseInt(idStr));
            request.setAttribute("customer", customer);
        }
        request.getRequestDispatcher("/views/customers/details.jsp").forward(request, response);
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Customer customer = customerDAO.getCustomerById(Integer.parseInt(idStr));
            request.setAttribute("customer", customer);
            // In a real app we would load tickets, opportunities, interactions here.
            // For now, we'll just pass the customer to the view.
        }
        request.getRequestDispatcher("/views/customers/history.jsp").forward(request, response);
    }

    private void showMergeForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Customer> allCustomers = customerDAO.getAllCustomers();
        request.setAttribute("allCustomers", allCustomers);
        request.getRequestDispatcher("/views/customers/merge.jsp").forward(request, response);
    }

    private void exportCSV(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"customers.csv\"");

        // Write BOM for Excel UTF-8 display
        response.getOutputStream().write(0xEF);
        response.getOutputStream().write(0xBB);
        response.getOutputStream().write(0xBF);

        PrintWriter writer = new PrintWriter(response.getOutputStream(), false,
                java.nio.charset.StandardCharsets.UTF_8);

        writer.println("ID,Company Name,Phone,Email,Tier,Status,Country");
        List<Customer> customers = customerDAO.getAllCustomers();
        for (Customer c : customers) {
            writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
                    c.getId(),
                    c.getCompanyName() != null ? c.getCompanyName() : "",
                    c.getPhone() != null ? c.getPhone() : "",
                    c.getEmail() != null ? c.getEmail() : "",
                    c.getTier() != null ? c.getTier() : "",
                    c.getStatus() != null ? c.getStatus() : "",
                    c.getCountry() != null ? c.getCountry() : "");
        }
        writer.flush();
    }

    private void createCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Customer c = new Customer();
        populateCustomerFromRequest(c, request);
        customerDAO.createCustomer(c);
        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Customer c = customerDAO.getCustomerById(id);
        if (c != null) {
            populateCustomerFromRequest(c, request);
            customerDAO.updateCustomer(c);
        }
        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        customerDAO.deleteCustomer(id);
        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private void setCustomerTier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String tier = request.getParameter("tier");
        customerDAO.setCustomerTier(id, tier);
        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private void mergeCustomers(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int primaryId = Integer.parseInt(request.getParameter("primaryId"));
        int duplicateId = Integer.parseInt(request.getParameter("duplicateId"));
        if (primaryId != duplicateId) {
            customerDAO.mergeCustomers(primaryId, duplicateId);
        }
        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private void populateCustomerFromRequest(Customer c, HttpServletRequest request) {
        c.setCompanyName(request.getParameter("companyName"));
        c.setTaxCode(request.getParameter("taxCode"));
        c.setWebsite(request.getParameter("website"));
        c.setIndustry(request.getParameter("industry"));

        String empStr = request.getParameter("numberOfEmployees");
        if (empStr != null && !empStr.trim().isEmpty()) {
            try {
                c.setNumberOfEmployees(Integer.parseInt(empStr.trim()));
            } catch (NumberFormatException e) {
                c.setNumberOfEmployees(null);
            }
        } else {
            c.setNumberOfEmployees(null);
        }

        c.setPhone(request.getParameter("phone"));
        c.setEmail(request.getParameter("email"));
        c.setBillingAddress(request.getParameter("billingAddress"));
        c.setShippingAddress(request.getParameter("shippingAddress"));
        c.setCity(request.getParameter("city"));
        c.setCountry(request.getParameter("country"));

        String tier = request.getParameter("tier");
        if (tier != null)
            c.setTier(tier);

        String status = request.getParameter("status");
        if (status != null)
            c.setStatus(status);

        String foundedDateStr = request.getParameter("foundedDate");
        if (foundedDateStr != null && !foundedDateStr.trim().isEmpty()) {
            try {
                c.setFoundedDate(Date.valueOf(foundedDateStr.trim()));
            } catch (IllegalArgumentException e) {
                c.setFoundedDate(null);
            }
        } else {
            c.setFoundedDate(null);
        }
    }
}
