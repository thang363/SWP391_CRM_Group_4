package com.crm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

/**
 * Servlet controller cho trang Hồ sơ cá nhân
 * URL Pattern: /profile
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set attributes
        request.setAttribute("pageTitle", "Hồ sơ cá nhân");
        
        // TODO: Lấy thông tin user từ session hoặc database
        // User user = userService.getUserById(session.getAttribute("userId"));
        // request.setAttribute("user", user);
        
        // Forward đến trang profile.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Xử lý cập nhật hồ sơ
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // TODO: Cập nhật thông tin user trong database
        // userService.updateUser(userId, fullName, email, phone, address);
        
        // Redirect về trang profile với thông báo thành công
        response.sendRedirect(request.getContextPath() + "/profile?success=1");
    }
}
