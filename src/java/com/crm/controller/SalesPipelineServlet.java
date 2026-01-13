package com.crm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

/**
 * Servlet controller cho Sales Pipeline
 * URL Pattern: /sales-pipeline
 */
@WebServlet(name = "SalesPipelineServlet", urlPatterns = {"/sales-pipeline"})
public class SalesPipelineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set attributes để truyền dữ liệu sang JSP
        request.setAttribute("pageTitle", "Sales Pipeline");
        
        // TODO: Lấy dữ liệu deals từ database
        // List<Deal> leads = dealService.getDealsByStage("LEAD");
        // List<Deal> qualified = dealService.getDealsByStage("QUALIFIED");
        // List<Deal> proposals = dealService.getDealsByStage("PROPOSAL");
        // List<Deal> negotiations = dealService.getDealsByStage("NEGOTIATION");
        // List<Deal> closed = dealService.getDealsByStage("CLOSED");
        
        // Forward đến trang sales-pipeline.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/sales-pipeline.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Xử lý cập nhật trạng thái deal (drag & drop)
        String dealId = request.getParameter("dealId");
        String newStage = request.getParameter("stage");
        
        // TODO: Cập nhật stage của deal trong database
        // dealService.updateDealStage(dealId, newStage);
        
        // Trả về JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true}");
    }
}
