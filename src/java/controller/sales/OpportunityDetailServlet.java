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
import model.entity.Quote;

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

            List<Quote> quotes = quoteDAO.getByOpportunityId(oppId);
            boolean hasActiveSent = quoteDAO.hasActiveSent(oppId);

            request.setAttribute("opp", opp);
            request.setAttribute("quotes", quotes);
            request.setAttribute("hasActiveSent", hasActiveSent);
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
}
