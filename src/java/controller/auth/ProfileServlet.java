package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.User;
import service.UserService;
import service.impl.UserServiceImpl;
import util.Constants;

import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService;

    public ProfileServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        User user = userService.getUserById(userId);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("user", user);
        request.setAttribute("pageTitle", "Hồ sơ cá nhân");
        
        request.getRequestDispatcher(Constants.PAGE_PROFILE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Server-side validation
        String errorMessage = null;
        if (fullName == null || fullName.trim().length() < 2 || fullName.trim().length() > 100) {
            errorMessage = "Họ và tên phải từ 2 đến 100 ký tự.";
        } else if (email == null || !email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            errorMessage = "Định dạng email không hợp lệ.";
        } else if (phone != null && !phone.isEmpty() && !phone.matches("^0[0-9]{9,10}$")) {
            errorMessage = "Số điện thoại phải bắt đầu bằng số 0 và có 10-11 chữ số.";
        }

        if (errorMessage != null) {
            User user = userService.getUserById(userId);
            request.setAttribute("user", user);
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, errorMessage);
            request.getRequestDispatcher(Constants.PAGE_PROFILE).forward(request, response);
            return;
        }

        boolean success = userService.updateProfile(userId, fullName, email, phone);

        if (success) {
            // Update session if full name changed
            session.setAttribute(Constants.SESSION_FULL_NAME, fullName);
            request.getSession().setAttribute(Constants.ATTR_SUCCESS_MESSAGE, Constants.SUCCESS_PROFILE_UPDATED);
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // Re-fetch user to show the form again with old data or error
            User user = userService.getUserById(userId);
            request.setAttribute("user", user);
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, "Cập nhật thất bại. Email có thể đã tồn tại.");
            request.getRequestDispatcher(Constants.PAGE_PROFILE).forward(request, response);
        }
    }
}
