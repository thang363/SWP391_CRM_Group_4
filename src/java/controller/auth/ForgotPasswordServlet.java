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
import service.EmailService;
import util.PasswordUtil;
import util.Constants;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService;
    private final SecureRandom random = new SecureRandom();

    public ForgotPasswordServlet() {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String action = request.getParameter("action");
            if (action == null) {
                sendError(response, "Yêu cầu không hợp lệ.");
                return;
            }

            switch (action) {
                case "send-otp":
                    handleSendOtp(request, response);
                    break;
                case "verify-otp":
                    handleVerifyOtp(request, response);
                    break;
                case "reset-password":
                    handleResetPassword(request, response);
                    break;
                default:
                    sendError(response, "Hành động không hợp lệ.");
                    break;
            }
        } catch (Throwable t) {
            t.printStackTrace();
            sendError(response, "Lỗi Server Internal: " + t.toString());
        }
    }

    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            sendError(response, "Vui lòng nhập email.");
            return;
        }

        User user = userService.getUserByEmail(email.trim());
        if (user == null) {
            sendError(response, "Email không tồn tại trong hệ thống.");
            return;
        }

        // Generate 6-digit OTP
        String otp = String.format("%06d", random.nextInt(1000000));
        
        // Save to session
        HttpSession session = request.getSession(true);
        session.setAttribute("reset_email", user.getEmail());
        session.setAttribute("reset_otp", otp);
        session.setAttribute("reset_otp_time", System.currentTimeMillis());

        // Send email
        EmailService.sendOtpEmailAsync(user.getEmail(), otp);

        sendSuccess(response, "Mã OTP đã được gửi đến email của bạn.");
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("reset_otp") == null) {
            sendError(response, "Phiên giao dịch đã hết hạn. Vui lòng yêu cầu mã OTP mới.");
            return;
        }

        String savedOtp = (String) session.getAttribute("reset_otp");
        Long otpTime = (Long) session.getAttribute("reset_otp_time");

        // Check expiry (5 minutes = 300,000 ms)
        if (System.currentTimeMillis() - otpTime > 300000) {
            session.removeAttribute("reset_otp");
            session.removeAttribute("reset_otp_time");
            sendError(response, "Mã OTP đã hết hạn. Vui lòng yêu cầu mã OTP mới.");
            return;
        }

        if (savedOtp.equals(enteredOtp)) {
            // OTP is valid
            session.setAttribute("otp_verified", true);
            sendSuccess(response, "Xác thực OTP thành công.");
        } else {
            // Optional: Removed attempt limits based on user request. 
            // We just check if it's correct or not.
            sendError(response, "Mã OTP không chính xác.");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_verified") == null || !(boolean) session.getAttribute("otp_verified")) {
            sendError(response, "Yêu cầu không hợp lệ. Vui lòng xác thực mã OTP trước.");
            return;
        }

        String email = (String) session.getAttribute("reset_email");
        String newPassword = request.getParameter("newPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            sendError(response, "Vui lòng nhập mật khẩu mới.");
            return;
        }

        if (!PasswordUtil.meetsRequirements(newPassword)) {
            sendError(response, "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số.");
            return;
        }

        User user = userService.getUserByEmail(email);
        if (user == null) {
            sendError(response, "Không tìm thấy tài khoản.");
            return;
        }

        boolean success = userService.resetPassword(user.getId(), newPassword);
        if (success) {
            // Auto-login logic
            session.setAttribute(Constants.SESSION_USER_ID, user.getId());
            session.setAttribute(Constants.SESSION_USERNAME, user.getUsername());
            session.setAttribute(Constants.SESSION_ROLE, user.getRole());
            session.setAttribute(Constants.SESSION_FULL_NAME, user.getFullName() != null ? user.getFullName() : user.getUsername());
            session.setAttribute(Constants.SESSION_USER, user);
            session.setMaxInactiveInterval(30 * 60);

            // Clear session data
            session.removeAttribute("reset_email");
            session.removeAttribute("reset_otp");
            session.removeAttribute("reset_otp_time");
            session.removeAttribute("otp_verified");
            
            sendSuccess(response, "Đổi mật khẩu thành công. Đang tự động đăng nhập...");
        } else {
            sendError(response, "Có lỗi xảy ra khi đổi mật khẩu. Vui lòng thử lại.");
        }
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        String safeMsg = message.replace("\"", "\\\"");
        String json = "{\"success\": false, \"message\": \"" + safeMsg + "\"}";
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        String safeMsg = message.replace("\"", "\\\"");
        String json = "{\"success\": true, \"message\": \"" + safeMsg + "\"}";
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}
