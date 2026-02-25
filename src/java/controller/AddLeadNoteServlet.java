package controller;

import dao.LeadNoteDAO;
import dao.impl.LeadNoteDAOImpl;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.LeadNote;
import model.entity.User;
import java.time.LocalDateTime;

/**
 * Servlet to handle adding a new interaction note for a lead.
 */
@WebServlet(name = "AddLeadNoteServlet", urlPatterns = {"/addLeadNote"})
public class AddLeadNoteServlet extends HttpServlet {

    private final LeadNoteDAO noteDAO = new LeadNoteDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int leadId = Integer.parseInt(request.getParameter("leadId"));
            String content = request.getParameter("content");
            String type = request.getParameter("type"); // Optional

            if (content != null && !content.trim().isEmpty()) {
                LeadNote note = new LeadNote();
                note.setLeadId((long) leadId);
                note.setSalesId(currentUser.getId());
                note.setNoteContent(content.trim());
                note.setNoteType(type != null ? type : "General");
                note.setIsImportant(false);
                note.setCreatedAt(LocalDateTime.now());

                noteDAO.insert(note);
            }
            
            // Redirect back to leads list
            response.sendRedirect(request.getContextPath() + "/leads");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/leads?error=note");
        }
    }
}
