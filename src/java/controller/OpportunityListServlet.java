package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "OpportunityListServlet", urlPatterns = {"/opportunities"})
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
        request.setAttribute("opportunityList", new ArrayList<>());

        request.getRequestDispatcher("/views/sales/opportunity-list.jsp").forward(request, response);
    }
}
