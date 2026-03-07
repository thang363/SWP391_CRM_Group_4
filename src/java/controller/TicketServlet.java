package controller;

import dao.AttachmentDAO;
import dao.CustomerDAO;
import dao.impl.AttachmentDAOImpl;
import dao.impl.CustomerDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.entity.Attachment;
import model.entity.Customer;
import model.entity.Role;
import model.entity.Ticket;
import service.TicketService;
import service.impl.TicketServiceImpl;
import util.Constants;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.io.PrintWriter;

@WebServlet(name = "TicketServlet", urlPatterns = { "/tickets" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class TicketServlet extends HttpServlet {

    private final TicketService ticketService;
    private final CustomerDAO customerDAO;
    private final AttachmentDAO attachmentDAO;

    public TicketServlet() {
        this.ticketService = new TicketServiceImpl();
        this.customerDAO = new CustomerDAOImpl();
        this.attachmentDAO = new AttachmentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listTickets(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "search-customers":
                searchCustomers(request, response);
                break;
            case "detail":
                showTicketDetail(request, response);
                break;
            default:
                listTickets(request, response);
                break;
        }
    }

    private void listTickets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String view = request.getParameter("view");

        HttpSession session = request.getSession(false);

        // Defensive null checks
        Role role = null;
        Integer userId = null;
        if (session != null) {
            role = (Role) session.getAttribute(Constants.SESSION_ROLE);
            userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        }

        Integer assignedTo = null;
        boolean isUnassigned = false;

        // === RBAC: Filter theo role ===
        if (Role.MANAGER.equals(role)) {
            // Manager xem tất cả
            if ("my".equals(view) && userId != null) {
                assignedTo = userId.intValue();
            } else if ("unassigned".equals(view)) {
                isUnassigned = true;
            }
        } else if (Role.SUPPORT.equals(role)) {
            // Support: Xem tất cả tickets
            if ("my".equals(view) && userId != null) {
                assignedTo = userId.intValue();
            } else if ("unassigned".equals(view)) {
                isUnassigned = true;
            }
            // Mặc định (view=all hoặc null) -> Xem tất cả (assignedTo = null, isUnassigned
            // = false)
        } else {
            // Marketing/Sale hoặc không có role
            assignedTo = -1; // Không có ticket nào
        }
        // === End RBAC ===

        List<Ticket> tickets = ticketService.searchTickets(keyword, status, priority, assignedTo, isUnassigned);
        request.setAttribute("tickets", tickets);
        request.setAttribute("currentPage", "support");
        request.setAttribute("pageTitle", "Quản lý Ticket");
        request.getRequestDispatcher("/views/ticket/tickets.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("currentPage", "support");
        request.setAttribute("pageTitle", "Tạo Ticket Mới");
        request.getRequestDispatcher("/views/ticket/ticket-form.jsp").forward(request, response);
    }

    private void searchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String keyword = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (keyword == null || keyword.trim().isEmpty()) {
            out.print("[]");
            return;
        }

        List<Customer> customers = customerDAO.searchCustomers(keyword);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < customers.size(); i++) {
            Customer c = customers.get(i);
            json.append(String.format("{\"id\":%d,\"text\":\"%s - %s\"}",
                    c.getId(),
                    escapeJson(c.getCompanyName()),
                    escapeJson(c.getPhone())));
            if (i < customers.size() - 1)
                json.append(",");
        }
        json.append("]");
        out.print(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createTicket(request, response);
        } else if ("update-status".equals(action)) {
            handleUpdateStatus(request, response);
        } else if ("update-priority".equals(action)) {
            handleUpdatePriority(request, response);
        } else if ("assign".equals(action)) {
            handleAssign(request, response);
        } else if ("add-activity".equals(action)) {
            handleAddActivity(request, response);
        } else if ("claim".equals(action)) {
            handleClaim(request, response);
        } else if ("resolve".equals(action)) {
            handleResolve(request, response);
        } else if ("reopen".equals(action)) {
            handleReopen(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void createTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form data
            String customerIdStr = request.getParameter("customerId");
            String subject = request.getParameter("subject");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");
            String category = request.getParameter("category");

            // Validate
            if (customerIdStr == null || subject == null) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc.");
                showCreateForm(request, response);
                return;
            }

            int customerId = Integer.parseInt(customerIdStr);
            String fullTitle = (category != null && !category.isEmpty()) ? "[" + category + "] " + subject : subject;

            Ticket ticket = new Ticket();
            ticket.setCustomerId(customerId);
            ticket.setTitle(fullTitle);
            ticket.setDescription(description);
            ticket.setPriority(priority);
            ticket.setStatus("Open");

            int ticketId = ticketService.createTicket(ticket);

            // Handle File Upload
            Part filePart = request.getPart("attachment");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);

                // Upload path
                String uploadDir = request.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists())
                    uploadDirFile.mkdir();

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadDir + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Save Attachment metadata
                Attachment attachment = new Attachment();
                attachment.setFileName(fileName);
                attachment.setFilePath("uploads/" + uniqueFileName); // Relative path
                attachment.setFileSize(filePart.getSize());
                attachment.setRelatedToEntity("Ticket");
                attachment.setRelatedRecordId(ticketId);

                HttpSession session = request.getSession(false);
                if (session != null) {
                    Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
                    if (userId != null)
                        attachment.setUploadedBy(userId);
                }

                attachmentDAO.saveAttachment(attachment);
            }

            // Return JSON success
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true, \"message\": \"Tạo ticket thành công!\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    private void showTicketDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tickets");
            return;
        }

        int id = Integer.parseInt(idStr);
        Ticket ticket = ticketService.getTicketById(id);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/tickets?error=notfound");
            return;
        }

        // === RBAC: Kiểm tra quyền truy cập ===
        HttpSession session = request.getSession(false);
        Role role = (session != null) ? (Role) session.getAttribute(Constants.SESSION_ROLE) : null;
        Integer userId = (session != null) ? (Integer) session.getAttribute(Constants.SESSION_USER_ID) : null;

        boolean hasAccess = false;

        if (Role.MANAGER.equals(role)) {
            // Manager xem tất cả
            hasAccess = true;
        } else if (Role.SUPPORT.equals(role)) {
            // Support: Xem tất cả
            hasAccess = true;
        } else if (Role.MARKETING.equals(role) || Role.SALE.equals(role)) {
            // Marketing/Sale: Chỉ xem ticket do mình tạo
            // (Cần thêm field createdBy trong Ticket entity)
            // Tạm thời cho phép xem nếu không có createdBy
            hasAccess = true; // TODO: Implement createdBy check
        }

        if (!hasAccess) {
            response.sendRedirect(request.getContextPath() + "/tickets?error=access_denied");
            return;
        }

        List<model.entity.TicketActivity> activities = ticketService.getActivitiesByTicketId(id);

        // Get list of agents for assignment (only Support staff)
        dao.UserDAO userDAO = new dao.impl.UserDAOImpl();
        List<model.entity.User> agents = null;
        try {
            List<model.entity.User> allUsers = userDAO.findAllActive();
            // Filter to only Support role
            agents = new java.util.ArrayList<>();
            if (allUsers != null) {
                for (model.entity.User user : allUsers) {
                    if (model.entity.Role.SUPPORT.equals(user.getRole())) {
                        agents.add(user);
                    }
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }

        // Permissions Flags for JSP
        boolean canEdit = false;
        boolean canClaim = false;

        if (Role.MANAGER.equals(role)) {
            canEdit = true;
            canClaim = (ticket.getAssignedTo() == null || ticket.getAssignedTo() == 0);
        } else if (Role.SUPPORT.equals(role)) {
            if (userId != null && ticket.getAssignedTo() != null && ticket.getAssignedTo().equals(userId)) {
                canEdit = true; // Chỉ sửa ticket của mình
            }
            if (ticket.getAssignedTo() == null || ticket.getAssignedTo() == 0) {
                canClaim = true; // Chỉ nhận ticket chưa gán
            }
        }

        request.setAttribute("ticket", ticket);
        request.setAttribute("activities", activities);
        request.setAttribute("agents", agents);
        request.setAttribute("canEdit", canEdit);
        request.setAttribute("canClaim", canClaim);
        request.setAttribute("currentPage", "support");
        request.setAttribute("pageTitle", "Chi tiết Ticket #" + id);

        request.getRequestDispatcher("/views/ticket/ticket-detail.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        // Backend Permission Check
        HttpSession session = request.getSession(false);
        Role role = (session != null) ? (Role) session.getAttribute(Constants.SESSION_ROLE) : null;
        Integer userId = (session != null) ? (Integer) session.getAttribute(Constants.SESSION_USER_ID) : null;

        if (role == null) {
            sendJsonResponse(response, false, "Chưa đăng nhập");
            return;
        }

        Ticket ticket = ticketService.getTicketById(id);
        if (ticket == null) {
            sendJsonResponse(response, false, "Ticket không tồn tại");
            return;
        }

        boolean allowed = false;
        if (Role.MANAGER.equals(role)) {
            allowed = true;
        } else if (Role.SUPPORT.equals(role)) {
            if (userId != null && ticket.getAssignedTo() != null && ticket.getAssignedTo().equals(userId)) {
                allowed = true;
            }
        }

        if (!allowed) {
            sendJsonResponse(response, false, "Bạn chỉ có thể thay đổi trạng thái ticket được giao cho bạn.");
            return;
        }

        boolean success = ticketService.updateStatus(id, status);

        if (success) {
            String actor = (role != null) ? role.getValue() : "System";
            logSystemActivity(request, id, "Changed status to: " + status + " (" + actor + ")");
        }

        sendJsonResponse(response, success, success ? "Cập nhật trạng thái thành công" : "Lỗi cập nhật");
    }

    private void handleUpdatePriority(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);

        if (!Role.MANAGER.equals(role)) {
            sendJsonResponse(response, false, "Bạn không có quyền thay đổi độ ưu tiên.");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String priority = request.getParameter("priority");
        boolean success = ticketService.updatePriority(id, priority);
        sendJsonResponse(response, success, success ? "Cập nhật ưu tiên thành công" : "Lỗi cập nhật");
    }

    private void handleAssign(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Role role = (session != null) ? (Role) session.getAttribute(Constants.SESSION_ROLE) : null;

        if (!Role.MANAGER.equals(role)) {
            sendJsonResponse(response, false, "Bạn không có quyền phân công ticket.");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String userIdStr = request.getParameter("userId");
            Integer userId = (userIdStr != null && !userIdStr.trim().isEmpty())
                    ? Integer.parseInt(userIdStr)
                    : null;

            boolean success = ticketService.assignTicket(id, userId);

            if (success) {
                String assignMsg = (userId != null)
                        ? "Assigned ticket to userId=" + userId
                        : "Unassigned ticket (None)";
                logSystemActivity(request, id, assignMsg);
            }

            sendJsonResponse(response, success, success ? "Phân công thành công" : "Lỗi phân công");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi server: " + e.getMessage());
        }
    }

    private void handleClaim(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);

        if (userId == null) {
            sendJsonResponse(response, false, "Phiên đăng nhập hết hạn");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        Ticket ticket = ticketService.getTicketById(id);

        if (ticket.getAssignedTo() != null && ticket.getAssignedTo() > 0) {
            sendJsonResponse(response, false, "Ticket này đã có người nhận.");
            return;
        }

        boolean success = ticketService.assignTicket(id, userId);
        if (success) {
            logSystemActivity(request, id, "Claimed ticket (Self-assign)");
        }
        sendJsonResponse(response, success, success ? "Nhận ticket thành công" : "Lỗi nhận ticket");
    }

    private void logSystemActivity(HttpServletRequest request, int ticketId, String message) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
                if (userId != null) {
                    model.entity.TicketActivity activity = new model.entity.TicketActivity();
                    activity.setTicketId(ticketId);
                    activity.setUserId(userId);
                    activity.setMessage(message);
                    activity.setActivityType("System");
                    ticketService.addActivity(activity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleAddActivity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String message = request.getParameter("message");
            boolean isInternal = "true".equals(request.getParameter("isInternal"));

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
                sendJsonResponse(response, false, "Phiên đăng nhập hết hạn");
                return;
            }
            Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
            Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);

            if (isInternal) {
                if (!Role.SUPPORT.equals(role) && !Role.MANAGER.equals(role)) {
                    sendJsonResponse(response, false, "Bạn không có quyền tạo ghi chú nội bộ.");
                    return;
                }
            }

            model.entity.TicketActivity activity = new model.entity.TicketActivity();
            activity.setTicketId(ticketId);
            activity.setUserId(userId);
            activity.setMessage(message);
            activity.setActivityType(isInternal ? "InternalNote" : "Comment");

            boolean success = ticketService.addActivity(activity);

            if (success) {
                sendJsonResponse(response, success, "Đã gửi phản hồi");
            } else {
                sendJsonResponse(response, false, "Lỗi gửi phản hồi");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter()
                .print(String.format("{\"success\": %b, \"message\": \"%s\"}", success, escapeJson(message)));
    }

    private void handleResolve(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Role role = (session != null) ? (Role) session.getAttribute(Constants.SESSION_ROLE) : null;
        Integer userId = (session != null) ? (Integer) session.getAttribute(Constants.SESSION_USER_ID) : null;

        if (role == null) {
            sendJsonResponse(response, false, "Chưa đăng nhập");
            return;
        }

        int id = Integer.parseInt(request.getParameter("ticketId"));
        String note = request.getParameter("solutionNote");

        // Validate permission (Support assigned or Manager)
        Ticket ticket = ticketService.getTicketById(id);
        boolean allowed = false;
        if (Role.MANAGER.equals(role))
            allowed = true;
        if (Role.SUPPORT.equals(role) && ticket.getAssignedTo() != null && ticket.getAssignedTo().equals(userId))
            allowed = true;

        if (!allowed) {
            sendJsonResponse(response, false, "Bạn không có quyền xử lý ticket này.");
            return;
        }

        boolean success = ticketService.resolveTicket(id, note);
        if (success) {
            logSystemActivity(request, id, "Resolved ticket. Solution: " + note);
        }
        sendJsonResponse(response, success, success ? "Giải quyết ticket và gửi email thành công!" : "Lỗi xử lý");
    }

    private void handleReopen(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Role role = (session != null) ? (Role) session.getAttribute(Constants.SESSION_ROLE) : null;

        if (!Role.MANAGER.equals(role)) {
            sendJsonResponse(response, false, "Chỉ Manager mới có quyền mở lại ticket.");
            return;
        }

        int id = Integer.parseInt(request.getParameter("ticketId"));
        boolean success = ticketService.updateStatus(id, "In Progress"); // Re-open logic simple
        if (success) {
            logSystemActivity(request, id, "Re-opened ticket (Manager Override)");
        }
        sendJsonResponse(response, success, success ? "Đã mở lại ticket" : "Lỗi mở lại");
    }

}
