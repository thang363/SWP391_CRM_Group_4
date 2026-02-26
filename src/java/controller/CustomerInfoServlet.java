package controller;

import dao.CustomerDAO;
import dao.impl.CustomerDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Customer;
import model.entity.Role;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;

/**
 * API trả về thông tin khách hàng dưới dạng JSON để hiển thị popup trong My
 * Tasks.
 * URL: /customer-info?id={customerId}
 * Quyền truy cập: SUPPORT + MANAGER
 */
@WebServlet(name = "CustomerInfoServlet", urlPatterns = { "/customer-info" })
public class CustomerInfoServlet extends HttpServlet {

    private final CustomerDAO customerDAO;

    public CustomerInfoServlet() {
        this.customerDAO = new CustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền truy cập
        if (!hasAccess(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"Không có quyền truy cập\"}");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"Thiếu tham số id\"}");
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"id không hợp lệ\"}");
            return;
        }

        Customer c = customerDAO.getCustomerById(customerId);
        if (c == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\":\"Không tìm thấy khách hàng\"}");
            return;
        }

        // Build JSON thủ công (không cần thư viện)
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String lastCareDateStr = (c.getLastCareDate() != null)
                ? sdf.format(c.getLastCareDate())
                : null;

        out.print("{");
        out.print("\"id\":" + c.getId() + ",");
        out.print("\"companyName\":" + toJsonString(c.getCompanyName()) + ",");
        out.print("\"phone\":" + toJsonString(c.getPhone()) + ",");
        out.print("\"email\":" + toJsonString(c.getEmail()) + ",");
        out.print("\"tier\":" + toJsonString(c.getTier()) + ",");
        out.print("\"industry\":" + toJsonString(c.getIndustry()) + ",");
        out.print("\"lastCareDate\":" + toJsonString(lastCareDateStr) + ",");
        out.print("\"city\":" + toJsonString(c.getCity()) + ",");
        out.print("\"country\":" + toJsonString(c.getCountry()) + ",");
        out.print("\"website\":" + toJsonString(c.getWebsite()));
        out.print("}");
    }

    /** Escapes a string value for safe JSON output. */
    private String toJsonString(String value) {
        if (value == null)
            return "null";
        return "\"" + value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                + "\"";
    }

    private boolean hasAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);
        return Role.SUPPORT.equals(role) || Role.MANAGER.equals(role);
    }
}
