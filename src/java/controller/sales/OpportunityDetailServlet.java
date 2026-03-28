package controller.sales;

import dao.OpportunityDAO;
import dao.QuoteDAO;
import dao.impl.OpportunitiesDaoImpl;
import dao.impl.QuoteDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Opportunity;
import model.entity.Opportunity;
import model.entity.Quote;
import model.entity.User;
import model.entity.OpportunityNote;
import dao.OpportunityNoteDAO;
import dao.impl.OpportunityNoteDAOImpl;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OpportunityDetailServlet", urlPatterns = {"/sales/opportunity-detail"})
public class OpportunityDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sales/opportunities");
            return;
        }

        try {
            int oppId = Integer.parseInt(idParam);
            OpportunityDAO oppDAO = new OpportunitiesDaoImpl();
            QuoteDAO quoteDAO = new QuoteDAOImpl();

            Opportunity opp = oppDAO.getById(oppId);
            if (opp == null) {
                response.sendRedirect(request.getContextPath() + "/sales/opportunities");
                return;
            }

            // Cập nhật trạng thái 'Hết hạn' trước khi lấy danh sách
            quoteDAO.updateExpiredQuotes(oppId);

            List<Quote> quotes = quoteDAO.getByOpportunityId(oppId);
            
            // Nạp thêm chi tiết sản phẩm vào mỗi quote để show modal
            dao.QuoteDetailDAO quoteDetailDAO = new dao.impl.QuoteDetailDAOImpl();
            for (Quote q : quotes) {
                q.setDetails(quoteDetailDAO.getByQuoteId(q.getId()));
            }

            boolean hasActiveSent = quoteDAO.hasActiveSent(oppId);

            dao.OpportunityProductDAO oppProductDAO = new dao.impl.OpportunityProductDAOImpl();
            List<model.entity.OpportunityProduct> oppProducts = oppProductDAO.getByOpportunityId(oppId);

            dao.ProductDAO productDAO = new dao.impl.ProductDAOImpl();
            List<model.entity.Product> products = productDAO.getAllActiveProducts();
            request.setAttribute("productList", products);

            request.setAttribute("opp", opp);
            request.setAttribute("quotes", quotes);
            request.setAttribute("oppProducts", oppProducts);
            request.setAttribute("hasActiveSent", hasActiveSent);
            
            OpportunityNoteDAO noteDAO = new OpportunityNoteDAOImpl(util.DatabaseUtil.getInstance());
            List<OpportunityNote> notes = noteDAO.getNotesByOpportunityId(oppId);
            request.setAttribute("notes", notes);
            request.setAttribute("currentPage", "opportunities");

            // Tab mặc định
            String tab = request.getParameter("tab");
            if (tab == null) tab = "overview";
            request.setAttribute("activeTab", tab);

            request.getRequestDispatcher("/views/sales/opportunity-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sales/opportunities");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update_stage".equals(action)) {
            try {
                int oppId = Integer.parseInt(request.getParameter("id"));
                String newStage = request.getParameter("stage");
                String notesContent = request.getParameter("notes");
                
                User user = (User) request.getSession().getAttribute("currentUser");
                if (user != null) {
                    OpportunityDAO oppDAO = new OpportunitiesDaoImpl();
                    Opportunity oldOpp = oppDAO.getById(oppId);
                    String oldStage = oldOpp != null ? oldOpp.getStage() : "";
                    
                    // Update stage
                    int probability = calculateProbability(newStage);
                    // The method updateStage exists since it's used in OpportunityListServlet
                    // We need to cast or just use raw implementation if interface lacks it.
                    // Wait, OpportunityListServlet uses OpportunityDAO oop = new OpportunitiesDaoImpl(); oop.updateStage(...)
                    // So it must be in the interface or we cast. We will use OpportunitiesDaoImpl directly.
                    OpportunitiesDaoImpl oppDaoImpl = new OpportunitiesDaoImpl();
                    oppDaoImpl.updateStage(oppId, newStage, probability);
                    
                    // Record note
                    if (notesContent != null && !notesContent.trim().isEmpty()) {
                        OpportunityNoteDAO noteDAO = new OpportunityNoteDAOImpl(util.DatabaseUtil.getInstance());
                        OpportunityNote note = new OpportunityNote(oppId, user.getId(), notesContent.trim(), "StageChange");
                        note.setOldStage(oldStage);
                        note.setNewStage(newStage);
                        noteDAO.createNote(note);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/sales/opportunity-detail?id=" + oppId + "&tab=activity");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/sales/opportunities");
            }
        } else if ("add_note".equals(action)) {
            try {
                int oppId = Integer.parseInt(request.getParameter("opportunityId"));
                String notesContent = request.getParameter("noteContent");
                String noteType = request.getParameter("noteType");
                
                User user = (User) request.getSession().getAttribute("currentUser");
                if (user != null && notesContent != null && !notesContent.trim().isEmpty()) {
                    OpportunityNoteDAO noteDAO = new OpportunityNoteDAOImpl(util.DatabaseUtil.getInstance());
                    OpportunityNote note = new OpportunityNote(oppId, user.getId(), notesContent.trim(), noteType);
                    noteDAO.createNote(note);
                }
                response.sendRedirect(request.getContextPath() + "/sales/opportunity-detail?id=" + oppId + "&tab=activity");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/sales/opportunities");
            }
        }
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
