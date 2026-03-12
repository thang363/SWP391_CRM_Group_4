package controller.lead;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.LeadNoteDAO;
import dao.impl.LeadNoteDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.LeadNote;
import util.LocalDateTimeAdapter;

/**
 * AJAX Servlet to fetch notes for a specific lead.
 */
@WebServlet(name = "GetLeadNotesServlet", urlPatterns = {"/getLeadNotes"})
public class GetLeadNotesServlet extends HttpServlet {

    private final LeadNoteDAO noteDAO = new LeadNoteDAOImpl();
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDateTime.class, new LocalDateTimeAdapter())
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        try {
            String leadIdStr = request.getParameter("leadId");
            if (leadIdStr != null && !leadIdStr.isEmpty()) {
                int leadId = Integer.parseInt(leadIdStr);
                List<LeadNote> notes = noteDAO.findByLeadId(leadId);
                out.print(gson.toJson(notes));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing leadId parameter\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = e.getMessage() != null ? e.getMessage().replace("\"", "'") : "Unknown Server Error";
            out.print("{\"error\": \"Server Error: " + errorMessage + "\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}
