package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Role;
import model.entity.User;
import model.viewmodel.UserViewModel;
import service.UserService;
import service.impl.UserServiceImpl;
import util.Constants;
import util.PasswordUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/users"})
public class UserManagementServlet extends HttpServlet {

    private final UserService userService;

    public UserManagementServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN);
            return;
        }

        // AJAX: check duplicate username or email
        String action = request.getParameter("action");
        if ("checkDuplicate".equals(action)) {
            handleCheckDuplicate(request, response);
            return;
        }

        String searchQuery = request.getParameter("searchQuery");
        String roleParam = request.getParameter("role");
        String statusParam = request.getParameter("status");

        List<UserViewModel> users;
        if ((searchQuery != null && !searchQuery.trim().isEmpty()) || 
            (roleParam != null && !roleParam.trim().isEmpty()) || 
            (statusParam != null && !statusParam.trim().isEmpty())) {
            users = userService.searchUsers(searchQuery, roleParam, statusParam);
        } else {
            users = userService.getAllUsers();
        }
        
        request.setAttribute(Constants.ATTR_USERS, users);
        request.setAttribute("roles", Role.values());
        request.setAttribute("currentPage", "user-management");
        request.setAttribute(Constants.ATTR_PAGE_TITLE, "Quản lý người dùng");

        // Transfer session messages to request
        if (session.getAttribute(Constants.ATTR_SUCCESS_MESSAGE) != null) {
            request.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, session.getAttribute(Constants.ATTR_SUCCESS_MESSAGE));
            session.removeAttribute(Constants.ATTR_SUCCESS_MESSAGE);
        }
        if (session.getAttribute(Constants.ATTR_ERROR_MESSAGE) != null) {
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, session.getAttribute(Constants.ATTR_ERROR_MESSAGE));
            session.removeAttribute(Constants.ATTR_ERROR_MESSAGE);
        }

        request.getRequestDispatcher(Constants.PAGE_USER_MANAGEMENT).forward(request, response);
    }

    private void handleCheckDuplicate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String field = request.getParameter("field"); // "username", "email", or "phone"
        String value = request.getParameter("value");

        boolean exists = false;
        if (value != null && !value.trim().isEmpty()) {
            if ("username".equals(field)) {
                User u = userService.getUserByUsername(value.trim());
                exists = (u != null);
            } else if ("email".equals(field)) {
                User u = userService.getUserByEmail(value.trim());
                exists = (u != null);
            } else if ("phone".equals(field)) {
                exists = userService.phoneExists(value.trim());
            }
        }

        response.getWriter().write("{\"exists\":" + exists + "}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN);
            return;
        }

        Integer currentUserId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        String action = request.getParameter("action");

        if (action == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_USERS);
            return;
        }

        switch (action) {
            case "create":
                handleCreate(request, session, currentUserId);
                break;
            case "update":
                handleUpdate(request, session, currentUserId);
                break;
            case "resetPassword":
                handleResetPassword(request, session, currentUserId);
                break;
            case "toggleStatus":
                handleToggleStatus(request, session, currentUserId);
                break;
            default:
                session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
                break;
        }

        response.sendRedirect(request.getContextPath() + Constants.SERVLET_USERS);
    }

    private void handleCreate(HttpServletRequest request, HttpSession session, Integer currentUserId) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("role");

        // Validate required fields
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || fullName == null || fullName.trim().isEmpty()
                || roleStr == null || roleStr.trim().isEmpty()) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Vui lòng điền đầy đủ thông tin bắt buộc.");
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_PASSWORD_MISMATCH);
            return;
        }

        // Validate password requirements
        if (!PasswordUtil.meetsRequirements(password)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số.");
            return;
        }

        Role role = Role.fromString(roleStr);
        if (role == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Vai trò không hợp lệ.");
            return;
        }

        User created = userService.createUser(username.trim(), password, email.trim(), fullName.trim(),
                phone != null ? phone.trim() : null, role);

        if (created != null) {
            session.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_USER_CREATED);
        } else {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Tạo người dùng thất bại. Username hoặc Email có thể đã tồn tại.");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpSession session, Integer currentUserId) {
        String userIdStr = request.getParameter("userId");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("role");
        String status = request.getParameter("status");

        if (userIdStr == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        Integer userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        // Prevent Manager from changing own role
        if (userId.equals(currentUserId) && roleStr != null) {
            Role newRole = Role.fromString(roleStr);
            if (newRole != Role.MANAGER) {
                session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Bạn không thể thay đổi vai trò của chính mình.");
                return;
            }
        }

        // Prevent Manager from disabling self
        if (userId.equals(currentUserId) && status != null && "Inactive".equalsIgnoreCase(status)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Bạn không thể vô hiệu hóa tài khoản của chính mình.");
            return;
        }

        User user = userService.getUserById(userId);
        if (user == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Không tìm thấy người dùng.");
            return;
        }

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email.trim());
        }
        if (phone != null) {
            user.setPhone(phone.trim());
        }
        if (roleStr != null) {
            Role role = Role.fromString(roleStr);
            if (role != null) {
                user.setRole(role);
            }
        }
        if (status != null) {
            user.setStatus(status);
        }

        boolean success = userService.updateUser(user);
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_USER_UPDATED);
        } else {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Cập nhật thất bại. Email có thể đã tồn tại.");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpSession session, Integer currentUserId) {
        String userIdStr = request.getParameter("userId");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (userIdStr == null || newPassword == null || newPassword.trim().isEmpty()) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        Integer userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        // Validate password match
        if (!newPassword.equals(confirmNewPassword)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_PASSWORD_MISMATCH);
            return;
        }

        // Validate password requirements
        if (!PasswordUtil.meetsRequirements(newPassword)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số.");
            return;
        }

        boolean success = userService.resetPassword(userId, newPassword);
        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_PASSWORD_CHANGED);
        } else {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Reset mật khẩu thất bại.");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpSession session, Integer currentUserId) {
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        Integer userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_INVALID_INPUT);
            return;
        }

        // Prevent self-disable
        if (userId.equals(currentUserId)) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Bạn không thể thay đổi trạng thái tài khoản của chính mình.");
            return;
        }

        User user = userService.getUserById(userId);
        if (user == null) {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Không tìm thấy người dùng.");
            return;
        }

        boolean newStatus = !"Active".equals(user.getStatus());
        boolean success = userService.setUserActiveStatus(userId, newStatus);

        if (success) {
            session.setAttribute(Constants.ATTR_SUCCESS_MESSAGE,
                    newStatus ? "Đã kích hoạt tài khoản." : "Đã vô hiệu hóa tài khoản.");
        } else {
            session.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Thay đổi trạng thái thất bại.");
        }
    }
}
