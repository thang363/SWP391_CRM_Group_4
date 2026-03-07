package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.AutomationRule;
import model.entity.Role;
import service.AutomationRuleService;
import service.impl.AutomationRuleServiceImpl;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AutomationRuleServlet", urlPatterns = { "/automation-rules" })
public class AutomationRuleServlet extends HttpServlet {

    private final AutomationRuleService ruleService;

    public AutomationRuleServlet() {
        this.ruleService = new AutomationRuleServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "get":
                handleGet(request, response);
                break;
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isManager(request)) {
            sendJsonResponse(response, false, "Bạn không có quyền truy cập.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            sendJsonResponse(response, false, "Hành động không hợp lệ.");
            return;
        }

        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "toggle-status":
                handleToggleStatus(request, response);
                break;
            default:
                sendJsonResponse(response, false, "Hành động không hợp lệ.");
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<AutomationRule> rules = ruleService.findAll();

        // Get list of SUPPORT users only for assign dropdown
        dao.UserDAO userDAO = new dao.impl.UserDAOImpl();
        List<model.entity.User> supportUsers = new java.util.ArrayList<>();
        try {
            List<model.entity.User> allUsers = userDAO.findAllActive();
            if (allUsers != null) {
                for (model.entity.User u : allUsers) {
                    if (u.getRole() != null && u.getRole() == Role.SUPPORT) {
                        supportUsers.add(u);
                    }
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("rules", rules);
        request.setAttribute("users", supportUsers);
        request.setAttribute("currentPage", "automation-rules");
        request.setAttribute("pageTitle", "Automation Rules");
        request.getRequestDispatcher("/views/automation/automation-rules.jsp").forward(request, response);
    }

    private void handleGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            AutomationRule rule = ruleService.findById(id);
            if (rule == null) {
                sendJsonResponse(response, false, "Rule không tồn tại.");
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            String json = String.format(
                    "{\"success\":true,\"data\":{" +
                            "\"id\":%d," +
                            "\"ruleName\":\"%s\"," +
                            "\"targetType\":\"%s\"," +
                            "\"conditionsJson\":%s," +
                            "\"actionType\":\"%s\"," +
                            "\"assignToUser\":%s," +
                            "\"status\":\"%s\"" +
                            "}}",
                    rule.getId(),
                    escapeJson(rule.getRuleName()),
                    escapeJson(rule.getTargetType()),
                    rule.getConditionsJson() != null ? rule.getConditionsJson() : "[]",
                    escapeJson(rule.getActionType()),
                    rule.getAssignToUser() != null ? rule.getAssignToUser().toString() : "null",
                    escapeJson(rule.getStatus()));
            out.print(json);

        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "ID không hợp lệ.");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            AutomationRule rule = extractRuleFromRequest(request);

            HttpSession session = request.getSession(false);
            if (session != null) {
                Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
                if (userId != null)
                    rule.setCreatedBy(userId.intValue());
            }

            boolean success = ruleService.create(rule);
            sendJsonResponse(response, success,
                    success ? "Tạo rule thành công!" : "Lỗi tạo rule.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            AutomationRule rule = extractRuleFromRequest(request);
            rule.setId(id);

            boolean success = ruleService.update(rule);
            sendJsonResponse(response, success,
                    success ? "Cập nhật rule thành công!" : "Lỗi cập nhật rule.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = ruleService.delete(id);
            sendJsonResponse(response, success,
                    success ? "Xóa rule thành công!" : "Lỗi xóa rule.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            boolean success = ruleService.toggleStatus(id, status);
            sendJsonResponse(response, success,
                    success ? "Cập nhật trạng thái thành công!" : "Lỗi cập nhật trạng thái.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }

    private AutomationRule extractRuleFromRequest(HttpServletRequest request) {
        AutomationRule rule = new AutomationRule();
        rule.setRuleName(request.getParameter("ruleName"));
        rule.setTargetType(request.getParameter("targetType"));
        rule.setConditionsJson(request.getParameter("conditionsJson"));
        rule.setActionType(request.getParameter("actionType"));
        rule.setAssignStrategy("SpecificUser");

        String assignToUserStr = request.getParameter("assignToUser");
        if (assignToUserStr != null && !assignToUserStr.trim().isEmpty()) {
            rule.setAssignToUser(Integer.parseInt(assignToUserStr));
        }

        String status = request.getParameter("status");
        rule.setStatus(status != null ? status : "Active");

        return rule;
    }

    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);
        return Role.MANAGER.equals(role);
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(
                String.format("{\"success\":%b,\"message\":\"%s\"}", success, escapeJson(message)));
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
