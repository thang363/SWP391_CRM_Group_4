package controller.sales;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

import util.Constants;

@WebServlet(name = "SalesPipelineServlet", urlPatterns = {"/sales-pipeline"})
public class SalesPipelineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("pageTitle", "Sales Pipeline");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(Constants.PAGE_SALES_PIPELINE);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dealId = request.getParameter("dealId");
        String newStage = request.getParameter("stage");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true}");
    }
}
