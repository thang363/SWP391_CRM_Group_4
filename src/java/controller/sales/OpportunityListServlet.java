package controller.sales;

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
import model.entity.OpportunityNote;
import dao.OpportunityNoteDAO;
import dao.impl.OpportunityNoteDAOImpl;
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
        String pageParam = request.getParameter("page");
        int page = 1;
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
        int totalPages = (int)Math.ceil((double)OppList.size()/10);
        
        try {
            page = Integer.parseInt(pageParam);
        } catch (Exception e) {
            page = 1;
        }
        List<Opportunity> newOppList = new ArrayList<>();
        if(page<totalPages){
            newOppList = OppList.subList((page-1)*10, page*10);
        }else{
            newOppList = OppList.subList((page-1)*10, OppList.size());
        }
            
        request.setAttribute("page", page);
        request.setAttribute("NewOpportunityList", newOppList);
        request.setAttribute("opportunityList", OppList);
        request.setAttribute("totalPage", totalPages);

        request.getRequestDispatcher("/views/sales/opportunity-list.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        try {
            OpportunityDAO oop = new OpportunitiesDaoImpl();
            int OpportunityID = Integer.parseInt(request.getParameter("opportunityId"));
            String newStage = request.getParameter("stage");
            String notes = request.getParameter("notes");

            // Get current stage before update for logging
            Opportunity currentOpp = oop.getById(OpportunityID);
            String oldStage = (currentOpp != null) ? currentOpp.getStage() : "Unknown";

            int Probability = calculateProbability(newStage);
            oop.updateStage(OpportunityID, newStage, Probability);

            // Record note if present
            if (notes != null && !notes.trim().isEmpty() && user != null) {
                OpportunityNoteDAO noteDAO = new OpportunityNoteDAOImpl(DatabaseUtil.getInstance());
                OpportunityNote note = new OpportunityNote();
                note.setOpportunityId(OpportunityID);
                note.setSalesId(user.getId()); // Use current user ID as sales_id
                note.setNoteType("Stage Change");
                note.setNoteContent("Chuyển giai đoạn từ [" + oldStage + "] sang [" + newStage + "]. Ghi chú: " + notes);
                note.setOldStage(oldStage);
                note.setNewStage(newStage);
                note.setIsImportant(false);
                noteDAO.createNote(note);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("opportunities");
    }
    private int calculateProbability(String stage) {
        return switch (stage) {
            case "Prospecting" -> 10;
            case "Qualification" -> 25;
            case "Proposal" -> 50;
            case "Negotiation" -> 70;
            case "Won" -> 100;
            case "Lost" -> 0;
            default -> 0;
        };
    }
}
