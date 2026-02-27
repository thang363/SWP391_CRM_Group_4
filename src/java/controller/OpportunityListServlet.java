package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.OpportunityDAO;
import dao.impl.OpportunitiesDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Opportunity;
import model.entity.User;
import util.DatabaseUtil;

@WebServlet(name = "OpportunityListServlet", urlPatterns = {"/sales/opportunities"})
public class OpportunityListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Mock data for frontend demonstration
        // In a real implementation, this would come from OpportunityDAO
        request.setAttribute("currentPage", "opportunities");
        request.setAttribute("pageTitle", "Opportunity List");
        
        // Creating some empty list to avoid null pointer in JSP if needed, 
        // though JSP already handles empty list.
        OpportunityDAO oop = new OpportunitiesDaoImpl();
        List<Opportunity> OppList = new ArrayList<>();
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                String searchQuery = request.getParameter("search");
                String stageFilter = request.getParameter("stage");

                // Keep parameters for UI state
                request.setAttribute("searchQuery", searchQuery);
                request.setAttribute("stageFilter", stageFilter);

                OppList = oop.searchOpportunities(user.getId(), searchQuery, stageFilter);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("opportunityList", OppList);

        request.getRequestDispatcher("/views/sales/opportunity-list.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            OpportunityDAO oop = new OpportunitiesDaoImpl();
            int OpportunityID = Integer.parseInt(request.getParameter("opportunityId"));
            String stage = request.getParameter("stage");
            int Probability = calculateProbability(stage);
            oop.updateStage(OpportunityID, stage, Probability);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("opportunities");
    }
    private int calculateProbability(String stage) {
        return switch (stage) {
            case "Prospecting" -> 20;
            case "Negotiation" -> 70;
            case "Won" -> 100;
            case "Lost" -> 0;
            default -> 0;
        };
    }
}
