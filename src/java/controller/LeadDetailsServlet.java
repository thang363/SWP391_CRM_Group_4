package controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Lead;
import util.DatabaseUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "LeadDetailsServlet", urlPatterns = {"/lead-details"})
public class LeadDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/leads");
            return;
        }

       
        try {
            int leadId = Integer.parseInt(idParam);
            
            // Use standard DAO pattern
            dao.LeadDAO leadDao = new dao.impl.LeadDAOImpl();
            Lead lead = leadDao.findById(leadId);

            if (lead == null) {
                response.sendRedirect(request.getContextPath() + "/leads");
                return;
            }

            request.setAttribute("lead", lead);
            request.setAttribute("pageTitle", "Lead Details: " + lead.getFullName());

            // Mock Data for Interactions (Timeline) - temporary for demo
            List<String> mockTimeline = new ArrayList<>();
            mockTimeline.add("Called client on 15/01/2026 - Interested but busy.");
            mockTimeline.add("Sent email with brochure on 16/01/2026.");
            mockTimeline.add("Client visited website on 18/01/2026.");
            request.setAttribute("timeline", mockTimeline);

            request.getRequestDispatcher("/views/sales/lead-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/leads");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
