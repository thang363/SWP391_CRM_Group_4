package com.crm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

/**
 * Servlet controller cho Dashboard
 * URL Pattern: /dashboard
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Có thể thêm logic xử lý dữ liệu ở đây
        // Ví dụ: lấy thống kê từ database
        
        // Set attributes để truyền dữ liệu sang JSP
        request.setAttribute("pageTitle", "Dashboard");
        
        // Forward đến trang dashboard.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST request nếu cần
        doGet(request, response);
    }
}
