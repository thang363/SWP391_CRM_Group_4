package controller.sales;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import util.Constants;
import dao.OpportunityDAO;
import dao.impl.OpportunitiesDaoImpl;
import model.entity.Opportunity;
import model.entity.Role;

@WebServlet(name = "SalesPipelineServlet", urlPatterns = {"/sales-pipeline"})
public class SalesPipelineServlet extends HttpServlet {

    private final OpportunityDAO opportunityDAO = new OpportunitiesDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = ((Number) session.getAttribute(Constants.SESSION_USER_ID)).intValue();
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);

        // Lấy danh sách Deal cho nhân viên Sale. 
        // Nếu là Manager có thể xem tất cả nhưng hiện tại mặc định theo cấu trúc dự án là theo salesId.
        List<Opportunity> opportunities = opportunityDAO.getOpportunitiesWithQuoteCount(userId);
        
        request.setAttribute("opportunities", opportunities);
        request.setAttribute("pageTitle", "Sales Pipeline");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(Constants.PAGE_SALES_PIPELINE);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            String dealIdParam = request.getParameter("dealId");
            String newStage = request.getParameter("stage");
            
            if (dealIdParam == null || dealIdParam.isEmpty() || "null".equals(dealIdParam)) {
                throw new IllegalArgumentException("Deal ID is missing or invalid");
            }
            if (newStage == null || newStage.isEmpty()) {
                throw new IllegalArgumentException("Stage is missing");
            }
            
            int dealId = Integer.parseInt(dealIdParam);
            int probability = calculateProbability(newStage);
            
            opportunityDAO.updateStage(dealId, newStage, probability);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": true, \"probability\": " + probability + ", \"stage\": \"" + newStage + "\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String msg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Internal Server Error";
            response.getWriter().write("{\"success\": false, \"message\": \"" + msg + "\"}");
        }
    }

    private int calculateProbability(String stage) {
        switch (stage) {
            case "Prospecting": return 10;
            case "Proposal": return 60;
            case "Negotiation": return 80;
            case "Won": return 100;
            case "Lost": return 0;
            default: return 0;
        }
    }
}
